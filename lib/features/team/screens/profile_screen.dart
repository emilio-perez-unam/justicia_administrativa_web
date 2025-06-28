import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import '../models/team_member.dart';
import 'dart:ui';

class ProfileScreen extends HookWidget {
  final String memberId;

  const ProfileScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1440, 900));

    // In a real app, this would fetch from a repository
    final member = _getMemberById(memberId);

    if (member == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: 16.h),
              Text('Perfil no encontrado', style: AppTypography.headingMedium),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => context.go('/equipo'),
                child: const Text('Volver al equipo'),
              ),
            ],
          ),
        ),
      );
    }

    final scrollController = useScrollController();
    final isScrolled = useState(false);

    useEffect(() {
      void listener() {
        if (scrollController.hasClients) {
          isScrolled.value = scrollController.offset > 100;
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    return Scaffold(
      body: LayoutBuilder(
        // <-- Added LayoutBuilder to get constraints
        builder: (context, constraints) {
          return SizedBox(
            // <-- Added SizedBox with constraints
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: [
                // Scrollable content
                Positioned.fill(
                  // <-- Changed to Positioned.fill
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        _ProfileHero(member: member),
                        _ProfileContent(member: member),
                      ],
                    ),
                  ),
                ),
                // Fixed app bar
                Positioned(
                  // <-- Changed to Positioned
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _AnimatedAppBar(
                    member: member,
                    isScrolled: isScrolled.value,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // In a real app, this would be in a repository
  TeamMember? _getMemberById(String id) {
    final members = [
      const TeamMember(
        id: 'alfredo-delgadillo',
        name: 'Lic. Alfredo Delgadillo López',
        title: 'Fundador y Director General',
        imageUrl:
            'https://raw.githubusercontent.com/yourusername/yourrepo/main/images/alfredo.jpg',
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
        id: 'raul-rosales',
        name: 'Raúl Rosales Rosas',
        title: 'Consultor Senior en Derecho Público',
        imageUrl: '',
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
    ];

    try {
      return members.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}

class _AnimatedAppBar extends StatelessWidget {
  final TeamMember member;
  final bool isScrolled;

  const _AnimatedAppBar({required this.member, required this.isScrolled});

  @override
  Widget build(BuildContext context) {
    final accentColor = member.type == MemberType.engineer
        ? AppColors.techBlue
        : AppColors.primaryNavy;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 80.h,
      decoration: BoxDecoration(
        color: isScrolled ? Colors.white : Colors.transparent,
        boxShadow: isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isScrolled ? AppColors.textPrimary : Colors.white,
                ),
                onPressed: () => context.go('/equipo'),
              ),
              if (isScrolled) ...[
                SizedBox(width: 16.w),
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: accentColor.withOpacity(0.1),
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
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        member.title,
                        style: AppTypography.bodySmall.copyWith(
                          color: accentColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final TeamMember member;

  const _ProfileHero({required this.member});

  @override
  Widget build(BuildContext context) {
    final accentColor = member.type == MemberType.engineer
        ? AppColors.techBlue
        : AppColors.primaryNavy;

    return Container(
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
                colors: [accentColor.withOpacity(0.8), accentColor],
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
                              color: Colors.black.withOpacity(0.3),
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
                                  placeholder: (context, url) => Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      _buildPlaceholder(accentColor),
                                ),
                              )
                            : _buildPlaceholder(accentColor),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Name
                    Text(
                          member.name,
                          style: AppTypography.displayMedium.copyWith(
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
                          style: AppTypography.headingSmall.copyWith(
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
                              style: AppTypography.bodyLarge.copyWith(
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

  Widget _buildPlaceholder(Color accentColor) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          member.name.split(' ').map((e) => e[0]).take(2).join(),
          style: AppTypography.displayLarge.copyWith(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 48.sp,
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final TeamMember member;

  const _ProfileContent({required this.member});

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
                      style: AppTypography.bodyLarge.copyWith(
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
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          spec,
                          style: AppTypography.bodyMedium.copyWith(
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
                                  style: AppTypography.bodyLarge.copyWith(
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
                                  style: AppTypography.bodyLarge.copyWith(
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
                                  style: AppTypography.bodyLarge.copyWith(
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
  final TeamMember member;
  final Color accentColor;
  final Function(String?) onLaunchUrl;

  const _ContactCard({
    required this.member,
    required this.accentColor,
    required this.onLaunchUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                if (member.linkedinUrl != null)
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
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

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
              style: AppTypography.bodyMedium.copyWith(
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
  final String title;
  final IconData icon;
  final Color accentColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              color: accentColor.withOpacity(0.05),
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
                  style: AppTypography.headingSmall.copyWith(
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
