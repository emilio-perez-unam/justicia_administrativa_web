import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';

import 'package:justicia_administrativa_web/core/constants/typography.dart';
import '../models/team_member.dart';


class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key, required this.memberId});

  final String memberId;

  // In a real app, this would be in a repository
  TeamMember? _getMemberById(String id) {
    final members = [
      const TeamMember(
        id: 'alfredo-delgadillo',
        name: 'Lic. Alfredo Delgadillo López',
        title: 'Fundador y Director General',
        imageUrl:
            'https://raw.githubusercontent.com/emilio-perez-unam/justicia_administrativa_web/master/assets/images/alfredo-delgadillo-lopez.jpg',
        location: 'Ciudad de México',
        type: MemberType.lawyer,
        specialties: [
          'Derecho Administrativo',
          'Derecho Digital',
          'Abogado Digital Certificado',
          'Litigio Público',
          'Expropiaciones',
        ],
        details: [
          'Fundador de justicIAdministrativa',
          'Profesor en universidades de México e Iberoamérica en temas de Derecho Administrativo y Digital',
          'Conductor del programa "Derecho Público en Acción"',
          'Coordinador del Seminario Derecho Administrativo 4RI - IIJUNAM',
          'Abogado Digital certificado por la Academia Mexicana de Derecho Informático',
        ],
        fullBio: '''
Fundador de justicIAdministrativa.

Profesor en universidades de México e Iberoamérica en temas de Derecho Administrativo y Digital.

Conferencista en diversas universidades de México, Madrid, Almería, La Coruña, asimismo en diversas universidades de Ecuador y Colombia. Asimismo ha sido profesor en diversos órganos jurisdiccionales de México e Iberoamérica.

Director ejecutivo de NATICUM.

Conductor del programa "Derecho Público en Acción", transmitido en las plataformas del Centro Virtual de Estudios de la Gestión Pública.

Autor y coordinador de libros sobre derecho administrativo y derecho digital.

Abogado Digital certificado por la Academia Mexicana de Derecho Informático.

Junto al Doctor Miguel Alejandro López Olvera coordina el Seminario Derecho Administrativo en la Cuarta Revolución Industrial en el IIJUNAM.

Dedicado al libre ejercicio de la abogacía como asesor jurídico y litigante en derecho público y derecho digital.

Licenciado en Derecho por la Universidad Autónoma de Nayarit. Con estudios de Maestría en Anticorrupción en la Universidad Panamericana.
  ''',
        education: [
          'Licenciado en Derecho - Universidad Autónoma de Nayarit',
          'Estudios de Maestría en Anticorrupción - Universidad Panamericana',
        ],
        achievements: [
          'Abogado Digital certificado por la Academia Mexicana de Derecho Informático',
          'Fundador de justicIAdministrativa',
          'Director ejecutivo de NATICUM',
          'Conductor del programa "Derecho Público en Acción"',
          'Coordinador del Seminario Derecho Administrativo en la Cuarta Revolución Industrial - IIJUNAM',
          'Columnista en diversos periódicos en México',
          'Profesor de Gobierno Digital en la Universidad Panamericana de Ciudad de México',
        ],
        previousPositions: [
          'Profesor en universidades de México e Iberoamérica',
          'Conferencista en universidades de México, Madrid, Almería, La Coruña',
          'Conferencista en universidades de Ecuador y Colombia',
          'Profesor en diversos órganos jurisdiccionales de México e Iberoamérica',
        ],
        admissions: ['México'],
        isFeatured: true,
        linkedinUrl: 'https://www.linkedin.com/in/alfredodelgadillomx/',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
      const TeamMember(
        id: 'luis-humberto-delgadillo',
        name: 'Dr. Luís Humberto Delgadillo Gutiérrez',
        title: 'Asesor y Consultor Jurídico Senior',
        imageUrl:
            'https://raw.githubusercontent.com/emilio-perez-unam/justicia_administrativa_web/master/assets/images/luis-delgadillo-gutierrez.jpg',
        location: 'Ciudad de México',
        type: MemberType.lawyer,
        specialties: [
          'Derecho Tributario',
          'Contratación pública',
          'Responsabilidades administrativas',
          'Derecho Fiscal',
        ],
        details: [
          'Doctor en Derecho por la UNAM',
          'Especialista en Derecho Tributario por la OEA/BID',
          'Ex Presidente de la Academia Mexicana de Derecho Fiscal',
          'Ex Magistrado del Tribunal Federal de Justicia Fiscal y Administrativa',
          'Más de 50 años en la Administración Pública Federal',
        ],
        fullBio: '''
El Dr. Luís Humberto Delgadillo Gutiérrez es una de las figuras más distinguidas del derecho fiscal y administrativo en México. Con una formación académica excepcional, obtuvo su Licenciatura, Maestría y Doctorado en Derecho por la Universidad Nacional Autónoma de México, y se especializó en Derecho Tributario por la OEA/BID en Buenos Aires, Argentina.

Su trayectoria profesional abarca más de 50 años de servicio en la Administración Pública Federal, destacando su labor como Magistrado tanto de la Sala Superior como de Sala Regional del Tribunal Federal de Justicia Fiscal y Administrativa, donde contribuyó significativamente al desarrollo de la jurisprudencia fiscal mexicana.

En el ámbito académico, fue Presidente de la Academia Mexicana de Derecho Fiscal y ha sido profesor del Posgrado en prestigiosas universidades como la Anáhuac, la Panamericana y la UNAM, formando a generaciones de especialistas en derecho fiscal.

Como Director del Centro de Estudios de Derecho Fiscal y Administrativo del Tribunal Federal de Justicia Fiscal y Administrativa, impulsó la investigación y el desarrollo académico en estas materias. Es autor de numerosos libros de su especialidad publicados por las editoriales Limusa y Porrúa, obras que son referencia obligada en el estudio del derecho fiscal mexicano.

Su excelencia profesional le valió obtener el premio INAP en 1989. Actualmente ejerce como Asesor y Consultor jurídico privado, poniendo su vasta experiencia al servicio de clientes que requieren la más alta especialización en materia fiscal y administrativa.
        ''',
        education: [
          'Licenciatura en Derecho - UNAM',
          'Maestría en Derecho - UNAM',
          'Doctorado en Derecho - UNAM',
          'Especialidad en Derecho Tributario - OEA/BID (Buenos Aires, Argentina)',
        ],
        achievements: [
          'Premio INAP 1989',
          'Presidente de la Academia Mexicana de Derecho Fiscal',
          'Autor de múltiples libros publicados por Limusa y Porrúa',
          'Magistrado del Tribunal Federal de Justicia Fiscal y Administrativa',
          'Director del Centro de Estudios de Derecho Fiscal y Administrativo',
          'Autor del Compendio de Derecho Administrativo I y II',
          'Autor de Derecho Disciplinario de la Función Pública',
        ],
        previousPositions: [
          'Magistrado de la Sala Superior - TFJFA',
          'Magistrado de Sala Regional - TFJFA',
          'Director del Centro de Estudios de Derecho Fiscal y Administrativo - TFJFA',
          'Presidente de la Academia Mexicana de Derecho Fiscal',
          'Profesor de Posgrado - Universidad Anáhuac',
          'Profesor de Posgrado - Universidad Panamericana',
          'Profesor de Posgrado - UNAM',
        ],
        admissions: ['México'],
        isFeatured: false,
        linkedinUrl: '',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
      const TeamMember(
        id: 'jaime-rodriguez-arana',
        name: 'Dr. Jaime Rodríguez-Arana Muñoz',
        title: 'Consejero Académico Internacional',
        imageUrl:
            'https://raw.githubusercontent.com/emilio-perez-unam/justicia_administrativa_web/master/assets/images/jaime-rodriguez-arana.jpg',
        location: 'A Coruña, España',
        type: MemberType.lawyer,
        specialties: [
          'Políticas públicas',
          'Servicios públicos',
          'Responsabilidad patrimonial del Estado',
          'Buena Administración',
        ],
        details: [
          'Catedrático de Derecho Administrativo en la Universidad da Coruña',
          'Presidente del Foro Iberoamericano de Derecho Administrativo',
          'Múltiples Doctorados honoris causa en Iberoamérica',
          'Miembro de la Real Academia Española de Jurisprudencia y Legislación',
          'Director de publicaciones jurídicas de prestigio internacional',
        ],
        fullBio: '''
El Dr. Jaime Rodríguez-Arana Muñoz es una de las voces más autorizadas del Derecho Administrativo en el ámbito iberoamericano. Como Catedrático en la Universidad da Coruña, ha formado a incontables juristas y lidera la investigación de vanguardia como Director del grupo de Derecho Público Global.

Su prestigio internacional se refleja en los múltiples doctorados honoris causa que le han sido otorgados por universidades en Nicaragua, Costa Rica y México, reconociendo su inmensa contribución a las ciencias jurídicas.

Preside instituciones de gran relevancia como el Foro Iberoamericano de Derecho Administrativo y la Sección Española del Instituto Internacional de Ciencias Administrativas, consolidando puentes académicos y profesionales entre Europa e Iberoamérica.

Es miembro de las más distinguidas academias jurídicas, incluyendo la Real Academia Española de Jurisprudencia y Legislación y la Academia Internacional de Derecho Comparado, y dirige publicaciones de referencia como el Anuario Iberoamericano de Buena Administración. Su labor es fundamental para entender el presente y futuro del derecho público.
          ''',
        education: [
          'Doctor en Derecho - Universidad de Santiago de Compostela',
          'Doctor honoris causa - Universidad Hispanoamericana de Nicaragua',
          'Doctor honoris causa - Universidad Escuela Libre de Derecho de Costa Rica',
          'Doctor honoris causa - Universidad Santo Tomás de oriente y del Mediodía de Nicaragua',
          'Doctor honoris causa - Colegio de Especializaciones Jurídicas de Monterrey',
        ],
        achievements: [
          'Presidente del Foro Iberoamericano de Derecho Administrativo',
          'Presidente de la Asociación Española de Ciencias Administrativas',
          'Miembro de la Academia Internacional de Derecho Comparado',
          'Miembro de la Real Academia Española de Jurisprudencia y Legislación',
          'Director del Doctorado interuniversitario en Derecho Administrativo Iberoamericano',
        ],
        previousPositions: [
          'Director del grupo de investigación de Derecho Público Global - UDC',
          'Presidente de la Sección Española del Instituto Internacional de Ciencias Administrativas',
        ],
        admissions: ['España'],
        isFeatured: false,
        linkedinUrl:
            'https://www.linkedin.com/in/jaime-rodr%C3%ADguez-arana-2941771b/',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
      const TeamMember(
        id: 'miriam-ivanega',
        name: 'Dra. Míriam Mabel Ivanega',
        title: 'Consejera Académica Internacional',
        imageUrl:
            'https://raw.githubusercontent.com/emilio-perez-unam/justicia_administrativa_web/master/assets/images/miriam-ivanega.jpg',
        location: 'Buenos Aires, Argentina',
        type: MemberType.lawyer,
        specialties: [
          'Contratación pública',
          'Responsabilidades administrativas',
          'Servicios públicos',
          'Derecho y Ciencias Sociales',
        ],
        details: [
          'Doctora en Derecho y Ciencias Sociales por la Universidad Austral',
          'Magíster en Derecho Administrativo por la Universidad Austral',
          'Directora de la Maestría en Derecho Administrativo en la U. Austral',
          'Miembro fundador del Foro Iberoamericano de Derecho Administrativo',
          'Líder académica en Argentina',
          'Miembro Honorario de Asociaciones de Derecho Administrativo de México, República Dominicana, Ecuador, Nicaragua',
          'Integrante del Comité Académico del Doctorado de Derecho Administrativo Global - Universidad de La Coruña',
          'Autora de cientos de artículos y 11 libros de derecho público',
        ],
        fullBio: '''
La Dra. Míriam Mabel Ivanega es una jurista y académica de referencia en Argentina, con una profunda especialización en Derecho Administrativo. Ostenta un Doctorado en Derecho y Ciencias Sociales y una Maestría en Derecho Administrativo, ambos por la prestigiosa Universidad Austral, donde juega un papel central en la formación de las nuevas generaciones de abogados.

Actualmente, lidera como Directora el Departamento de Derecho Administrativo y la Maestría en la misma especialidad en la Universidad Austral, dos de los programas más importantes del país. Su visión y liderazgo son clave en el desarrollo académico del derecho público en Argentina.

Como una de las figuras fundadoras del Foro Iberoamericano de Derecho Administrativo (FIDA), ha sido fundamental en la consolidación de una red de conocimiento y colaboración que trasciende fronteras, fortaleciendo el diálogo jurídico en toda Iberoamérica. Su participación activa enriquece el debate sobre los desafíos contemporáneos del Estado y la Administración.
          ''',
        education: [
          'Doctora en Derecho y Ciencias Sociales - Universidad Austral',
          'Magíster en Derecho Administrativo - Universidad Austral',
        ],
        achievements: [
          'Directora del Departamento de Derecho Administrativo - U. Austral',
          'Directora de la Maestría en Derecho Administrativo - U. Austral',
          'Miembro fundador del Foro Iberoamericano de Derecho Administrativo',
        ],
        previousPositions: [
          'Profesora titular de Derecho Administrativo',
          'Investigadora principal en proyectos de derecho público',
        ],
        admissions: ['Argentina'],
        isFeatured: false,
        linkedinUrl:
            'https://www.linkedin.com/in/miriam-mabel-ivanega-182a1310/',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
      const TeamMember(
        id: 'luis-bejar-rivera',
        name: 'Dr. Luís José Béjar Rivera',
        title: 'Profesor e Investigador | Consejero Internacional',
        imageUrl:
            'https://raw.githubusercontent.com/emilio-perez-unam/justicia_administrativa_web/master/assets/images/luis-bejar-rivera.jpg',
        location: 'Sherbrooke, Quebec, Canadá',
        type: MemberType.lawyer,
        specialties: [
          'Políticas públicas',
          'Responsabilidad patrimonial del Estado',
          'Servicios públicos',
          'Derecho y Política',
        ],
        details: [
          'Profesor en Bishop\'s University, Canadá',
          'Doctor en Derecho por la Universidad Panamericana',
          'Más de 20 años de experiencia docente internacional',
          'Autor y coautor de más de 20 libros',
          'Profesor Visitante en universidades de España y Canadá',
        ],
        fullBio: '''
El Dr. Luís José Béjar Rivera es un distinguido profesor e investigador universitario con una consolidada carrera internacional de más de dos décadas. Su labor académica se ha extendido por múltiples países, donde ha impartido docencia y conferencias tanto a nivel de licenciatura como de posgrado.

Es un prolífico autor, con más de 20 libros, decenas de capítulos y artículos arbitrados en su haber, además de ser editor y coordinador de diversas obras. Su liderazgo académico se manifiesta también en su rol en el desarrollo y dirección de programas y currículas universitarias en los campos del derecho, la política y sus intersecciones.

Actualmente adscrito al Departamento de Política y Estudios Internacionales de Bishop's University en Canadá, el Dr. Béjar Rivera es también miembro de una decena de comités científicos y editoriales en Iberoamérica, y ha sido Profesor Visitante en la Universidad de Castilla-La Mancha (España) y en la Universidad de Montreal (Canadá), consolidando su perfil como un puente intelectual entre las Américas y Europa.
          ''',
        education: [
          'Doctorado en Derecho - Universidad Panamericana',
          'Maestría en Ciencias Jurídicas - Universidad Panamericana',
          'Maestría en Ciencia Política - Université de Montréal (en proceso de redacción)',
          'Licenciado en Derecho - ITESO',
        ],
        achievements: [
          'Autor de más de 20 libros y múltiples publicaciones',
          'Miembro de 10 comités científicos y editoriales',
          'Profesor Visitante, Universidad de Castilla-La Mancha',
          'Profesor Visitante, Universidad de Montreal',
          'Desarrollo y dirección de programas académicos',
        ],
        previousPositions: [
          'Profesor, Department of Politics & International Studies, Bishop\'s University',
        ],
        admissions: ['Canadá', 'México'],
        isFeatured: false,
        linkedinUrl:
            'https://www.linkedin.com/in/luis-jos%C3%A9-b%C3%A9jar-rivera-5941186b/',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
      const TeamMember(
        id: 'raul-rosales',
        name: 'Lic. Raúl Rosales Rosas',
        title: 'Consultor Senior en Derecho Público',
        imageUrl:
            'https://raw.githubusercontent.com/emilio-perez-unam/justicia_administrativa_web/master/assets/images/raul_rosales_rosas.jpg',
        location: 'Nayarit, México',
        type: MemberType.lawyer,
        specialties: [
          'Responsabilidades administrativas',
          'Contratación pública',
          'Derecho urbanístico',
          'Finanzas Públicas',
          'Transparencia',
        ],
        details: [
          'Modernización del marco normativo nayarita',
          'Ex Director Jurídico del Órgano de Fiscalización Superior de Nayarit',
          'Ex Delegado Federal de la Financiera Nacional de Desarrollo Agropecuario',
          'Representante legal de empresas como Cementos Cruz Azul',
          'Maestro en Derecho Público por la Universidad Panamericana',
          'Fundador de la Comisión Municipal de Derechos Humanos de Tepic',
        ],
        fullBio: '''
Ha contribuido a la modernización del marco normativo nayarita en materia de finanzas públicas, transparencia y desarrollo urbano.

Fue analista jurídico en la CNDH y asesor jurídico en ayuntamientos de Tepic y Bahía de Banderas.

Además fue Director Jurídico en el Órgano de Fiscalización Superior de Nayarit, Delegado Federal de la Financiera Nacional de Desarrollo Agropecuario, Asesor jurídico del Congreso de Nayarit y Director Jurídico en el municipio de Bahía de Banderas.

En el sector privado ha sido representante legal de empresas como Cementos Cruz Azul en temas de desarrollo urbano.

Es Licenciado en Derecho por la UAM y maestro en Derecho Público por la Universidad Panamericana, ha complementado su formación con estudios en España (Universidad Complutense) y EE.UU. (NESE, Massachusetts). Como docente, ha impartido clases en la Universidad Autónoma de Nayarit, y es autor de obras como "Reforma Municipal" (2001) y "Fiscalización Superior: una visión desde las regiones" (2008).

Asimismo, es fundador de la Comisión Municipal de Derechos Humanos de Tepic.
  ''',
        education: [
          'Licenciado en Derecho - UAM',
          'Maestro en Derecho Público - Universidad Panamericana',
          'Estudios complementarios - Universidad Complutense (España)',
          'Estudios complementarios - NESE (Massachusetts, EE.UU.)',
        ],
        achievements: [
          'Fundador de la Comisión Municipal de Derechos Humanos de Tepic',
          'Autor de "Reforma Municipal" (2001)',
          'Autor de "Fiscalización Superior: una visión desde las regiones" (2008)',
          'Modernización del marco normativo nayarita',
        ],
        previousPositions: [
          'Analista jurídico - CNDH',
          'Asesor jurídico - Ayuntamiento de Tepic',
          'Asesor jurídico - Ayuntamiento de Bahía de Banderas',
          'Director Jurídico - Órgano de Fiscalización Superior de Nayarit',
          'Delegado Federal - Financiera Nacional de Desarrollo Agropecuario',
          'Asesor jurídico - Congreso del Estado de Nayarit',
          'Director Jurídico - Municipio de Bahía de Banderas',
          'Representante legal - Cementos Cruz Azul',
          'Docente - Universidad Autónoma de Nayarit',
        ],
        admissions: ['México'],
        isFeatured: false,
        linkedinUrl: '',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
      const TeamMember(
        id: 'jose-alberto',
        name: 'Dr. Jose Alberto de la Paz',
        title: 'Research Associate',
        imageUrl:
            'https://raw.githubusercontent.com/emilio-perez-unam/justicia_administrativa_web/refs/heads/master/assets/images/alberto_de_la_paz.jpg',
        location: 'University of Texas at Dallas, USA',
        type: MemberType.engineer,
        specialties: [
          'Machine Learning',
          'Data Analysis',
          'Evolutionary Biology',
          'Python',
        ],
        details: [
          'PhD in Physics, Sorbonne Université',
          'Computational methods for biological systems',
          'Published researcher in ML applications',
        ],
        fullBio: '''
Dr. Jose Alberto de la Paz is a Research Associate specializing in the intersection of machine learning and biological systems. With a PhD in Physics from Sorbonne Université, he brings a unique perspective to data analysis and computational modeling.

His research focuses on applying advanced machine learning techniques to understand complex biological phenomena, contributing to both theoretical knowledge and practical applications in the field.
        ''',
        education: [
          'PhD in Physics - Sorbonne Université, France',
          'MSc in Computational Physics - Universidad Nacional Autónoma de México',
          'BSc in Physics - Instituto Tecnológico de México',
        ],
        achievements: [
          'Published 15+ papers in peer-reviewed journals',
          'Developed novel ML algorithms for biological data analysis',
          'Research grant recipient from National Science Foundation',
        ],
        admissions: [],
        isFeatured: false,
        linkedinUrl: 'https://linkedin.com/in/alberto-de-la-paz',
        githubUrl: 'https://github.com/AlbertodelaPaz',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
      TeamMember(
        id: 'sergio-yarza',
        name: 'Dr.Sergio Enrique Yarza Acuña',
        title: 'Data Scientist',
        imageUrl: '',
        location: 'Tepic, Nayarit, Mexico',
        type: MemberType.engineer,
        specialties: ['Applied Mathematics', 'Data Analysis', 'Python', 'R'],
        details: [
          'Ph.D. in Applied Mathematics',
          'Data Scientist at DeAcero Group',
          'Specialist in statistical modeling',
        ],
        fullBio: '''
Dr. Sergio Enrique Yarza Acuña is a distinguished Data Scientist with a PhD in Applied Mathematics. Currently working at DeAcero Group, he specializes in developing sophisticated statistical models and data analysis solutions for complex business problems.

His expertise in both Python and R enables him to tackle diverse challenges in data science, from predictive modeling to deep statistical analysis.
        ''',
        education: [
          'PhD in Applied Mathematics - UNAM',
          'MSc in Statistics - Instituto Tecnológico de Monterrey',
          'BSc in Mathematics - Universidad Autónoma de Nayarit',
        ],
        achievements: [
          'Implemented ML models saving \$2M annually at DeAcero',
          'Published research on applied statistical methods',
          'Speaker at international data science conferences',
        ],
        admissions: [],
        isFeatured: false,
        linkedinUrl: 'https://www.linkedin.com/in/sergio-yarza/',
        githubUrl: 'https://github.com/SergioYarza',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
      const TeamMember(
        id: 'emilio-perez-ocampo',
        name: 'Lic. Emilio Antonio Pérez Ocampo',
        title: 'Software Engineering Lead',
        imageUrl: '',
        location: 'Mexico City, Mexico',
        type: MemberType.engineer,
        specialties: [
          'Flutter',
          'Machine Learning',
          'Cloud Computing (GCP/AWS)',
          'Data Auditing & QA',
          'Microservices',
        ],
        details: [
          'Computer Science, National Autonomous University of Mexico (UNAM)',
          'Led software development at General Analytics Solutions & Justicia Administrativa',
          'Experience in data auditing and machine learning',
          'Multiple certifications in Cloud, Data, and ML',
          'Proficient in Flutter, Deno, Python, and Java',
        ],
        fullBio: '''
Proactive Computer Science student at the National Autonomous University of Mexico (UNAM) with over 3 years of professional experience in data auditing, machine learning, and team leadership. Led software development at Neotoro Technology, implementing microservices with Flutter and Deno. Passionate about self-directed learning, with multiple certifications in cloud computing and data science. Experienced in competitive programming, enhancing complex problem-solving abilities.
        ''',
        education: [
          'Bachelor\'s Degree in Computer Science - National Autonomous University of Mexico (UNAM)',
          'Bachelor\'s Degree in Philosophy - Autonomous University of Nayarit',
        ],
        achievements: [
          'Multiple Google Cloud Certifications',
          'Microsoft Power BI Data Analyst Certificate',
          'Multiple podium finishes, International Logic Olympiad',
          'IEEEXtreme Global Programming Competitor (2020-2024)',
        ],
        previousPositions: [
          'Software Engineering Lead - Neotoro Technology',
          'Software Developer Intern - Accenture',
          'Data Annotator - Appen, Lionbridge, iSoftStone',
          'Freelance Software Developer - Self-Employed',
        ],
        admissions: [],
        isFeatured: false,
        linkedinUrl: 'https://www.linkedin.com/in/emilio-antonio-perez-ocampo/',
        email: 'solicitudes@justiciadministrativa.com',
        phone: '+52 311 125 09 06',
      ),
    ];

    try {
      return members.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1440, 900));

    // In a real app, this would fetch from a repository
    final member = _getMemberById(memberId);

    if (member == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text('Perfil no encontrado', style: AppTypography.headingMedium(context)),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.go('/equipo'),
              child: const Text('Volver al equipo'),
            ),
          ],
        ),
      );
    }

    // Return just the content without any scrolling wrapper
    return Column(
      children: [
        _ProfileHeader(member: member),
        _ProfileHero(member: member),
        _ProfileContent(member: member),
      ],
    );
  }
}

// Simple header with back button
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.member});

  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    final accentColor = member.type == MemberType.engineer
        ? AppColors.techBlue
        : AppColors.primaryNavy;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => context.go('/equipo'),
              ),
              SizedBox(width: 16.w),
              CircleAvatar(
                radius: 20.r,
                backgroundColor: accentColor.withAlpha(26),
                child: Text(
                  member.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: AppTypography.bodyLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      member.title,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: accentColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.member});

  final TeamMember member;

  Widget _buildPlaceholder(BuildContext context, Color accentColor) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          member.name.split(' ').map((e) => e[0]).take(2).join(),
          style: AppTypography.displayLarge(context).copyWith(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 48.sp,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = member.type == MemberType.engineer
        ? AppColors.techBlue
        : AppColors.primaryNavy;

    return SizedBox(
      height: 500.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentColor.withAlpha(204), accentColor],
              ),
            ),
          ),
          // Pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  // Replace with actual pattern if you have one
                  // image: DecorationImage(
                  //   image: AssetImage('assets/images/pattern.png'),
                  //   repeat: ImageRepeat.repeat,
                  // ),
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image
                    Hero(
                      tag: 'profile-${member.id}',
                      child: Container(
                        width: 160.w,
                        height: 160.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(77),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: member.imageUrl.isNotEmpty
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: member.imageUrl,
                                  fit: BoxFit.cover,
                                  alignment: const Alignment(0.0, -0.8),
                                  placeholder: (context, url) => Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      _buildPlaceholder(context, accentColor),
                                ),
                              )
                            : _buildPlaceholder(context, accentColor),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Name
                    Text(
                          member.name,
                          style: AppTypography.displayMedium(context).copyWith(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.2, end: 0),
                    SizedBox(height: 8.h),
                    // Title
                    Text(
                          member.title,
                          style: AppTypography.headingSmall(context).copyWith(
                            color: Colors.white70,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.2, end: 0),
                    SizedBox(height: 16.h),
                    // Location
                    Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              member.location,
                              style: AppTypography.bodyLarge(context).copyWith(
                                color: Colors.white70,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.member});

  final TeamMember member;

  Future<void> _launchUrl(String? urlString) async {
    if (urlString != null && await canLaunchUrl(Uri.parse(urlString))) {
      await launchUrl(Uri.parse(urlString));
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = member.type == MemberType.engineer
        ? AppColors.techBlue
        : AppColors.primaryNavy;

    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000.w),
          child: Padding(
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact Info
                _ContactCard(
                  member: member,
                  accentColor: accentColor,
                  onLaunchUrl: _launchUrl,
                ),
                SizedBox(height: 40.h),

                // Bio Section
                if (member.fullBio != null && member.fullBio!.isNotEmpty) ...[
                  _SectionCard(
                    title: 'Biografía',
                    icon: Icons.person,
                    accentColor: accentColor,
                    child: Text(
                      member.fullBio!,
                      style: AppTypography.bodyLarge(context).copyWith(
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Specialties
                _SectionCard(
                  title: 'Especialidades',
                  icon: Icons.star,
                  accentColor: accentColor,
                  child: Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: member.specialties.map((spec) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: accentColor.withAlpha(77),
                          ),
                        ),
                        child: Text(
                          spec,
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 24.h),

                // Education
                if (member.education != null &&
                    member.education!.isNotEmpty) ...[
                  _SectionCard(
                    title: 'Formación Académica',
                    icon: Icons.school,
                    accentColor: accentColor,
                    child: Column(
                      children: member.education!.map((edu) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.h,
                                margin: EdgeInsets.only(top: 8.h),
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  edu,
                                  style: AppTypography.bodyLarge(context).copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Previous Positions
                if (member.previousPositions != null &&
                    member.previousPositions!.isNotEmpty) ...[
                  _SectionCard(
                    title: 'Experiencia Profesional',
                    icon: Icons.work,
                    accentColor: accentColor,
                    child: Column(
                      children: member.previousPositions!.map((pos) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.chevron_right,
                                color: accentColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  pos,
                                  style: AppTypography.bodyLarge(context).copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Achievements
                if (member.achievements != null &&
                    member.achievements!.isNotEmpty) ...[
                  _SectionCard(
                    title: 'Logros y Reconocimientos',
                    icon: Icons.emoji_events,
                    accentColor: accentColor,
                    child: Column(
                      children: member.achievements!.map((achievement) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  achievement,
                                  style: AppTypography.bodyLarge(context).copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.member,
    required this.accentColor,
    required this.onLaunchUrl,
  });

  final Color accentColor;
  final TeamMember member;
  final Function(String?) onLaunchUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 24.w,
              runSpacing: 16.h,
              children: [
                if (member.email != null)
                  _ContactItem(
                    icon: Icons.email,
                    label: member.email!,
                    onTap: () => onLaunchUrl('mailto:${member.email}'),
                    color: accentColor,
                  ),
                if (member.phone != null)
                  _ContactItem(
                    icon: Icons.phone,
                    label: member.phone!,
                    onTap: () => onLaunchUrl('tel:${member.phone}'),
                    color: accentColor,
                  ),
                if (member.linkedinUrl != null &&
                    member.linkedinUrl!.isNotEmpty)
                  _ContactItem(
                    icon: Icons.business,
                    label: 'LinkedIn',
                    onTap: () => onLaunchUrl(member.linkedinUrl),
                    color: accentColor,
                  ),
                if (member.githubUrl != null)
                  _ContactItem(
                    icon: Icons.code,
                    label: 'GitHub',
                    onTap: () => onLaunchUrl(member.githubUrl),
                    color: accentColor,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTypography.bodyMedium(context).copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.child,
  });

  final Color accentColor;
  final Widget child;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(13),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: AppTypography.headingSmall(context).copyWith(
                    color: accentColor,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(24.w), child: child),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }
}
