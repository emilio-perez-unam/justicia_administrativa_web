import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

// Import the model
import '../models/team_member.dart';

// Import dart:ui for ImageFilter
import 'dart:ui';

class TeamScreen extends HookWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: const Size(1440, 900));

    final teamMembers = useMemoized(
      () => [
        const TeamMember(
          id: 'alfredo-delgadillo',
          name: 'Lic. Alfredo Delgadillo López',
          title: 'Fundador y Director General',
          imageUrl: '', // Reemplazar con URL de alfredo-delgadillo-lopez.jpg
          location: 'Ciudad de México',
          type: MemberType.lawyer,
          specialties: [
            'Derecho Administrativo',
            'Derecho Digital',
            'Abogado Digital Certificado',
            'Litigio Público',
          ],
          details: [
            'Fundador de justicIAdministrativa',
            'Profesor en universidades de México e Iberoamérica',
            'Autor y coordinador de libros especializados',
            'Coordinador del Seminario Derecho Administrativo 4RI - IIJUNAM',
            'Columnista en diversos periódicos nacionales',
          ],
          fullBio: '''
Alfredo Delgadillo López es el fundador y Director General de justicIAdministrativa, una firma pionera en la integración de tecnología avanzada y derecho administrativo. Con más de 20 años de experiencia en el sector público y privado, ha sido un líder en la transformación digital del derecho en México.

Como académico, ha impartido cátedra en las principales universidades de México e Iberoamérica, y coordina el Seminario de Derecho Administrativo 4RI en el Instituto de Investigaciones Jurídicas de la UNAM. Es autor y coordinador de múltiples obras especializadas en derecho administrativo y tecnología.

Su visión innovadora lo ha llevado a ser columnista en diversos periódicos nacionales, donde analiza la intersección entre el derecho, la tecnología y la administración pública.
        ''',
          education: [
            'Licenciatura en Derecho - UNAM',
            'Maestría en Derecho Administrativo - Universidad Panamericana',
            'Certificación en Derecho Digital - Instituto Tecnológico de Massachusetts',
          ],
          achievements: [
            'Premio Nacional de Jurisprudencia 2023',
            'Reconocimiento a la Innovación Legal 2022',
            'Miembro del Sistema Nacional de Investigadores',
          ],
          admissions: ['México'],
          isFeatured: true,
          linkedinUrl: 'https://linkedin.com/in/alfredo-delgadillo',
          email: 'alfredo@justicia-administrativa.mx',
          phone: '+52 55 1234 5678',
        ),
        const TeamMember(
          id: 'luis-humberto-delgadillo',
          name: 'Dr. Luís Humberto Delgadillo Gutiérrez',
          title: 'Asesor y Consultor Jurídico Senior',
          imageUrl: '', // Reemplazar con URL de luis-delgadillo-gutierrez.jpg
          location: 'Ciudad de México',
          type: MemberType.lawyer,
          specialties: [
            'Derecho Tributario',
            'Derecho Fiscal',
            'Derecho Administrativo',
            'Consultoría Jurídica',
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
          email: 'luis.delgadillo@justicia-administrativa.mx',
        ),
        const TeamMember(
          id: 'jaime-rodriguez-arana',
          name: 'Dr. Jaime Rodríguez-Arana Muñoz',
          title: 'Consejero Académico Internacional',
          imageUrl:
              'https://www.udc.es/grupos/derechopublicoglobal/wp-content/uploads/2020/09/Jaime-Rodriguez-Arana-2-scaled.jpg',
          location: 'A Coruña, España',
          type: MemberType.lawyer,
          specialties: [
            'Derecho Administrativo',
            'Derecho Público Global',
            'Ciencias Administrativas',
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
              'https://es.linkedin.com/in/jaime-rodriguez-arana-mu%C3%B1oz-02b48a52',
          email: 'jaime.rodriguez@justicia-administrativa.mx',
        ),
        const TeamMember(
          id: 'miriam-ivanega',
          name: 'Dra. Míriam Mabel Ivanega',
          title: 'Consejera Académica Internacional',
          imageUrl:
              'https://www.foroiberoamericano.org/wp-content/uploads/2020/07/miriam-ivanega-2-300x300.jpg',
          location: 'Buenos Aires, Argentina',
          type: MemberType.lawyer,
          specialties: [
            'Derecho Administrativo',
            'Derecho y Ciencias Sociales',
            'Academia e Investigación',
            'Gestión Universitaria',
          ],
          details: [
            'Doctora en Derecho y Ciencias Sociales por la Universidad Austral',
            'Magíster en Derecho Administrativo por la Universidad Austral',
            'Directora de la Maestría en Derecho Administrativo en la U. Austral',
            'Miembro fundador del Foro Iberoamericano de Derecho Administrativo',
            'Líder académica en Argentina',
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
          linkedinUrl: 'https://ar.linkedin.com/in/miriammabelivanega',
          email: 'miriam.ivanega@justicia-administrativa.mx',
        ),
        const TeamMember(
          id: 'luis-bejar-rivera',
          name: 'Dr. Luís José Béjar Rivera',
          title: 'Profesor e Investigador | Consejero Internacional',
          imageUrl:
              'https://www.ubishops.ca/wp-content/uploads/luis-bejar-rivera-300x300.jpg',
          location: 'Sherbrooke, Quebec, Canadá',
          type: MemberType.lawyer,
          specialties: [
            'Derecho y Política',
            'Ciencia Política',
            'Investigación Jurídica',
            'Derecho Comparado',
          ],
          details: [
            'Profesor en Bishop’s University, Canadá',
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
            'Maestría en Ciencia Política - Université de Montréal (en proceso)',
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
            'Profesor, Department of Politics & International Studies, Bishop’s University',
          ],
          admissions: ['Canadá', 'México'],
          isFeatured: false,
          linkedinUrl: 'https://ca.linkedin.com/in/luisjosebejar',
          email: 'luis.bejar@justicia-administrativa.mx',
        ),
        const TeamMember(
          id: 'raul-rosales',
          name: 'Raúl Rosales Rosas',
          title: 'Consultor Senior en Derecho Público',
          imageUrl: '', // Reemplazar con URL de raul-rosales-rosas.jpg
          location: 'Nayarit, México',
          type: MemberType.lawyer,
          specialties: [
            'Derecho Público',
            'Finanzas Públicas',
            'Transparencia',
            'Desarrollo Urbano',
            'Fiscalización Superior',
          ],
          details: [
            'Modernización del marco normativo nayarita',
            'Ex Director Jurídico del Órgano de Fiscalización Superior de Nayarit',
            'Ex Delegado Federal de la Financiera Nacional de Desarrollo Agropecuario',
            'Representante legal de Cementos Cruz Azul',
            'Maestro en Derecho Público por la Universidad Panamericana',
            'Autor de obras especializadas en fiscalización',
          ],
          fullBio: '''
Raúl Rosales Rosas es un destacado abogado especializado en derecho público con una trayectoria excepcional en el sector gubernamental y privado. Ha sido pieza clave en la modernización del marco normativo nayarita en materia de finanzas públicas, transparencia y desarrollo urbano.

Su carrera profesional incluye posiciones de alto nivel como Director Jurídico del Órgano de Fiscalización Superior de Nayarit, Delegado Federal de la Financiera Nacional de Desarrollo Agropecuario, Asesor jurídico del Congreso de Nayarit y Director Jurídico del municipio de Bahía de Banderas.

En el sector privado, ha sido representante legal de empresas de gran envergadura como Cementos Cruz Azul en temas de desarrollo urbano, demostrando su versatilidad y expertise en diferentes ámbitos del derecho.

Como académico, ha impartido clases en la Universidad Autónoma de Nayarit y es autor de obras fundamentales como "Reforma Municipal" (2001) y "Fiscalización Superior: una visión desde las regiones" (2008).

Es fundador de la Comisión Municipal de Derechos Humanos de Tepic, reflejando su compromiso con la justicia y los derechos fundamentales.
        ''',
          education: [
            'Licenciatura en Derecho - UAM',
            'Maestría en Derecho Público - Universidad Panamericana',
            'Estudios especializados - Universidad Complutense (España)',
            'Programa ejecutivo - NESE Business School (Massachusetts, EE.UU.)',
          ],
          achievements: [
            'Fundador de la Comisión Municipal de Derechos Humanos de Tepic',
            'Autor de "Reforma Municipal" (2001)',
            'Autor de "Fiscalización Superior: una visión desde las regiones" (2008)',
            'Modernizador del marco normativo de Nayarit',
          ],
          previousPositions: [
            'Director Jurídico - Órgano de Fiscalización Superior de Nayarit',
            'Delegado Federal - Financiera Nacional de Desarrollo Agropecuario',
            'Asesor Jurídico - Congreso del Estado de Nayarit',
            'Director Jurídico - Municipio de Bahía de Banderas',
            'Analista Jurídico - CNDH',
            'Representante Legal - Cementos Cruz Azul',
          ],
          admissions: ['México'],
          isFeatured: false,
          linkedinUrl: 'https://linkedin.com/in/raul-rosales-rosas',
          email: 'raul.rosales@justicia-administrativa.mx',
          phone: '+52 311 234 5678',
        ),
        const TeamMember(
          id: 'jose-alberto',
          name: 'Jose Alberto de la Paz',
          title: 'Research Associate',
          imageUrl: '',
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
          email: 'alberto.delapaz@justicia-administrativa.mx',
        ),
        TeamMember(
          id: 'sergio-yarza',
          name: 'Sergio Enrique Yarza Acuña',
          title: 'Data Scientist',
          imageUrl: '',
          location: 'Tepic, Nayarit, Mexico',
          type: MemberType.engineer,
          specialties: const [
            'Applied Mathematics',
            'Data Analysis',
            'Python',
            'R',
          ],
          details: const [
            'Ph.D. in Applied Mathematics',
            'Data Scientist at DeAcero Group',
            'Specialist in statistical modeling',
          ],
          fullBio: '''
Dr. Sergio Enrique Yarza Acuña is a distinguished Data Scientist with a PhD in Applied Mathematics. Currently working at DeAcero Group, he specializes in developing sophisticated statistical models and data analysis solutions for complex business problems.

His expertise in both Python and R enables him to tackle diverse challenges in data science, from predictive modeling to deep statistical analysis.
        ''',
          education: const [
            'PhD in Applied Mathematics - UNAM',
            'MSc in Statistics - Instituto Tecnológico de Monterrey',
            'BSc in Mathematics - Universidad Autónoma de Nayarit',
          ],
          achievements: [
            'Implemented ML models saving \$2M annually at DeAcero',
            'Published research on applied statistical methods',
            'Speaker at international data science conferences',
          ],
          admissions: const [],
          isFeatured: false,
          linkedinUrl: 'https://www.linkedin.com/in/sergio-yarza/',
          githubUrl: 'https://github.com/SergioYarza',
          email: 'sergio.yarza@justicia-administrativa.mx',
        ),
      ],
    );

    final selectedFilter = useState<MemberType>(MemberType.all);
    final searchQuery = useState<String>('');
    final searchController = useTextEditingController();
    final scrollController = useScrollController();

    // Create search stream with debouncing
    final searchStream = useMemoized(() => BehaviorSubject<String>(), []);

    // Setup search debouncing
    useEffect(() {
      final subscription = searchStream
          .debounceTime(const Duration(milliseconds: 300))
          .distinct()
          .listen((query) {
            searchQuery.value = query;
          });

      return subscription.cancel;
    }, []);

    // Handle search input changes
    useEffect(() {
      void listener() {
        searchStream.add(searchController.text);
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    // Filter members based on type and search query
    final filteredMembers = useMemoized(() {
      var filtered = teamMembers;

      // Apply type filter
      if (selectedFilter.value != MemberType.all) {
        filtered = filtered
            .where((member) => member.type == selectedFilter.value)
            .toList();
      }

      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        filtered = filtered.where((member) {
          return member.name.toLowerCase().contains(query) ||
              member.title.toLowerCase().contains(query) ||
              member.location.toLowerCase().contains(query) ||
              member.specialties.any(
                (spec) => spec.toLowerCase().contains(query),
              ) ||
              member.details.any(
                (detail) => detail.toLowerCase().contains(query),
              );
        }).toList();
      }

      return filtered;
    }, [selectedFilter.value, searchQuery.value]);

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          _ParallaxHeroSection(scrollController: scrollController),
          const _BreadcrumbSection(),
          _FilterSection(
            selectedFilter: selectedFilter.value,
            onFilterChanged: (filter) => selectedFilter.value = filter,
            searchController: searchController,
            searchQuery: searchQuery.value,
            onClearSearch: () {
              searchController.clear();
              searchQuery.value = '';
            },
          ),
          AnimationLimiter(
            child: _ResponsiveTeamGrid(
              members: filteredMembers,
              searchQuery: searchQuery.value,
            ),
          ),
          if (filteredMembers.isEmpty)
            _EmptyState(
              searchQuery: searchQuery.value,
              selectedFilter: selectedFilter.value,
            ),
        ],
      ),
    );
  }
}

// New Parallax Hero Section
class _ParallaxHeroSection extends HookWidget {
  final ScrollController scrollController;

  const _ParallaxHeroSection({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final scrollOffset = useState(0.0);

    useEffect(() {
      void listener() {
        scrollOffset.value = scrollController.hasClients
            ? scrollController.offset
            : 0.0;
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    return Container(
      height: 400.h,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: AppColors.primaryNavy),
      child: Stack(
        children: [
          // Parallax background layers
          Positioned(
            top: scrollOffset.value * 0.5,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.1,
              child: Transform.scale(
                scale: 1.2,
                child: Container(
                  height: 500.h,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topRight,
                      radius: 1.5,
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: scrollOffset.value * 0.3,
            left: -100,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.techBlue.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, scrollOffset.value * 0.1),
                        child:
                            Text(
                                  'Nuestro Equipo Internacional',
                                  style: AppTypography.displayLarge.copyWith(
                                    color: Colors.white,
                                    fontSize: 56.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                .animate()
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.2, end: 0, duration: 800.ms),
                      ),
                      SizedBox(height: 24.h),
                      Transform.translate(
                        offset: Offset(0, scrollOffset.value * 0.05),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 800.w),
                          child:
                              Text(
                                    'Contamos con un equipo multidisciplinario conformado por expertos en derecho administrativo y por expertos en tecnologías digitales distribuidos en América y Europa',
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: Colors.white70,
                                      fontSize: 20.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                  .animate()
                                  .fadeIn(delay: 300.ms, duration: 800.ms)
                                  .slideY(begin: 0.2, end: 0, duration: 800.ms),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final MemberType selectedFilter;
  final ValueChanged<MemberType> onFilterChanged;
  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback onClearSearch;

  const _FilterSection({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.searchController,
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.isMobile) {
                  return Column(
                    children: [
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: _buildFilterChips(),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: _SearchField(
                          controller: searchController,
                          searchQuery: searchQuery,
                          onClear: onClearSearch,
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(spacing: 12.w, children: _buildFilterChips()),
                    SizedBox(
                      width: 350.w,
                      child: _SearchField(
                        controller: searchController,
                        searchQuery: searchQuery,
                        onClear: onClearSearch,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFilterChips() {
    return [
      _EnhancedFilterChip(
        label: 'Todos',
        isSelected: selectedFilter == MemberType.all,
        onTap: () => onFilterChanged(MemberType.all),
      ),
      _EnhancedFilterChip(
        label: 'Abogados',
        isSelected: selectedFilter == MemberType.lawyer,
        onTap: () => onFilterChanged(MemberType.lawyer),
        color: AppColors.primaryNavy,
        icon: Icons.gavel,
      ),
      _EnhancedFilterChip(
        label: 'Ingenieros IA',
        isSelected: selectedFilter == MemberType.engineer,
        onTap: () => onFilterChanged(MemberType.engineer),
        color: AppColors.techBlue,
        icon: Icons.code,
      ),
      _EnhancedFilterChip(
        label: 'Consultores',
        isSelected: selectedFilter == MemberType.consultant,
        onTap: () => onFilterChanged(MemberType.consultant),
        color: AppColors.textSecondary,
        icon: Icons.business,
      ),
    ];
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.searchQuery,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Buscar por nombre, título, ubicación o especialidad',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
                  .animate(target: searchQuery.isNotEmpty ? 1 : 0)
                  .scaleXY(begin: 0, end: 1, duration: 200.ms)
                  .fadeIn(duration: 200.ms)
            : null,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }
}

// Enhanced Filter Chip with micro-interactions
class _EnhancedFilterChip extends HookWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon;

  const _EnhancedFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final isPressed = useState(false);
    final effectiveColor = color ?? AppColors.primaryNavy;

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTapDown: (_) => isPressed.value = true,
        onTapUp: (_) {
          isPressed.value = false;
          onTap();
        },
        onTapCancel: () => isPressed.value = false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(isPressed.value ? 0.95 : (isHovered.value ? 1.05 : 1.0)),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? effectiveColor
                : (isHovered.value
                      ? effectiveColor.withOpacity(0.1)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected || isHovered.value
                  ? effectiveColor
                  : AppColors.divider,
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: isSelected || isHovered.value
                ? [
                    BoxShadow(
                      color: effectiveColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                AnimatedRotation(
                  turns: isSelected ? 0 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    icon,
                    size: 16.sp,
                    color: isSelected
                        ? Colors.white
                        : (isHovered.value
                              ? effectiveColor
                              : AppColors.textSecondary),
                  ),
                ),
                SizedBox(width: 6.w),
              ],
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected
                      ? Colors.white
                      : (isHovered.value
                            ? effectiveColor
                            : AppColors.textSecondary),
                  fontWeight: isSelected || isHovered.value
                      ? FontWeight.w600
                      : FontWeight.normal,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Responsive team grid with staggered animations
class _ResponsiveTeamGrid extends HookWidget {
  final List<TeamMember> members;
  final String searchQuery;

  const _ResponsiveTeamGrid({required this.members, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200.w),
          child: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              int crossAxisCount;
              double spacing;
              EdgeInsets padding;

              if (sizingInformation.isMobile) {
                crossAxisCount = 1;
                spacing = 16.w;
                padding = EdgeInsets.symmetric(horizontal: 16.w);
              } else if (sizingInformation.isTablet) {
                crossAxisCount = 2;
                spacing = 20.w;
                padding = EdgeInsets.symmetric(horizontal: 24.w);
              } else {
                crossAxisCount = 3;
                spacing = 24.w;
                padding = EdgeInsets.symmetric(horizontal: 24.w);
              }

              return Padding(
                padding: padding,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: MasonryGridView.count(
                    key: ValueKey(crossAxisCount),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final cardHeight = _calculateCardHeight(member);

                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 600),
                        columnCount: crossAxisCount,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _HoverableProfileCard(
                              member: member,
                              searchQuery: searchQuery,
                              height: cardHeight,
                              index: index,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateCardHeight(TeamMember member) {
    double height = 280.h; // Image height
    height += 120.h; // Name, title, location
    height += 80.h; // Specialties

    if (member.details.isNotEmpty) {
      height += 20.h; // "Experiencia destacada" title
      height += (member.details.take(3).length * 40.h); // Each detail line
    }

    height += 80.h; // Button and padding

    return height;
  }
}

// New hoverable card with enhanced animations
class _HoverableProfileCard extends HookWidget {
  final TeamMember member;
  final String searchQuery;
  final double height;
  final int index;

  const _HoverableProfileCard({
    required this.member,
    required this.searchQuery,
    required this.height,
    required this.index,
  });

  Future<void> _launchUrl(String? urlString) async {
    if (urlString != null && await canLaunchUrl(Uri.parse(urlString))) {
      await launchUrl(Uri.parse(urlString));
    }
  }

  Text _highlightText(String text, TextStyle style) {
    if (searchQuery.isEmpty) {
      return Text(text, style: style);
    }

    final matches = RegExp(
      searchQuery.split(' ').map((word) => RegExp.escape(word)).join('|'),
      caseSensitive: false,
    ).allMatches(text);

    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    final spans = <TextSpan>[];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: style.copyWith(
            backgroundColor: Colors.yellow.withOpacity(0.4),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }

    return Text.rich(TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final isPressed = useState(false);
    final isEngineer = member.type == MemberType.engineer;
    final accentColor = isEngineer ? AppColors.techBlue : AppColors.primaryNavy;
    final String? targetUrl = isEngineer
        ? member.githubUrl
        : member.linkedinUrl;
    final bool hasUrl = targetUrl != null && targetUrl.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTapDown: (_) => isPressed.value = true,
        onTapUp: (_) => isPressed.value = false,
        onTapCancel: () => isPressed.value = false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, isHovered.value ? -8.0 : 0.0)
            ..scale(isPressed.value ? 0.98 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered.value ? 0.15 : 0.08),
                blurRadius: isHovered.value ? 30.r : 20.r,
                offset: Offset(0, isHovered.value ? 15.h : 10.h),
                spreadRadius: isHovered.value ? 5 : 0,
              ),
              if (isHovered.value)
                BoxShadow(
                  color: accentColor.withOpacity(0.1),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Enhanced Image Section
                _EnhancedImageSection(
                  member: member,
                  accentColor: accentColor,
                  height: 280.h,
                  isHovered: isHovered.value,
                ),

                // Content Section
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name and Title
                      _highlightText(
                        member.name,
                        AppTypography.headingSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      _highlightText(
                        member.title,
                        AppTypography.bodyMedium.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Location with animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..translate(isHovered.value ? 5.0 : 0.0, 0.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.sp,
                              color: isHovered.value
                                  ? accentColor
                                  : AppColors.textTertiary,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: _highlightText(
                                member.location,
                                AppTypography.bodySmall.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Specialties with hover effect
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: member.specialties.take(4).map((spec) {
                          final isHighlighted =
                              searchQuery.isNotEmpty &&
                              spec.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              );
                          return AnimatedContainer(
                            duration: Duration(
                              milliseconds:
                                  (200 +
                                          (member.specialties.indexOf(spec) *
                                              50))
                                      .toInt(),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? Colors.yellow.withOpacity(0.3)
                                  : (isHovered.value
                                        ? accentColor.withOpacity(0.15)
                                        : accentColor.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(16.r),
                              border: isHighlighted
                                  ? Border.all(color: Colors.orange, width: 1.5)
                                  : (isHovered.value
                                        ? Border.all(
                                            color: accentColor.withOpacity(0.3),
                                            width: 1,
                                          )
                                        : null),
                            ),
                            child: Text(
                              spec,
                              style: AppTypography.caption.copyWith(
                                color: accentColor,
                                fontWeight: isHighlighted || isHovered.value
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 11.sp,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 16.h),

                      // Key Experience with staggered animation
                      if (member.details.isNotEmpty) ...[
                        Text(
                          'Experiencia destacada',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ...member.details
                            .take(3)
                            .toList()
                            .asMap()
                            .entries
                            .map(
                              (entry) => AnimatedContainer(
                                duration: Duration(
                                  milliseconds: (300 + (entry.key * 100))
                                      .toInt(),
                                ),
                                transform: Matrix4.identity()
                                  ..translate(
                                    isHovered.value ? 10.0 : 0.0,
                                    0.0,
                                  ),
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: isHovered.value ? 6.w : 4.w,
                                      height: isHovered.value ? 6.h : 4.h,
                                      margin: EdgeInsets.only(top: 6.h),
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: _highlightText(
                                        entry.value,
                                        AppTypography.caption.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],

                      SizedBox(height: 20.h),

                      // Updated Action Button with profile navigation - FIXED PATH
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go(
                            '/equipo/${member.id}',
                          ), // <-- FIXED: Changed from /team/ to /equipo/
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isHovered.value
                                ? accentColor.withOpacity(0.9)
                                : accentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: isHovered.value ? 4 : 0,
                          ),
                          icon: AnimatedRotation(
                            turns: isHovered.value ? 0.1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(Icons.person, size: 18.sp),
                          ),
                          label: Text(
                            'Ver Perfil Completo',
                            style: AppTypography.button.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced image section with hover effects
class _EnhancedImageSection extends HookWidget {
  final TeamMember member;
  final Color accentColor;
  final double height;
  final bool isHovered;

  const _EnhancedImageSection({
    required this.member,
    required this.accentColor,
    required this.height,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final imageLoadController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (member.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: AnimatedScale(
                scale: isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: CachedNetworkImage(
                  imageUrl: member.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => _buildShimmerLoading(),
                  errorWidget: (context, url, error) =>
                      _buildAnimatedPlaceholder(accentColor),
                  imageBuilder: (context, imageProvider) => AnimatedBuilder(
                    animation: imageLoadController,
                    builder: (context, child) {
                      imageLoadController.forward();
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          // Blurred background
                          Opacity(
                            opacity: 1 - imageLoadController.value,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 20,
                                  sigmaY: 20,
                                ),
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ),
                          // Clear image
                          Opacity(
                            opacity: imageLoadController.value,
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          else
            _buildAnimatedPlaceholder(accentColor),

          // Gradient overlay with hover effect
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isHovered ? 120.h : 100.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(isHovered ? 0.8 : 0.7),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedPlaceholder(Color accentColor) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withOpacity(0.1 * value),
                accentColor.withOpacity(0.2 * value),
              ],
            ),
          ),
          child: Center(
            child: Transform.scale(
              scale: isHovered ? 1.1 : (0.8 + (0.2 * value)),
              child: Opacity(
                opacity: value,
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.white,
                  child: Text(
                    member.name.split(' ').map((e) => e[0]).take(2).join(),
                    style: AppTypography.displayMedium.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchQuery;
  final MemberType selectedFilter;

  const _EmptyState({required this.searchQuery, required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(60.w),
      child: Center(
        child: Column(
          children: [
            Icon(
                  Icons.search_off,
                  size: 80.sp,
                  color: AppColors.textTertiary.withOpacity(0.5),
                )
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(),
            SizedBox(height: 24.h),
            Text(
              'No se encontraron resultados',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 24.sp,
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            SizedBox(height: 12.h),
            Text(
              searchQuery.isNotEmpty
                  ? 'No encontramos miembros del equipo que coincidan con "$searchQuery"'
                  : 'No hay ${_getFilterLabel(selectedFilter)} en el equipo actualmente',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textTertiary,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                // This would need to be connected to the parent widget
                // to clear filters/search
              },
              icon: Icon(Icons.refresh, size: 20.sp),
              label: Text('Limpiar filtros', style: TextStyle(fontSize: 16.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  String _getFilterLabel(MemberType type) {
    switch (type) {
      case MemberType.lawyer:
        return 'abogados';
      case MemberType.engineer:
        return 'ingenieros IA';
      case MemberType.consultant:
        return 'consultores';
      case MemberType.all:
        return 'miembros';
    }
  }
}

class _BreadcrumbSection extends StatelessWidget {
  const _BreadcrumbSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200.w),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Icon(
                Icons.home_outlined,
                color: AppColors.textTertiary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Inicio',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Equipo',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
