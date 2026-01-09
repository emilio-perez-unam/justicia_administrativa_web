// ignore_for_file: unused_element_parameter
import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_layout.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'package:justicia_administrativa_web/core/utils/responsive_utils.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(),
          _BreadcrumbSection(),
          _IntroSection(),
          _TimelineSection(),
          _MissionVisionSection(),
          _AwardsSection(),
          _AffiliationsSection(),
          _SocialResponsibilitySection(),
          _LeadershipSection(),
        ],
      ),
    );
  }
}

// --- Screen Sections & Widgets ---

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _HeroSectionMobile(),
      tablet: _HeroSectionTablet(),
      desktop: _HeroSectionDesktop(),
    );
  }
}

class _HeroSectionDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400, // Keep fixed height for desktop
      child: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hero_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay oscuro con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(204),
                  Colors.black.withAlpha(153),
                ],
              ),
            ),
          ),
          // Contenido
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuestra Historia',
                      style: AppTypography.displayLarge(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 734),
                      child: Text(
                        'Conoce la trayectoria, valores y compromiso que han convertido a Justicia Administrativa en un referente del derecho administrativo y la innovación legal en México.',
                        style: AppTypography.bodyLarge(context).copyWith(
                          color: Colors.white.withAlpha(230),
                        ),
                      ),
                    ),
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

class _HeroSectionTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300, // Adjusted height for tablet
      child: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hero_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay oscuro con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(204),
                  Colors.black.withAlpha(153),
                ],
              ),
            ),
          ),
          // Contenido
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuestra Historia',
                      style: AppTypography.displayLarge(context).copyWith(
                        color: Colors.white,
                        fontSize: 48, // Adjusted font size for tablet
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 734),
                      child: Text(
                        'Conoce la trayectoria, valores y compromiso que han convertido a Justicia Administrativa en un referente del derecho administrativo y la innovación legal en México.',
                        style: AppTypography.bodyLarge(context).copyWith(
                          color: Colors.white.withAlpha(230),
                          fontSize: 18, // Adjusted font size for tablet
                        ),
                      ),
                    ),
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

class _HeroSectionMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250, // Adjusted height for mobile
      child: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hero_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay oscuro con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(204),
                  Colors.black.withAlpha(153),
                ],
              ),
            ),
          ),
          // Contenido
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Center text for mobile
                  children: [
                    Text(
                      'Nuestra Historia',
                      style: AppTypography.displayLarge(context).copyWith(
                        color: Colors.white,
                        fontSize: 32, // Adjusted font size for mobile
                      ),
                      textAlign: TextAlign.center, // Center text for mobile
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 734),
                      child: Text(
                        'Conoce la trayectoria, valores y compromiso que han convertido a Justicia Administrativa en un referente del derecho administrativo y la innovación legal en México.',
                        style: AppTypography.bodyLarge(context).copyWith(
                          color: Colors.white.withAlpha(230),
                          fontSize: 16, // Adjusted font size for mobile
                        ),
                        textAlign: TextAlign.center, // Center text for mobile
                      ),
                    ),
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

class _BreadcrumbSection extends StatelessWidget {
  const _BreadcrumbSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md, // Adjusted vertical padding
        horizontal: AppSpacing.pagePadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Row(
            children: [
              Icon(
                Icons.home_filled,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Inicio', style: AppTypography.bodySmall(context)), // Updated AppTypography call
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Nosotros',
                style: AppTypography.bodySmall(context).copyWith( // Updated AppTypography call
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroSection extends StatelessWidget {
  const _IntroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Text(
            'Somos un ecosistema jurídico-tecnológico que revoluciona la práctica del derecho administrativo en Iberoamérica donde convergen tanto la experiencia jurídica de magistrados en retiro, funcionarios públicos, consultores, académicos y litigantes como los conocimientos de ingenieros expertos en inteligencia artificial. Nuestro equipo interdisciplinario, distribuido estratégicamente entre México, España, Argentina y Canadá crea soluciones que fusionan tres elementos: desarrollo de software jurídico con inteligencia artificial personalizada, prestación de servicios legales especializados y un sistema de conexión entre clientes iberoamericanos y expertos en derecho administrativo iberoamericano.',
            style: AppTypography.bodyLarge(context), // Updated AppTypography call
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection();

  static final List<Map<String, dynamic>> timelineData = [
    {
      'year': '2025',
      'title': 'Fundación de Justicia Administrativa',
      'description':
          'Nace un nuevo ecosistema jurídico-tecnológico con el objetivo de revolucionar la práctica del derecho administrativo, fusionando la experiencia legal con la inteligencia artificial para crear soluciones innovadoras en Iberoamérica.',
      'isLeft': true,
      'color': AppColors.accentGold,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            children: [
              Text(
                'Nuestra Trayectoria',
                style: AppTypography.headingLarge(context), // Updated AppTypography call
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 768),
                child: Text(
                  'Nuestra trayectoria colectiva incluye la experiencia iberoamericana de dictar sentencias de lo contencioso administrativo, colaborar en las administraciones públicas, litigar derecho administrativo, impartir clases sobre esta disciplina y realizar investigaciones científicas, asimismo, más de 10 años de estudios y asesorías tanto en derecho digital como en informática. Todo esto proporciona el conocimiento empírico para entrenar algoritmos de inteligencia artificial que realmente permitan mejorar la práctica del derecho administrativo y solucionar problemas a las administraciones públicas, los órganos jurisdiccionales y los despachos jurídicos con el fin de construir una mejor sociedad.',
                  style: AppTypography.bodyMedium(context), // Updated AppTypography call
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              ResponsiveBuilder( // Using ResponsiveBuilder
                builder: (context, breakpoint) {
                  return _TimelineList(timelineData: timelineData, isMobile: breakpoint == BreakpointType.mobile); // isMobile added
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.timelineData, required this.isMobile});

  final bool isMobile;
  final List<Map<String, dynamic>> timelineData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < timelineData.length; i++)
          _TimelineItem(
            year: timelineData[i]['year'] as String,
            title: timelineData[i]['title'] as String,
            description: timelineData[i]['description'] as String,
            isLeft: isMobile ? true : timelineData[i]['isLeft'] as bool,
            color: timelineData[i]['color'] as Color,
            isMobile: isMobile,
            isLast: i == timelineData.length - 1, // <-- FIX: Pass isLast flag
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.year,
    required this.title,
    required this.description,
    required this.isLeft,
    required this.color,
    required this.isMobile,
    required this.isLast, // <-- FIX: Receive isLast flag
  });

  final Color color;
  final String description;
  final bool isLast; // <-- FIX: Receive isLast flag
  final bool isLeft;
  final bool isMobile;
  final String title;
  final String year;

  @override
  Widget build(BuildContext context) {
    final card = Flexible(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$year: $title',
                style: AppTypography.headingSmall(context).copyWith(color: color),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(description, style: AppTypography.bodyMedium(context)),
            ],
          ),
        ),
      ),
    );

    final spacer = Flexible(child: Container());

    final dotAndLine = SizedBox(
      width: isMobile ? 40 : null,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              width: 2,
              // <-- FIX: Use isLast to determine color
              color: !isLast ? AppColors.divider : Colors.transparent,
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 4),
            ),
          ),
          Expanded(
            child: Container(
              width: 2,
              // <-- FIX: Use isLast to determine color
              color: !isLast ? AppColors.divider : Colors.transparent,
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [dotAndLine, card],
        ),
      );
    } else {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLeft) card else spacer,
            dotAndLine,
            if (!isLeft) card else spacer,
          ],
        ),
      );
    }
  }
}

class _MissionVisionSection extends StatelessWidget {
  const _MissionVisionSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: ResponsiveBuilder( // Using ResponsiveBuilder
            builder: (context, breakpoint) {
              final missionCard = const _MissionCard();
              final visionCard = const _VisionCard();

              if (breakpoint == BreakpointType.mobile || breakpoint == BreakpointType.tablet) {
                return Column(
                  children: [
                    missionCard,
                    const SizedBox(height: AppSpacing.lg),
                    visionCard,
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: missionCard),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(child: visionCard),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.flag, size: 48, color: AppColors.accentGold),
            const SizedBox(height: AppSpacing.lg),
            Text('Misión', style: AppTypography.headingMedium(context)), // Updated AppTypography call
            const SizedBox(height: AppSpacing.md),
            Text(
              'Transformar la práctica del derecho administrativo en Iberoamérica mediante el desarrollo de tecnologías digitales personalizadas para crear soluciones que no solo digitalizan procesos administrativos, sino que los rediseñan completamente, filtrando y corrigiendo las limitaciones de las administraciones públicas y del derecho administrativo, garantizando que la innovación tecnológica mejore a la gestión pública, a la justicia administrativa y a la práctica jurídica con el fin de que estén al servicio de las personas.',
              style: AppTypography.bodyMedium(context), // Updated AppTypography call
            ),
          ],
        ),
      ),
    );
  }
}

class _VisionCard extends StatelessWidget {
  const _VisionCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.visibility, size: 48, color: AppColors.techBlue),
            const SizedBox(height: AppSpacing.lg),
            Text('Visión', style: AppTypography.headingMedium(context)), // Updated AppTypography call
            const SizedBox(height: AppSpacing.md),
            Text(
              'Ser reconocidos como el ecosistema jurídico-tecnológico líder que logró revolucionar definitivamente la relación entre ciudadanos, administraciones públicas y órganos jurisdiccionales en Iberoamérica, donde nuestras tecnologías inteligentes hayan eliminado la opacidad, lentitud y complejidad innecesaria del derecho administrativo tradicional, creando un nuevo paradigma de justicia administrativa verdaderamente accesible, eficiente y respetuosa de los derechos fundamentales. Nuestra aspiración es que para 2035, la práctica del derecho administrativo en la región sea sinónimo de transparencia, rapidez y efectividad gracias a nuestras soluciones tecnológicas que habrán demostrado que es posible construir una mejor sociedad cuando la inteligencia artificial se diseña conscientemente para servir al interés general y potenciar los mejores valores del derecho público.',
              style: AppTypography.bodyMedium(context), // Updated AppTypography call
            ),
          ],
        ),
      ),
    );
  }
}


class _AwardsSection extends StatelessWidget {
  const _AwardsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            children: [
              Text(
                'Reconocimientos y Premios',
                style: AppTypography.headingLarge(context), // Updated AppTypography call
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 730),
                child: Text(
                  'Nuestro equipo multidisciplinario ha sido reconocido por su excelencia académica, investigación innovadora y contribuciones al avance del conocimiento en derecho, tecnología y ciencias.',
                  style: AppTypography.bodyMedium(context), // Updated AppTypography call
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              ResponsiveBuilder( // Using ResponsiveBuilder
                builder: (context, breakpoint) {
                  final awardCards = [
                    const _AwardCard(
                      icon: Icons.school,
                      title: 'Formación Académica Destacada',
                      description:
                          'Equipo con maestrías en Anticorrupción (UP), PhD en Física (Sorbonne Université) y estudios en Ciencias de la Computación (UNAM).',
                    ),
                    const _AwardCard(
                      icon: Icons.emoji_events,
                      title: 'Reconocimientos Internacionales',
                      description:
                          'Prix du Centre de Recherche de l\'École Polytechnique 2017 al mejor proyecto de investigación estudiantil. Múltiple podios en la Olimpiada Internacional de Lógica.',
                    ),
                    const _AwardCard(
                      icon: Icons.science,
                      title: 'Publicaciones Científicas',
                      description:
                          'Investigaciones publicadas en PNAS, Nature Communications y Physical Review X Quantum sobre IA, evolución molecular y física cuántica.',
                    ),
                  ];

                  if (breakpoint == BreakpointType.mobile || breakpoint == BreakpointType.tablet) {
                    return Column(
                      children: awardCards.expand((card) => [card, const SizedBox(height: AppSpacing.lg)]).toList()..removeLast(), // Add spacing between cards
                    );
                  } else { // Desktop
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: awardCards.map((card) => Expanded(child: card)).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _AwardCard extends StatelessWidget {
  const _AwardCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final String description;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(icon, size: 48, color: AppColors.accentGold),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.headingSmall(context), // Updated AppTypography call
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              description,
              style: AppTypography.bodyMedium(context), // Updated AppTypography call
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AffiliationsSection extends StatelessWidget {
  const _AffiliationsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            children: [
              Text(
                'Afiliaciones Profesionales',
                style: AppTypography.headingLarge(context), // Updated AppTypography call
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 751),
                child: Text(
                  'Participamos activamente en las principales organizaciones y asociaciones del sector legal y tecnológico, contribuyendo al desarrollo de nuestra profesión.',
                  style: AppTypography.bodyMedium(context), // Updated AppTypography call
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const _AffiliationCard( // Added const
                icon: Icons.public,
                title: 'Foro Iberoamericano de Derecho Administrativo',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AffiliationCard extends StatelessWidget {
  const _AffiliationCard({required this.icon, required this.title}); // Added const

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: AppColors.primaryNavy),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppTypography.bodyMedium(context).copyWith( // Updated AppTypography call
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialResponsibilitySection extends StatelessWidget {
  const _SocialResponsibilitySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            children: [
              Text(
                'Responsabilidad Social',
                style: AppTypography.headingLarge(context), // Updated AppTypography call
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 734),
                child: Text(
                  'Creemos firmemente en devolver a la sociedad y contribuir al desarrollo de un sistema legal más justo, accesible y eficiente para todos.',
                  style: AppTypography.bodyMedium(context), // Updated AppTypography call
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              ResponsiveBuilder( // Using ResponsiveBuilder
                builder: (context, breakpoint) {
                  final socialCards = [
                    const _SocialCard(
                      icon: Icons.volunteer_activism,
                      title: 'Programa Pro Bono',
                      description:
                          'Dedicamos más de 2,000 horas anuales a casos pro bono, representando a personas y comunidades de escasos recursos en asuntos administrativos contra autoridades.',
                      stat: '500+',
                      statDescription: 'casos pro bono atendidos desde 2010',
                    ),
                    const _SocialCard(
                      icon: Icons.school,
                      title: 'Educación Legal',
                      description:
                          'Ofrecemos talleres y cursos gratuitos sobre derecho administrativo en universidades públicas y comunidades rurales, democratizando el conocimiento legal.',
                      stat: '25+',
                      statDescription: 'universidades beneficiadas en todo México',
                    ),
                  ];

                  if (breakpoint == BreakpointType.mobile || breakpoint == BreakpointType.tablet) {
                    return Column(
                      children: socialCards.expand((card) => [card, const SizedBox(height: AppSpacing.lg)]).toList()..removeLast(), // Add spacing between cards
                    );
                  } else { // Desktop
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: socialCards.map((card) => Expanded(child: card)).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  const _SocialCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.stat,
    required this.statDescription,
    this.color,
  });

  final Color? color;
  final String description;
  final IconData icon;
  final String stat;
  final String statDescription;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: AppColors.accentGold),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.headingSmall(context).copyWith(color: color),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(description, style: AppTypography.bodyMedium(context)),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat,
                  style: AppTypography.displayMedium(context).copyWith(
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      statDescription,
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadershipSection extends StatelessWidget {
  const _LeadershipSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            children: [
              Text(
                'Nuestro Liderazgo',
                style: AppTypography.headingLarge(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 752),
                child: Text(
                  'Conoce a los socios fundadores que lideran nuestra firma, combinando experiencia jurídica de primer nivel con innovación tecnológica.',
                  style: AppTypography.bodyMedium(context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              ResponsiveBuilder(
                builder: (context, breakpoint) {
                  final cofounders = [
                    const _CofounderCard(
                      imagePath: 'assets/images/alfredo.jpg',
                      name: 'Lic. Alfredo Delgadillo López',
                      title: 'Co-Fundador y Socio Director',
                      education: [
                        'Licenciatura en Derecho (UAN)',
                        'Maestría en Anticorrupción (Universidad Panamericana)',
                      ],
                      bulletPoints: [
                        'Fundador de justicIAdministrativa',
                        'Profesor en universidades de México e Iberoamérica en Derecho Administrativo y Digital',
                        'Autor y coordinador de libros sobre derecho administrativo y derecho digital',
                        'Abogado Digital certificado por la Academia Mexicana de Derecho Informático',
                        'Coordinador del Seminario Derecho Administrativo en la 4ª Revolución Industrial - IIJUNAM',
                        'Columnista en diversos periódicos en México',
                        'Asesor jurídico y litigante en derecho público y derecho digital',
                      ],
                      specialties: [
                        'Amparo Administrativo',
                        'Contencioso Administrativo',
                        'Licitaciones Públicas',
                        'Derecho Digital',
                      ],
                    ),
                    const _CofounderCard(
                      imagePath: 'assets/images/emilio.jpg',
                      name: 'Emilio Antonio Pérez Ocampo',
                      title: 'Co-Fundador e Ingeniero Líder de Software',
                      education: [
                        'Licenciatura en Ciencias de la Computación (UNAM)',
                        'Licenciatura en Filosofía (UAN)',
                      ],
                      bulletPoints: [
                        'Co-fundador de justicIAdministrativa y Generalytics',
                        'Líder de desarrollo técnico con 4.5 años de experiencia profesional',
                        'Desarrollador de sistemas RAG para documentos legales mexicanos',
                        'Creador del asistente de voz en C++ para navegación de documentos legales',
                        'Arquitecto de plataformas legales con AI streaming en tiempo real',
                        'Experto en aplicaciones iOS/AR, Flutter, C++ y microservicios',
                        'Líder de equipos de hasta 8 ingenieros y científicos de datos',
                      ],
                      specialties: [
                        'Inteligencia Artificial Legal',
                        'Sistemas RAG',
                        'Desarrollo iOS/AR',
                        'Arquitectura de Software',
                      ],
                    ),
                  ];

                  if (breakpoint == BreakpointType.mobile) {
                    return Column(
                      children: cofounders
                          .expand((card) => [card, const SizedBox(height: AppSpacing.xl)])
                          .toList()
                        ..removeLast(),
                    );
                  } else if (breakpoint == BreakpointType.tablet) {
                    return Column(
                      children: cofounders
                          .expand((card) => [card, const SizedBox(height: AppSpacing.xl)])
                          .toList()
                        ..removeLast(),
                    );
                  } else {
                    // Desktop: side by side
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: cofounders[0]),
                        const SizedBox(width: AppSpacing.xl),
                        Expanded(child: cofounders[1]),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CofounderCard extends StatelessWidget {
  const _CofounderCard({
    required this.imagePath,
    required this.name,
    required this.title,
    required this.education,
    required this.bulletPoints,
    required this.specialties,
  });

  final String imagePath;
  final String name;
  final String title;
  final List<String> education;
  final List<String> bulletPoints;
  final List<String> specialties;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: ResponsiveBuilder(
        builder: (context, breakpoint) {
          double imageHeight;
          if (breakpoint == BreakpointType.mobile) {
            imageHeight = 250;
          } else if (breakpoint == BreakpointType.tablet) {
            imageHeight = 350;
          } else {
            imageHeight = 400;
          }

          final imageWidget = SizedBox(
            width: double.infinity,
            height: imageHeight,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: AppColors.textTertiary,
                  ),
                );
              },
            ),
          );

          final contentWidget = Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.headingMedium(context),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  style: AppTypography.bodyLarge(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(height: AppSpacing.xl),
                Text(
                  'Formación Académica',
                  style: AppTypography.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                ...education.map((item) => _EducationItem(item)),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Trayectoria Profesional',
                  style: AppTypography.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                ...bulletPoints.map((item) => _BulletItem(item)),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Áreas de Especialización',
                  style: AppTypography.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: specialties
                      .map((spec) => Chip(label: Text(spec)))
                      .toList(),
                ),
              ],
            ),
          );

          return Column(
            children: [
              imageWidget,
              contentWidget,
            ],
          );
        },
      ),
    );
  }
}

class _EducationItem extends StatelessWidget {
  const _EducationItem(this.text); // Added const

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(Icons.school, size: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: AppTypography.bodyMedium(context))), // Updated AppTypography call
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem(this.text); // Added const

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(
              Icons.arrow_right,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: AppTypography.bodyMedium(context))), // Updated AppTypography call
        ],
      ),
    );
  }
}