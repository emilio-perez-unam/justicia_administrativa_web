part of '../services.dart';

class _PracticeAreasSection extends StatefulWidget {
  const _PracticeAreasSection();

  @override
  State<_PracticeAreasSection> createState() => _PracticeAreasSectionState();
}

class _PracticeAreasSectionState extends State<_PracticeAreasSection> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);
    final areaCount = _practiceAreas.length;
    final serviceCount = _practiceAreas.fold<int>(
      0,
      (sum, area) => sum + area.services.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.scale, size: 32, color: navyColor),
            const SizedBox(width: 12),
            Text(
              'Áreas de Práctica Legal',
              style: TextStyle(
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: navyColor,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 12),
        Text(
          '$areaCount áreas de especialización en derecho administrativo '
          'con $serviceCount servicios individuales.',
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
              final left = _practiceAreas.sublist(0, 8);
              final right = _practiceAreas.sublist(8);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildColumn(left, 0)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildColumn(right, 8)),
                ],
              );
            }
            return _buildColumn(_practiceAreas, 0);
          },
        ),
      ],
    );
  }

  Widget _buildColumn(List<_PracticeArea> areas, int startIndex) {
    return Column(
      children: areas.asMap().entries.map((entry) {
        final index = startIndex + entry.key;
        final area = entry.value;
        final isExpanded = _expandedIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PracticeAreaCard(
            area: area,
            isExpanded: isExpanded,
            onTap: () => setState(() {
              _expandedIndex = isExpanded ? null : index;
            }),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Practice area card (accordion)
// ---------------------------------------------------------------------------

class _PracticeAreaCard extends StatelessWidget {
  final _PracticeArea area;
  final bool isExpanded;
  final VoidCallback onTap;

  const _PracticeAreaCard({
    required this.area,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedContainer(
      duration: 300.ms,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(colors.radiusLg),
        border: Border.all(
          color: isExpanded ? area.color : colors.border,
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: area.color.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Header ──
          InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: area.color, width: 4)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? area.color
                          : area.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      area.icon,
                      color: isExpanded ? Colors.white : area.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      area.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isExpanded ? area.color : colors.foreground,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${area.services.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: 300.ms,
                    child: Icon(
                      LucideIcons.chevronDown,
                      color: isExpanded ? area.color : colors.mutedForeground,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expandable body ──
          AnimatedSize(
            duration: 300.ms,
            alignment: Alignment.topCenter,
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: area.color.withValues(alpha: 0.03),
                      border: Border(
                        left: BorderSide(color: area.color, width: 4),
                        top: BorderSide(color: colors.border),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...area.services.map(
                          (service) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(top: 7),
                                  decoration: BoxDecoration(
                                    color: area.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    service,
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
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go(AppRouter.contact),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: area.color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Text(
                              'Solicitar Consulta',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            label: const Icon(LucideIcons.arrowRight, size: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AI solutions section (3 always-visible cards)
// ---------------------------------------------------------------------------
