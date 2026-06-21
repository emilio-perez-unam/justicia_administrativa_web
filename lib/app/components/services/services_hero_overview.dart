part of '../services.dart';

class _ServicesHero extends StatelessWidget {
  const _ServicesHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1589829545856-d10d557cf95f'
                '?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1920',
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: const Color(0xFF1E3A8A)),
            errorWidget: (context, url, error) =>
                Container(color: const Color(0xFF1E3A8A)),
          ),
          Container(color: const Color(0xFF1E3A8A).withValues(alpha: 0.85)),
          Center(
            child: MaxWidth(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                        'Nuestros Servicios',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                              fontFamily:
                                  GoogleFonts.playfairDisplay().fontFamily,
                            ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  Text(
                    'La convergencia entre excelencia jurídica y tecnología '
                    'de vanguardia al servicio de la justicia administrativa.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Services overview (3 pillar cards)
// ---------------------------------------------------------------------------

class _OverviewPillar {
  final String title;
  final String description;
  final IconData icon;
  final List<String> features;

  const _OverviewPillar({
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
  });
}

const _overviewPillars = <_OverviewPillar>[
  _OverviewPillar(
    title: 'Inteligencia Artificial',
    description: 'Desarrollo de software jurídico personalizado.',
    icon: LucideIcons.bot,
    features: [
      'Desarrollo de software jurídico personalizado',
      'Entrenamiento de algoritmos especializados',
      'Sistemas de análisis predictivo',
    ],
  ),
  _OverviewPillar(
    title: 'Transformación Digital',
    description: 'Convertir expedientes físicos en archivos digitales.',
    icon: LucideIcons.monitor,
    features: [
      'Digitalización de expedientes',
      'Control y búsqueda inmediata',
      'Ecosistema digital completo',
    ],
  ),
  _OverviewPillar(
    title: 'Consultoría Jurídica',
    description: 'Asesoría legal especializada.',
    icon: LucideIcons.gavel,
    features: [
      'Contratación pública',
      'Responsabilidad patrimonial del Estado',
      'Amparo en materia administrativa',
    ],
  ),
];

class _ServicesOverview extends StatelessWidget {
  const _ServicesOverview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(
          eyebrow: 'Nuestros Servicios',
          title: 'Tres pilares al servicio de la justicia',
          subtitle:
              'La convergencia entre excelencia jurídica y tecnología de '
              'vanguardia para transformar la práctica del derecho '
              'administrativo en Iberoamérica.',
          center: true,
        ),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _overviewPillars.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: entry.key > 0 ? 12 : 0,
                        right: entry.key < _overviewPillars.length - 1 ? 12 : 0,
                      ),
                      child: _OverviewCard(pillar: entry.value),
                    ),
                  );
                }).toList(),
              );
            }
            return Column(
              children: _overviewPillars
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _OverviewCard(pillar: p),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final _OverviewPillar pillar;

  const _OverviewCard({required this.pillar});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);
    const goldColor = Color(0xFFD4AF37);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(colors.radiusLg),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  navyColor.withValues(alpha: 0.08),
                  navyColor.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(pillar.icon, color: navyColor, size: 32),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            pillar.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: navyColor,
            ),
          ),
          const SizedBox(height: 12),

          // Gold decorative divider
          Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [goldColor, Color(0xFFE8C96A)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Features
          ...pillar.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.checkCircle,
                    color: goldColor,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.foreground,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CTA
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go(AppRouter.contact),
              style: OutlinedButton.styleFrom(
                foregroundColor: navyColor,
                side: const BorderSide(color: navyColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Conocer más',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  const Icon(LucideIcons.arrowRight, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}

// ---------------------------------------------------------------------------
// Practice areas section (16 accordion cards)
// ---------------------------------------------------------------------------
