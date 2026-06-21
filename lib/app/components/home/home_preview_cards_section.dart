// Homepage navigation cards for primary live-site destinations.
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../router.dart';

/// Renders responsive preview cards that route visitors to core pages.
class HomePreviewCardsSection extends StatelessWidget {
  const HomePreviewCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Text(
            'Explora Nuestro Sitio',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: navyColor,
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          Text(
            'Conoce más sobre nuestros servicios y trayectoria',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;
              final isTablet = constraints.maxWidth >= 600;
              final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);
              final spacing = 24.0;
              final cardWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: _previewCards.asMap().entries.map((entry) {
                  final index = entry.key;
                  final card = entry.value;
                  return SizedBox(
                    width: cardWidth,
                    child: _PreviewCard(data: card, delay: index * 100),
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

class _PreviewData {
  final IconData icon;
  final String title;
  final String description;
  final String route;

  const _PreviewData({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
  });
}

const _previewCards = <_PreviewData>[
  _PreviewData(
    icon: LucideIcons.briefcase,
    title: 'Servicios',
    description:
        'Soluciones legales especializadas en derecho administrativo con tecnología de vanguardia.',
    route: AppRouter.services,
  ),
  _PreviewData(
    icon: LucideIcons.building,
    title: 'Nosotros',
    description:
        'Un equipo que combina excelencia jurídica con innovación tecnológica al servicio del derecho administrativo.',
    route: AppRouter.about,
  ),
  _PreviewData(
    icon: LucideIcons.users,
    title: 'Equipo',
    description:
        'Profesionales altamente calificados comprometidos con la justicia administrativa.',
    route: AppRouter.team,
  ),
  _PreviewData(
    icon: LucideIcons.newspaper,
    title: 'Blog',
    description:
        'Artículos, análisis y publicaciones sobre derecho administrativo en México.',
    route: AppRouter.blog,
  ),
];

class _PreviewCard extends StatefulWidget {
  final _PreviewData data;
  final int delay;

  const _PreviewCard({required this.data, required this.delay});

  @override
  State<_PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<_PreviewCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);
    const goldColor = Color(0xFFD4AF37);

    return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () => context.go(widget.data.route),
            child: AnimatedContainer(
              duration: 200.ms,
              padding: const EdgeInsets.all(32),
              transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered ? goldColor : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? goldColor.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: _isHovered ? 20 : 8,
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
                      color: _isHovered ? goldColor : navyColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.data.icon,
                      color: _isHovered ? navyColor : goldColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.data.title,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: navyColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.data.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Ver más',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isHovered ? goldColor : navyColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        LucideIcons.arrowRight,
                        size: 16,
                        color: _isHovered ? goldColor : navyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay))
        .slideY(begin: 0.15, end: 0);
  }
}
