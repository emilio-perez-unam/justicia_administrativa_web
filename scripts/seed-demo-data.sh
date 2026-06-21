#!/usr/bin/env bash
#
# seed-demo-data.sh — Populate the self-hosted Supabase with clearly-labelled
# DEMO data so every portal tab and the public blog render fully, plus a demo
# client login. Idempotent: re-running wipes the previous demo rows first.
#
# Wipe later with:  scripts/seed-demo-data.sh --wipe
#
# Requires: docker (supabase-db container), passwordless sudo to read secrets.
set -euo pipefail

ENV_FILE=/mnt/supabase/.env
KONG="http://127.0.0.1:8000"
CLIENT_EMAIL="cliente.demo@justiciadministrativa.com"
LAWYER_EMAIL="abogado.demo@justiciadministrativa.com"

SERVICE_KEY="$(sudo grep '^SERVICE_ROLE_KEY=' "$ENV_FILE" | cut -d= -f2-)"
PW_DB="$(sudo grep '^POSTGRES_PASSWORD=' "$ENV_FILE" | cut -d= -f2-)"

psql_admin() {
  docker exec -i -e PGPASSWORD="$PW_DB" supabase-db \
    psql -U supabase_admin -d postgres -v ON_ERROR_STOP=1 "$@"
}

BLOG_SLUGS="('amparo-materia-administrativa','licitaciones-publicas-participar-impugnar','responsabilidad-patrimonial-estado','ia-derecho-administrativo')"

wipe() {
  echo "==> wiping previous demo data"
  psql_admin <<SQL
delete from public.tasks where category = 'demo-seed';
delete from public.blog_posts where slug in ${BLOG_SLUGS};
delete from public.lawyers where id in (select id from auth.users where email = '${LAWYER_EMAIL}');
delete from auth.users where email in ('${CLIENT_EMAIL}', '${LAWYER_EMAIL}');
SQL
}

if [[ "${1:-}" == "--wipe" ]]; then
  wipe
  echo "==> demo data wiped."
  exit 0
fi

wipe  # ensure a clean slate before re-seeding

# ---------------------------------------------------------------------------
# 1. Create the demo auth users (lawyer + client) via the GoTrue admin API.
# ---------------------------------------------------------------------------
CLIENT_PW="Demo-$(openssl rand -hex 6)-2026"
LAWYER_PW="Lwy-$(openssl rand -hex 6)-2026"

create_user() { # email password full_name
  curl -s -X POST "$KONG/auth/v1/admin/users" \
    -H "apikey: $SERVICE_KEY" -H "Authorization: Bearer $SERVICE_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$1\",\"password\":\"$2\",\"email_confirm\":true,\"user_metadata\":{\"full_name\":\"$3\"}}"
}
json_id() { python3 -c 'import sys,json; print(json.load(sys.stdin)["id"])'; }

echo "==> creating demo auth users"
LAWYER_UID="$(create_user "$LAWYER_EMAIL" "$LAWYER_PW" "Alfredo Delgadillo Lopez" | json_id)"
CLIENT_UID="$(create_user "$CLIENT_EMAIL" "$CLIENT_PW" "Maria Gonzalez Hernandez" | json_id)"
[[ -n "$LAWYER_UID" && -n "$CLIENT_UID" ]] || { echo "FATAL: user creation failed"; exit 1; }
echo "    client uid = $CLIENT_UID"
echo "    lawyer uid = $LAWYER_UID"

# ---------------------------------------------------------------------------
# 2. Generate one valid sample PDF and upload it to the public `clients` bucket.
#    Every demo document points at it so the card tap actually opens a file.
# ---------------------------------------------------------------------------
echo "==> generating + uploading sample document"
python3 - "$CLIENT_UID" > /tmp/demo-sample.pdf <<'PY'
import sys
objs = [
 b"<< /Type /Catalog /Pages 2 0 R >>",
 b"<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
 b"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>",
 None,  # filled below
 b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>",
]
text = (b"BT /F1 20 Tf 72 710 Td (Documento de muestra) Tj "
        b"0 -30 Td /F1 12 Tf (JusticIAdministrativa - cuenta demostrativa) Tj ET")
objs[3] = b"<< /Length %d >>\nstream\n%s\nendstream" % (len(text), text)
out = b"%PDF-1.4\n"; offs = []
for i, o in enumerate(objs, 1):
    offs.append(len(out)); out += b"%d 0 obj\n%s\nendobj\n" % (i, o)
xref = len(out)
out += b"xref\n0 %d\n0000000000 65535 f \n" % (len(objs) + 1)
for off in offs: out += b"%010d 00000 n \n" % off
out += b"trailer\n<< /Size %d /Root 1 0 R >>\nstartxref\n%d\n%%%%EOF\n" % (len(objs) + 1, xref)
sys.stdout.buffer.write(out)
PY

DOC_PATH="$CLIENT_UID/demo-sample.pdf"
curl -s -X POST "$KONG/storage/v1/object/clients/$DOC_PATH" \
  -H "apikey: $SERVICE_KEY" -H "Authorization: Bearer $SERVICE_KEY" \
  -H "Content-Type: application/pdf" --data-binary @/tmp/demo-sample.pdf >/dev/null
DOC_URL="https://supabase.justiciadministrativa.com/storage/v1/object/public/clients/$DOC_PATH"

# ---------------------------------------------------------------------------
# 3. Insert all demo rows (as supabase_admin -> bypasses RLS INSERT checks; the
#    rows still satisfy every SELECT policy for the demo client).
# ---------------------------------------------------------------------------
M1="$(python3 -c 'import uuid;print(uuid.uuid4())')"
M2="$(python3 -c 'import uuid;print(uuid.uuid4())')"
M3="$(python3 -c 'import uuid;print(uuid.uuid4())')"
M4="$(python3 -c 'import uuid;print(uuid.uuid4())')"

echo "==> inserting demo portal data"
psql_admin \
  -v client_uid="$CLIENT_UID" -v lawyer_uid="$LAWYER_UID" -v doc_url="$DOC_URL" \
  -v m1="$M1" -v m2="$M2" -v m3="$M3" -v m4="$M4" <<'SQL'
-- Lawyer: lawyers.id == the lawyer's auth uid (schema intent).
insert into public.lawyers (id, full_name, title, email, specialty, is_active)
values (:'lawyer_uid', 'Alfredo Delgadillo Lopez', 'Lic.', 'abogado.demo@justiciadministrativa.com', 'Derecho Administrativo y Amparo', true)
on conflict (id) do update set full_name = excluded.full_name, specialty = excluded.specialty;

-- Client profile (the on_auth_user_created trigger already inserted the row).
update public.profiles
   set full_name = 'Maria Gonzalez Hernandez',
       company   = 'Constructora del Valle S.A. de C.V.',
       phone     = '+52 55 5555 1010'
 where id = :'client_uid';

-- Matters (3 active -> en_proceso/revision drive the dashboard stat).
insert into public.matters (id, client_id, lawyer_id, reference_code, title, subtitle, matter_type, status, last_update) values
 (:'m1', :'client_uid', :'lawyer_uid', 'DEMO-2026-001', 'Amparo contra resolucion del SAT', 'Credito fiscal impugnado', 'amparo', 'en_proceso', now() - interval '2 days'),
 (:'m2', :'client_uid', :'lawyer_uid', 'DEMO-2026-002', 'Licitacion publica LA-009-2026', 'Obra carretera tramo norte', 'licitacion', 'revision', now() - interval '5 days'),
 (:'m3', :'client_uid', :'lawyer_uid', 'DEMO-2026-003', 'Programa de integridad y compliance', 'Implementacion anticorrupcion', 'compliance', 'en_proceso', now() - interval '1 day'),
 (:'m4', :'client_uid', :'lawyer_uid', 'DEMO-2026-004', 'Consulta de responsabilidad patrimonial', 'Dictamen preliminar', 'consulta', 'completado', now() - interval '20 days');

-- Invoices (2 pendiente -> drive the pending stat + pie chart).
insert into public.invoices (client_id, matter_id, invoice_number, description, amount, currency, status, due_date, paid_at, file_url) values
 (:'client_uid', :'m1', 'INV-2026-0001', 'Honorarios fase inicial de amparo', 45000.00, 'MXN', 'pendiente', (now() + interval '8 days')::date, null, :'doc_url'),
 (:'client_uid', :'m2', 'INV-2026-0002', 'Asesoria en licitacion publica', 80000.00, 'MXN', 'pagada', (now() - interval '15 days')::date, now() - interval '10 days', :'doc_url'),
 (:'client_uid', :'m3', 'INV-2026-0003', 'Implementacion de compliance', 30000.00, 'MXN', 'pendiente', (now() + interval '20 days')::date, null, :'doc_url'),
 (:'client_uid', :'m4', 'INV-2026-0004', 'Dictamen de responsabilidad patrimonial', 15000.00, 'MXN', 'pagada', (now() - interval '30 days')::date, now() - interval '25 days', :'doc_url');

-- Documents (5 -> drive the documents stat; tap opens the uploaded sample PDF).
insert into public.documents (matter_id, client_id, name, file_url, file_size, mime_type, category, uploaded_by) values
 (:'m1', :'client_uid', 'Demanda de amparo.pdf',          :'doc_url', 48211, 'pdf', 'demanda',    :'lawyer_uid'),
 (:'m1', :'client_uid', 'Resolucion impugnada SAT.pdf',   :'doc_url', 51200, 'pdf', 'resolucion', :'lawyer_uid'),
 (:'m2', :'client_uid', 'Bases de licitacion.pdf',        :'doc_url', 73400, 'pdf', 'contrato',   :'lawyer_uid'),
 (:'m3', :'client_uid', 'Politica de integridad.pdf',     :'doc_url', 29550, 'pdf', 'contrato',   :'lawyer_uid'),
 (:'m2', :'client_uid', 'Factura INV-2026-0002.pdf',      :'doc_url', 18020, 'pdf', 'factura',    :'lawyer_uid');

-- Calendar events (2 within the next 7 days -> drive the upcoming stat).
insert into public.calendar_events (client_id, matter_id, title, description, event_type, event_date, location) values
 (:'client_uid', :'m1', 'Audiencia constitucional', 'Desahogo de la audiencia del juicio de amparo', 'audiencia', now() + interval '3 days', 'Juzgado de Distrito, CDMX'),
 (:'client_uid', :'m3', 'Entrega de documentacion', 'Entrega de soporte para el programa de integridad', 'entrega', now() + interval '5 days', 'Oficina del cliente'),
 (:'client_uid', :'m2', 'Reunion de seguimiento', 'Revision del estatus de la licitacion', 'reunion', now() + interval '12 days', 'Videollamada'),
 (:'client_uid', :'m2', 'Vencimiento para impugnar', 'Ultimo dia para presentar inconformidad', 'vencimiento', now() + interval '20 days', null);

-- Tasks (assigned_to = client so RLS shows them; within 30 days for the dashboard).
insert into public.tasks (title, description, priority, status, assigned_to, assignee_name, created_by, due_date, category) values
 ('Firmar poder notarial', 'Acudir a la notaria para otorgar el poder', 'alta', 'pendiente', :'client_uid', 'Maria Gonzalez Hernandez', :'lawyer_uid', now() + interval '2 days', 'demo-seed'),
 ('Entregar comprobantes fiscales', 'Reunir y enviar las facturas del ejercicio', 'media', 'en_progreso', :'client_uid', 'Maria Gonzalez Hernandez', :'lawyer_uid', now() + interval '6 days', 'demo-seed'),
 ('Revisar borrador de demanda', 'Revisar y comentar el borrador antes de presentarlo', 'media', 'pendiente', :'client_uid', 'Maria Gonzalez Hernandez', :'lawyer_uid', now() + interval '10 days', 'demo-seed');

-- Portal messages (visible to the client via matter ownership).
insert into public.portal_messages (matter_id, sender_id, sender_type, content, is_read, created_at) values
 (:'m1', :'lawyer_uid', 'lawyer', 'Hemos presentado la demanda de amparo. Le notificaremos la fecha de audiencia.', true,  now() - interval '2 days'),
 (:'m1', :'client_uid', 'client', 'Gracias, licenciado. Quedo atenta a la fecha.', true,  now() - interval '2 days' + interval '1 hour'),
 (:'m1', :'lawyer_uid', 'lawyer', 'La audiencia constitucional ya quedo programada. Puede verla en su calendario.', false, now() - interval '6 hours'),
 (:'m3', :'lawyer_uid', 'lawyer', 'Le comparto la politica de integridad para su revision.', true,  now() - interval '1 day'),
 (:'m3', :'client_uid', 'client', 'Recibido, la reviso durante esta semana.', true,  now() - interval '20 hours');
SQL

# ---------------------------------------------------------------------------
# 4. Publish sample blog articles (genuine Spanish content, review/replace later).
# ---------------------------------------------------------------------------
echo "==> publishing sample blog articles"
psql_admin <<'SQL'
insert into public.blog_posts
 (title, slug, excerpt, content, category, tags, image_url, author_name, author_role, author_bio, author_image_url, read_minutes, is_featured, is_published, published_at)
values
 ('Que es el juicio de amparo en materia administrativa',
  'amparo-materia-administrativa',
  $$El amparo es la principal herramienta para defenderse de actos de autoridad que vulneran derechos. Explicamos cuando procede frente a la administracion publica.$$,
  $$El juicio de amparo es el medio de control constitucional por excelencia en Mexico. En materia administrativa permite a las personas impugnar actos y resoluciones de autoridades -como creditos fiscales, multas, clausuras o negativas de tramites- cuando vulneran derechos reconocidos por la Constitucion.

Procede, por regla general, contra actos definitivos que causan un perjuicio actual. Existen dos vias: el amparo indirecto, que se promueve ante un Juzgado de Distrito contra actos de autoridades administrativas, y el amparo directo, reservado a sentencias definitivas de tribunales como el Tribunal Federal de Justicia Administrativa.

El plazo ordinario para promoverlo es de quince dias habiles a partir de que surte efectos la notificacion del acto, aunque existen excepciones. Una estrategia adecuada exige identificar con precision el acto reclamado, la autoridad responsable y los conceptos de violacion. Un acompanamiento tecnico oportuno suele marcar la diferencia entre un sobreseimiento y una sentencia favorable.$$,
  'Derecho Administrativo', '{amparo,administrativo,constitucional}',
  'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1200',
  'Alfredo Delgadillo Lopez', 'Socio Director',
  'Especialista en derecho administrativo, amparo y contratacion publica.',
  'https://ui-avatars.com/api/?name=Alfredo+Delgadillo&background=1E3A8A&color=fff&size=128',
  6, true, true, now() - interval '3 days'),

 ('Licitaciones publicas: como participar e impugnar',
  'licitaciones-publicas-participar-impugnar',
  $$Participar en una licitacion exige conocer las bases, los plazos y los medios de defensa. Repasamos lo esencial para competir e inconformarse con exito.$$,
  $$Las contrataciones del sector publico se rigen por principios de eficiencia, imparcialidad y transparencia. Para participar, el primer paso es analizar la convocatoria y las bases: requisitos de capacidad tecnica y economica, criterios de evaluacion y el calendario del procedimiento.

Cuando un licitante considera que un acto del procedimiento -las bases, la junta de aclaraciones o el fallo- es contrario a derecho, puede presentar una inconformidad ante la autoridad de control o acudir a la via contenciosa. Los plazos son breves y fatales, por lo que la oportunidad es decisiva.

Documentar cada etapa, conservar acuses y formular argumentos tecnicos solidos incrementa de forma sustancial las probabilidades de exito, tanto para obtener la adjudicacion como para revertir un fallo indebido.$$,
  'Contratacion Publica', '{licitaciones,contratacion,compliance}',
  'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1200',
  'Alfredo Delgadillo Lopez', 'Socio Director',
  'Especialista en derecho administrativo, amparo y contratacion publica.',
  'https://ui-avatars.com/api/?name=Alfredo+Delgadillo&background=1E3A8A&color=fff&size=128',
  5, false, true, now() - interval '7 days'),

 ('Responsabilidad patrimonial del Estado: como reclamar',
  'responsabilidad-patrimonial-estado',
  $$Cuando la actividad administrativa irregular causa un dano, el Estado debe indemnizar. Explicamos los requisitos para que la reclamacion prospere.$$,
  $$La responsabilidad patrimonial del Estado obliga a la administracion a reparar los danos que cause su actividad irregular. A diferencia de otros regimenes, no requiere demostrar la culpa de un servidor publico: basta acreditar el dano, la actividad administrativa y el nexo causal entre ambos.

El dano debe ser real, evaluable en dinero e individualizado. La reclamacion se presenta ante la propia autoridad y, de ser negada, puede combatirse ante el Tribunal Federal de Justicia Administrativa. La carga probatoria y el calculo de la indemnizacion son los puntos mas sensibles del procedimiento.

Reunir dictamenes, periciales y un soporte documental robusto desde el inicio es clave. Una reclamacion bien construida no solo busca la indemnizacion, sino tambien sentar un precedente sobre el funcionamiento de los servicios publicos.$$,
  'Derecho Administrativo', '{responsabilidad,estado,indemnizacion}',
  'https://images.unsplash.com/photo-1505664194779-8beaceb93744?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1200',
  'Alfredo Delgadillo Lopez', 'Socio Director',
  'Especialista en derecho administrativo, amparo y contratacion publica.',
  'https://ui-avatars.com/api/?name=Alfredo+Delgadillo&background=1E3A8A&color=fff&size=128',
  6, false, true, now() - interval '12 days'),

 ('Inteligencia artificial en el derecho administrativo',
  'ia-derecho-administrativo',
  $$La IA esta transformando la practica juridica. Analizamos como la busqueda semantica y el analisis predictivo apoyan -sin sustituir- el criterio del abogado.$$,
  $$La inteligencia artificial ha dejado de ser una promesa para convertirse en una herramienta de uso diario en el derecho. En materia administrativa, los modelos de lenguaje permiten localizar criterios, tesis y precedentes en segundos, y contrastar un caso con miles de resoluciones previas.

La busqueda semantica sobre un corpus juridico bien construido reduce el tiempo de investigacion y disminuye el riesgo de pasar por alto un precedente relevante. El analisis predictivo, por su parte, ayuda a estimar escenarios y a priorizar estrategias, siempre como apoyo a la decision profesional.

La tecnologia no sustituye el criterio juridico: lo potencia. Un despacho que combina conocimiento especializado con herramientas de IA responsables ofrece a sus clientes respuestas mas rapidas, precisas y trazables, manteniendo la responsabilidad profesional en el centro.$$,
  'LegalTech', '{ia,legaltech,innovacion}',
  'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1200',
  'Alfredo Delgadillo Lopez', 'Socio Director',
  'Especialista en derecho administrativo, amparo y contratacion publica.',
  'https://ui-avatars.com/api/?name=Alfredo+Delgadillo&background=1E3A8A&color=fff&size=128',
  5, false, true, now() - interval '1 day');
SQL

# ---------------------------------------------------------------------------
# 5. Apply the newsletter_subscribers migration (idempotent).
# ---------------------------------------------------------------------------
echo "==> applying newsletter_subscribers migration"
MIG="$(dirname "$0")/../supabase_migrations/20260530_create_newsletter_subscribers.sql"
psql_admin < "$MIG"

# ---------------------------------------------------------------------------
echo ""
echo "============================================================"
echo " DEMO SEED COMPLETE"
echo "   Portal login:  $CLIENT_EMAIL"
echo "   Password:      $CLIENT_PW"
echo "   (lawyer account $LAWYER_EMAIL / $LAWYER_PW — data only)"
echo "============================================================"
