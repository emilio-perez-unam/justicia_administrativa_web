part of '../about.dart';

class _MissionVisionSection extends StatelessWidget {
  const _MissionVisionSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: isWide ? 1 : 0, child: const _MissionCard()),
            SizedBox(width: isWide ? 32 : 0, height: isWide ? 0 : 32),
            Expanded(flex: isWide ? 1 : 0, child: const _VisionCard()),
          ],
        );
      },
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: const Border(top: BorderSide(color: navyColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: navyColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.target, color: navyColor, size: 24),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nuestra Misión',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: navyColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Transformar la práctica del derecho administrativo en '
            'Iberoamérica mediante el desarrollo de tecnologías digitales '
            'personalizadas para crear soluciones que no solo digitalizan '
            'procesos administrativos, sino que los rediseñan '
            'completamente, filtrando y corrigiendo las limitaciones de '
            'las administraciones públicas y del derecho administrativo, '
            'garantizando que la innovación tecnológica mejore a la '
            'gestión pública, a la justicia administrativa y a la '
            'práctica jurídica con el fin de que estén al servicio de '
            'las personas.',
            style: TextStyle(color: colors.mutedForeground, height: 1.7),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }
}

class _VisionCard extends StatelessWidget {
  const _VisionCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);
    const tealColor = Color(0xFF0D9488);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: const Border(top: BorderSide(color: tealColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tealColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.eye, color: tealColor, size: 24),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nuestra Visión',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: navyColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ser reconocidos como el ecosistema jurídico-tecnológico líder '
            'que logró revolucionar definitivamente la relación entre '
            'ciudadanos, administraciones públicas y órganos '
            'jurisdiccionales en Iberoamérica, donde nuestras tecnologías '
            'inteligentes hayan eliminado la opacidad, lentitud y '
            'complejidad innecesaria del derecho administrativo '
            'tradicional, creando un nuevo paradigma de justicia '
            'administrativa verdaderamente accesible, eficiente y '
            'respetuosa de los derechos fundamentales. Nuestra aspiración '
            'es que para 2035, la práctica del derecho administrativo en '
            'la región sea sinónimo de transparencia, rapidez y '
            'efectividad gracias a nuestras soluciones tecnológicas.',
            style: TextStyle(color: colors.mutedForeground, height: 1.7),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
}

// ---------------------------------------------------------------------------
// Awards / Recognitions
// ---------------------------------------------------------------------------

class _AwardsSection extends StatelessWidget {
  const _AwardsSection();

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);
    const goldColor = Color(0xFFD4AF37);

    return Column(
      children: [
        const SectionHeader(
          eyebrow: 'Reconocimientos',
          title: 'Formación y excelencia',
          subtitle:
              'Nuestro equipo combina formación académica de primer nivel, '
              'reconocimientos internacionales y publicaciones científicas '
              'en revistas de alto impacto.',
          center: true,
        ),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 960;
            final itemWidth = isWide
                ? (constraints.maxWidth - 64) / 3
                : constraints.maxWidth;

            return Wrap(
              spacing: 32,
              runSpacing: 32,
              children: [
                _AwardCard(
                  width: itemWidth,
                  icon: LucideIcons.graduationCap,
                  title: 'Formación Académica Destacada',
                  description:
                      'Equipo con maestrías en Anticorrupción '
                      '(Universidad Panamericana), PhD en Física '
                      '(Sorbonne Université) y estudios en Ciencias '
                      'de la Computación (UNAM).',
                  accentColor: goldColor,
                  titleColor: navyColor,
                ),
                _AwardCard(
                  width: itemWidth,
                  icon: LucideIcons.trophy,
                  title: 'Reconocimientos Internacionales',
                  description:
                      'Prix du Centre de Recherche de l\'École '
                      'Polytechnique 2017 al mejor proyecto de '
                      'investigación estudiantil. Múltiples podios en '
                      'la Olimpiada Internacional de Lógica.',
                  accentColor: goldColor,
                  titleColor: navyColor,
                ),
                _AwardCard(
                  width: itemWidth,
                  icon: LucideIcons.fileText,
                  title: 'Publicaciones Científicas',
                  description:
                      'Investigaciones publicadas en PNAS, Nature '
                      'Communications y Physical Review X Quantum '
                      'sobre IA, evolución molecular y física cuántica.',
                  accentColor: goldColor,
                  titleColor: navyColor,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AwardCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final Color titleColor;

  const _AwardCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: width,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: accentColor, size: 40),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: colors.mutedForeground, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Affiliation banner (single real affiliation)
// ---------------------------------------------------------------------------
