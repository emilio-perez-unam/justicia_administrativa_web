// Owns the contact header and office-list section layout.

part of '../contact.dart';

class _ContactHeader extends StatelessWidget {
  const _ContactHeader();

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
                'https://images.unsplash.com/photo-1759494930453-6b8182b0e27e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1920',
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: const Color(0xFF1E3A8A)),
            errorWidget: (context, url, error) =>
                Container(color: const Color(0xFF1E3A8A)),
          ),
          Container(color: const Color(0xFF1E3A8A).withValues(alpha: 0.8)),
          Center(
            child: MaxWidth(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                        'Contáctenos',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  Text(
                    'Estamos a su disposición para resolver sus consultas legales y tecnológicas. Nuestro equipo internacional está listo para atenderle.',
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

class _OfficesSection extends StatelessWidget {
  const _OfficesSection();

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: "Ubicaciones",
            title: "Nuestras Oficinas",
            subtitle:
                "Encuéntrenos en nuestros principales centros de operaciones.",
            center: true,
          ),
          const SizedBox(height: 48),

          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1024;
              final isTablet =
                  constraints.maxWidth >= 640 && constraints.maxWidth < 1024;
              final columns = isDesktop ? 4 : (isTablet ? 2 : 1);
              final effectiveColumns = _contactOffices.length < columns
                  ? _contactOffices.length
                  : columns;
              final cardWidth = effectiveColumns <= 1
                  ? (constraints.maxWidth < 380 ? constraints.maxWidth : 380.0)
                  : (constraints.maxWidth - (effectiveColumns - 1) * 24) /
                        effectiveColumns;

              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 24,
                children: _contactOffices.asMap().entries.map((entry) {
                  final index = entry.key;
                  final office = entry.value;
                  return SizedBox(
                    width: cardWidth,
                    child: _OfficeCard(office: office, delay: (index * 100).ms),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
