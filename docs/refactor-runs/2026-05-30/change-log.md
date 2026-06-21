# Change Log — "Mock-ups → complete implementations" pass (2026-05-30)

**Goal:** The served site (`001-apps/001-site`, justiciadministrativa.com) was reported as looking
like "mock-ups / incomplete stuff, some parts useless". This pass makes every view render as a
complete, honest implementation.

**Diagnosis (evidence-based audit of all 90+ view/component files + the live DB).** The
"mock-up feel" was three distinct problems stacked on genuinely-real code:

1. **Content** — fabricated placeholder copy a backend pass never touches.
2. **Wiring** — ~25 buttons with empty `onPressed: () {}` (real-looking UI, no behaviour).
3. **Data** — every Supabase table had **0 rows**, so the whole portal + blog rendered empty states.

**User decisions (AskUserQuestion):** (1) *Remove* fabricated claims now; (2) *Wire* buttons with a
real destination, *hide* buttons for not-yet-built features; (3) *Seed* labelled demo data + a demo login.

---

## 1. Fabricated content removed (public site)

| Item | File | Action |
|---|---|---|
| 3 fake testimonials (stock faces, "resultados reales") | `components/testimonials.dart` + `views/contact_view.dart` | Section unmounted; file **deleted** |
| Orphaned `StatsSection` ("500+/50+/10+", 0 call-sites) | `components/stats.dart` | File **deleted** (dead code) |
| 4 fake offices + placeholder phones (`+52 55 1234-5678`) | `contact/contact_section_models.dart` | Reduced to one honest CDMX card; no fabricated phone/hours/email |
| Fake "Mapa Global de Oficinas" stock image | `contact/contact_offices.dart` | **Removed**; grid re-centred for a single card |
| "2,000 horas / 500+ casos desde 2010 / 25+ universidades" (contradict 2025 founding) | `about/about_affiliation_leadership.dart` | Fabricated quantities removed; programs kept as honest copy |
| "Más de 20 años de experiencia" (contradicts 2025) | `home/home_preview_cards_section.dart:93` | Rewritten without the false claim |
| Fake ES/EN language switch (not even clickable) | `navbar/navbar_actions.dart` + `navbar.dart` + `navbar/navbar_mobile_menu.dart` | `_LanguageSwitch` **removed** (no i18n exists) |
| Wrong "16 áreas / 100 servicios" copy (actual 17) | `services/services_practice_areas.dart` | Counts now derived from the data list (`fold`) — can't drift |

## 2. Buttons wired / hidden

**Wired to real destinations** (`context.go(...)`):
- Hero "Consulta Legal" → `/contacto`, "Demo IA" → `/asistente-ia` (`components/hero.dart`)
- Services "Conocer más" ×3 + "Solicitar Consulta" ×17 → `/contacto`; "Explorar Demo IA" ×3 → `/asistente-ia`
- Contact breadcrumb "Inicio" → `/` (`components/contact.dart`)

**Hidden (feature not built / no destination):**
- "Nuevo Asunto" (clients don't create matters) — `matters/matters_page_header.dart`
- "Ver Detalles" context item (kept working "Visualizar Reporte") — `matters/matter_card.dart`
- Message paperclip attach + compose icon — `messages/messages_composer.dart`, `messages/messages_sidebar.dart`
- Document-card kebab (no menu) — `portal/documents_view.dart`
- Settings "Notificaciones" toggles (persisted nothing) — `portal/settings_view.dart`
- Footer social icons (no firm accounts) + legal links (pages don't exist) — `components/footer.dart`

## 3. Misleading "demo" signals fixed (portal)

- **AI "inicia sesión" demo banner** shown to logged-in users → **removed** (route is auth-gated; `demo_banner.dart` deleted). `views/ai_assistant_view.dart`.
- **AI "Fuentes y Contexto" panel** never populated → wired: `AiAssistantView` lifts `_sources`, passes `ChatArea(onSourcesUpdated:)` → `SidebarRight(sources:)`.
- **Dashboard upcoming deadlines** loaded but never rendered (`// ignore: unused_field`) → now rendered as a "Tareas próximas" list (`_DashboardTaskRow`). `portal/dashboard_view.dart`.
- **Blog share URL** used the unrouted `new.` subdomain → fixed to `justiciadministrativa.com`. `components/blog.dart`.
- **Blog newsletter** showed fake success → now persists via new `NewsletterService` → `newsletter_subscribers` table (migration `supabase_migrations/20260530_create_newsletter_subscribers.sql`).

## 4. Demo data + login (the empty-DB fix)

Reproducible script `scripts/seed-demo-data.sh` (idempotent; `--wipe` to remove). Creates a demo client +
demo lawyer (auth users; `lawyers.id == lawyer uid` per schema), uploads one sample PDF to the public
`clients` bucket, and inserts **4 matters, 4 invoices, 5 documents, 4 events, 3 tasks, 5 messages** for the
client plus **4 published blog articles**.

**End-to-end verification (real auth + REST, RLS-enforced):**
- Demo client login → access token OK.
- Matters visible: 4 (3 active). Stats RPC: `{active_matters:3, total_documents:5, upcoming_events:2, pending_invoices:2}`.
- Client-visible counts: invoices 4, documents 5, events 4, tasks 3, messages 5.
- Public blog (anon): 4 articles.

Demo login (random per seed) saved to `/home/emilio/justicia-demo-login.txt` (chmod 600).

---

## Verification

- `flutter analyze` → **No issues found!** (0, baseline preserved).
- `flutter test` → **286 / 286 pass** (no test referenced a removed element).
- PlantUML `ai-consultation-slice.puml` updated (removed `DemoBanner`, added wired `SidebarRight`) + recompiled to SVG, 0 errors.

## Deferred / follow-ups for the owner

- Provide **real** office contact details / testimonials / founding stats to replace the removed placeholders.
- Decide whether to **build** the hidden features (per-invoice pay/download, message attachments, notification preferences) — infra/Stripe work.
- A real **Aviso de Privacidad / Términos** page (legally advisable for a MX firm) — footer links were hidden, not built.
- Review/replace the 4 **sample blog articles** with final content; they are genuine but illustrative.
- Demo data is wipe-able before real launch: `scripts/seed-demo-data.sh --wipe`.

---

## Addendum (same day) — 4 hidden controls rebuilt as real features

The owner reported the hidden buttons read as lost functionality and asked for them as
*working* features (not just un-hidden stubs). All four were dead `onPressed: () {}` stubs;
each is now functional:

1. **Message attachments** — `MessagesComposer` paperclip → `FilePicker` → `PortalService.uploadMessageAttachment` (new) → `sendPortalMessage(attachmentUrl/Name)`; pending-attachment chip + upload spinner; `MessageBubble` renders received attachments as a tappable link.
2. **Matter detail view** — `MatterDetailModal` (new) opened by "Ver Detalles"; shows the matter header + its documents, events, invoices and recent messages (events/invoices scoped client-side by `matterId`).
3. **Create a matter** — "Nuevo Asunto" → `NewMatterDialog` (new) → `PortalService.createMatter` (new, RLS-permitted client insert with a `SOL-` reference); list refreshes via a `reloadToken` key.
4. **New conversation** — sidebar compose icon → matter picker → opens the chosen thread.

**Pre-existing bug found + fixed:** the public `clients` storage bucket had **no authenticated
upload policy**, so portal document upload *and* message attachments failed at runtime
("violates row-level security"). Added `supabase_migrations/20260530_clients_bucket_upload_policy.sql`
(insert/read/delete scoped to `clients/{uid}/…`, mirroring `chat-attachments`); applied to the live DB.

**Verification (real auth + REST/storage):** client matter insert → 201; storage upload to
`clients/{uid}/messages/` → 200; message-with-attachment insert → 201; matter detail data reads OK.
`flutter analyze` 0; **290/290 tests** pass (4 new: matter-detail modal ×2, composer attachment ×2).
Deployed (content hash `615eb810`).
