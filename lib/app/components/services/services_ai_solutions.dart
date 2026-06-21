part of '../services.dart';

class _AiSolutionsSection extends StatelessWidget {
  const _AiSolutionsSection();

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF0D9488);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.brain, size: 32, color: tealColor),
            const SizedBox(width: 12),
            Text(
              'Soluciones de Inteligencia Artificial',
              style: TextStyle(
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: tealColor,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 12),
        Text(
          'Herramientas de IA diseñadas específicamente para el sector '
          'jurídico mexicano.',
          style: TextStyle(
            fontSize: 16,
            color: context.colors.mutedForeground,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _aiSolutions.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: entry.key > 0 ? 12 : 0,
                        right: entry.key < _aiSolutions.length - 1 ? 12 : 0,
                      ),
                      child: _AiSolutionCard(solution: entry.value),
                    ),
                  );
                }).toList(),
              );
            }
            return Column(
              children: _aiSolutions
                  .map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _AiSolutionCard(solution: s),
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

// ---------------------------------------------------------------------------
// AI solution card
// ---------------------------------------------------------------------------

class _AiSolutionCard extends StatelessWidget {
  final _AiSolution solution;

  const _AiSolutionCard({required this.solution});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const tealColor = Color(0xFF0D9488);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(colors.radiusLg),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tealColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(solution.icon, color: tealColor, size: 28),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            solution.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: tealColor,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            solution.description,
            style: TextStyle(
              fontSize: 14,
              color: colors.foreground,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),

          // Features
          ...solution.features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: const BoxDecoration(
                      color: tealColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors.foreground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          f.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.mutedForeground,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Format pills
          if (solution.formats != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: solution.formats!
                  .map(
                    (format) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tealColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        format,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: tealColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          const SizedBox(height: 20),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go(AppRouter.aiAssistant),
              style: OutlinedButton.styleFrom(
                foregroundColor: tealColor,
                side: const BorderSide(color: tealColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Text(
                'Explorar Demo IA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              label: const Icon(LucideIcons.arrowRight, size: 16),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}
