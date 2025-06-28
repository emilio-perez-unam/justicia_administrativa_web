import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/ai_solution.dart';

class AiSolutionsScreen extends StatefulWidget {
  const AiSolutionsScreen({super.key});

  @override
  State<AiSolutionsScreen> createState() => _AiSolutionsScreenState();
}

class _AiSolutionsScreenState extends State<AiSolutionsScreen> {
  // --- Data Layer (Updated with new image for LexisRAG) ---
  final List<AiSolution> solutions = [
    const AiSolution(
      icon: Icons.psychology_alt,
      title: 'JusticiaGPT',
      description:
          'Modelo de lenguaje especializado entrenado con la legislación mexicana, jurisprudencia y doctrina legal. Proporciona respuestas precisas a consultas jurídicas complejas en segundos.',
      features: [
        'Investigación Jurídica: Encuentra precedentes y normativa relevante en segundos.',
        'Redacción de Documentos: Genera borradores de escritos legales con fundamentos jurídicos.',
        'Análisis Predictivo: Evalúa probabilidades de éxito basado en casos similares.',
      ],
      demoImageAsset: 'assets/images/demo_justicia_gpt.png',
      supportedFormats: ['94% Precisión'],
      callToAction: 'Ver Documentación Completa',
    ),
    const AiSolution(
      icon: Icons.find_in_page,
      title: 'LexisRAG System',
      description:
          'Sistema de Recuperación Aumentada por Generación (RAG) que analiza, clasifica y extrae información clave de grandes volúmenes de documentos legales en minutos.',
      features: [
        'Análisis de Contratos: Identifica cláusulas de riesgo y discrepancias.',
        'Due Diligence: Procesa miles de documentos para auditorías y transacciones.',
        'Extracción de Datos: Obtiene información estructurada de documentos no estructurados.',
      ],
      demoImageAsset: 'assets/images/nlp.jpg', // <-- CHANGE: Updated image path
      supportedFormats: ['PDF', 'DOCX', 'TXT', 'HTML', 'JPG/PNG (OCR)'],
      callToAction: 'Solicitar Demostración',
    ),
    const AiSolution(
      icon: Icons.monitor_heart,
      title: 'ComplianceAI Monitor',
      description:
          'Sistema de monitoreo regulatorio en tiempo real que rastrea cambios en la legislación mexicana, alertando sobre modificaciones relevantes para su industria o caso específico.',
      features: [
        'Alertas Personalizadas: Notificaciones inmediatas sobre cambios regulatorios relevantes.',
        'Análisis de Impacto: Evaluación automática del impacto de nuevas normativas.',
        'Seguimiento Legislativo: Monitoreo de iniciativas desde su propuesta hasta su aprobación.',
      ],
      demoImageAsset: 'assets/images/demo_compliance_ai.png',
      supportedFormats: ['API REST', 'Webhooks', 'Email Digest', 'Slack/Teams'],
      callToAction: 'Ver Fuentes Monitoreadas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(),
          _SolutionsIntro(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: solutions.length,
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xxxl,
              horizontal: AppSpacing.pagePadding,
            ),
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.xxxl),
            itemBuilder: (context, index) {
              return _SolutionCard(solution: solutions[index])
                  .animate()
                  .fadeIn(delay: (200 * index).ms, duration: 500.ms)
                  .slideX(begin: 0.1, end: 0);
            },
          ),
        ],
      ),
    );
  }
}

// --- Screen Specific Widgets ---

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      child: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/hero_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay oscuro más pronunciado
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          // Contenido
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Derecho sin IA te convierte en obsoleto',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayLarge.copyWith(
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Nuestras soluciones de inteligencia artificial transforman la práctica legal en México, combinando la experiencia jurídica con tecnología de vanguardia para ofrecer resultados más rápidos, precisos y accesibles.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Wrap(
                      spacing: AppSpacing.lg,
                      runSpacing: AppSpacing.md,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentGold,
                            foregroundColor: AppColors.primaryNavy,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                              vertical: AppSpacing.lg,
                            ),
                          ),
                          child: const Text('Ver Demos Interactivos'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                              vertical: AppSpacing.lg,
                            ),
                          ),
                          child: const Text('Solicitar Prueba Gratuita'),
                        ),
                      ],
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

class _SolutionsIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Text(
                'Nuestras Soluciones Tecnológicas',
                textAlign: TextAlign.center,
                style: AppTypography.headingLarge.copyWith(
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Herramientas de IA desarrolladas por expertos en derecho administrativo y tecnologías digitales que diseñamos y personalizamos para tus necesidades específicas',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SolutionCard extends StatelessWidget {
  const _SolutionCard({required this.solution});

  final AiSolution solution;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ScreenTypeLayout.builder(
            mobile: (BuildContext context) => Column(
              children: [
                _LeftContent(solution: solution),
                _RightContent(solution: solution, isMobile: true),
              ],
            ),
            tablet: (BuildContext context) => Row(
              children: [
                Expanded(flex: 5, child: _LeftContent(solution: solution)),
                Expanded(
                  flex: 6,
                  child: _RightContent(solution: solution, isMobile: false),
                ),
              ],
            ),
            desktop: (BuildContext context) => Row(
              children: [
                Expanded(flex: 5, child: _LeftContent(solution: solution)),
                Expanded(
                  flex: 6,
                  child: _RightContent(solution: solution, isMobile: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeftContent extends StatelessWidget {
  const _LeftContent({required this.solution});

  final AiSolution solution;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(solution.icon, color: AppColors.techBlue, size: 36),
              const SizedBox(width: AppSpacing.md),
              Text(solution.title, style: AppTypography.headingMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(solution.description, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          ...solution.features.map((feature) => _FeatureBullet(text: feature)),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Soportado:',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: solution.supportedFormats
                .map(
                  (format) => Chip(
                    label: Text(format),
                    backgroundColor: AppColors.background,
                    labelStyle: AppTypography.bodySmall,
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.techBlue,
            ),
            child: Text(solution.callToAction),
          ),
        ],
      ),
    );
  }
}

class _RightContent extends StatelessWidget {
  const _RightContent({required this.solution, required this.isMobile});

  final bool isMobile;
  final AiSolution solution;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: isMobile
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(AppSpacing.radiusLarge),
                bottomRight: Radius.circular(AppSpacing.radiusLarge),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(AppSpacing.radiusLarge),
                bottomRight: Radius.circular(AppSpacing.radiusLarge),
              ),
      ),
      child: AspectRatio(
        aspectRatio: isMobile ? 1.2 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(color: AppColors.divider.withAlpha(128)),
            image: DecorationImage(
              image: AssetImage(solution.demoImageAsset),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  const _FeatureBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final parts = text.split(':');
    final title = parts[0];
    final description = parts.length > 1 ? parts.sublist(1).join(':') : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.techBlue, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: '$title:',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(text: ' $description'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
