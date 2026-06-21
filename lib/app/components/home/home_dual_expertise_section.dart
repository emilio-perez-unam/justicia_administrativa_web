// Homepage value proposition section for the live site.
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_theme_extension.dart';
import '../section_container.dart';

/// Presents the brand promise as balanced legal and technology pillars.
class HomeDualExpertiseSection extends StatelessWidget {
  const HomeDualExpertiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);

    return SectionContainer(
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'Nuestra Propuesta de Valor',
            title: 'Excelencia Legal + Innovación Tecnológica',
            subtitle:
                'Combinamos décadas de experiencia en derecho administrativo '
                'con las últimas tecnologías de inteligencia artificial para '
                'ofrecer soluciones jurídicas más eficientes, precisas y '
                'accesibles.',
            center: true,
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _expertisePillars.asMap().entries.map((entry) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: entry.key > 0 ? 16 : 0,
                          right: entry.key < _expertisePillars.length - 1
                              ? 16
                              : 0,
                        ),
                        child: _ExpertiseCard(pillar: entry.value),
                      ),
                    );
                  }).toList(),
                );
              }

              return Column(
                children: _expertisePillars
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _ExpertiseCard(pillar: p),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 48),
          const _ExpertiseConnector(goldColor: goldColor),
        ],
      ),
    );
  }
}

class _ExpertisePillar {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> features;

  const _ExpertisePillar({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.features,
  });
}

const _expertisePillars = <_ExpertisePillar>[
  _ExpertisePillar(
    title: 'Excelencia Legal Tradicional',
    subtitle: 'Décadas de experiencia',
    description:
        'Ofrecemos servicios jurídicos de primer nivel con abogados '
        'especializados en derecho administrativo mexicano, respaldados '
        'por décadas de experiencia y un historial comprobado de éxito.',
    icon: LucideIcons.gavel,
    color: Color(0xFF1E3A8A),
    features: [
      'Amplia experiencia en tribunales administrativos',
      'Asesoría especializada en regulación mexicana',
      'Representación legal ante autoridades federales',
      'Estrategias legales personalizadas',
    ],
  ),
  _ExpertisePillar(
    title: 'Innovación Tecnológica',
    subtitle: 'IA de última generación',
    description:
        'Integramos tecnologías de inteligencia artificial y aprendizaje '
        'automático para revolucionar la práctica legal, ofreciendo '
        'soluciones más rápidas, precisas y eficientes.',
    icon: LucideIcons.brain,
    color: Color(0xFF0D9488),
    features: [
      'Análisis automatizado de documentos legales',
      'Modelos de IA entrenados en leyes mexicanas',
      'Monitoreo regulatorio en tiempo real',
      'Predicción de resultados judiciales',
    ],
  ),
];

class _ExpertiseCard extends StatelessWidget {
  final _ExpertisePillar pillar;

  const _ExpertiseCard({required this.pillar});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const goldColor = Color(0xFFD4AF37);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(colors.radiusLg),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: pillar.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(pillar.icon, color: pillar.color, size: 32),
          ),
          const SizedBox(height: 24),
          Text(
            pillar.title,
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: pillar.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pillar.subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: goldColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pillar.description,
            style: TextStyle(
              fontSize: 15,
              color: colors.mutedForeground,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          ...pillar.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}

class _ExpertiseConnector extends StatelessWidget {
  final Color goldColor;

  const _ExpertiseConnector({required this.goldColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.transparent, goldColor]),
            ),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [goldColor, const Color(0xFFE8C96A)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: goldColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(LucideIcons.plus, color: Colors.white, size: 24),
        ),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [goldColor, Colors.transparent]),
            ),
          ),
        ),
      ],
    ).animate(delay: 400.ms).fadeIn(duration: 600.ms);
  }
}
