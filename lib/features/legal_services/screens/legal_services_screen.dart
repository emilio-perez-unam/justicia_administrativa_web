import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Simplified data model with icons
class ServiceCategory {
  final String title;
  final List<String> details;
  final IconData icon;
  final Color color;

  const ServiceCategory({
    required this.title,
    required this.details,
    required this.icon,
    required this.color,
  });
}

class LegalServicesScreen extends HookWidget {
  const LegalServicesScreen({super.key});

  // Service categories with icons and colors
  static final List<ServiceCategory> _services = [
    ServiceCategory(
      title: 'Derecho Digital',
      icon: Icons.computer,
      color: AppColors.techBlue,
      details: [
        'Asesoría en protección de datos personales',
        'Asesoría en derecho a no ser indexado',
        'Acompañamiento en procesos de desindexación ante Google y Meta',
        'Opiniones en peritajes informáticos',
        'Traductores entre abogados e ingenieros',
      ],
    ),
    ServiceCategory(
      title: 'Contratación pública',
      icon: Icons.description,
      color: AppColors.primaryNavy,
      details: [
        'Análisis de viabilidad para participar en licitaciones públicas',
        'Revisión y elaboración de propuestas técnicas y económicas',
        'Asesoría en interpretación de bases de licitación',
        'Evaluación de riesgos contractuales en proyectos gubernamentales',
        'Diseño de estrategias de consorcio y asociación para licitaciones',
        'Auditoría de cumplimiento en contratos públicos vigentes',
        'Asesoría en modificaciones y prórrogas contractuales',
        'Análisis de causales de rescisión y terminación anticipada',
      ],
    ),
    ServiceCategory(
      title: 'Responsabilidad patrimonial del Estado',
      icon: Icons.account_balance,
      color: Color(0xFF7C3AED), // Purple
      details: [
        'Evaluación de viabilidad de reclamaciones patrimoniales contra el Estado',
        'Análisis y cuantificación de daños por actividad administrativa',
        'Estrategias para determinar el nexo causal entre acto administrativo y daño',
        'Asesoría en procedimientos de reclamación administrativa previa',
        'Asesoría preventiva para entidades públicas sobre riesgos de responsabilidad',
        'Diseño de protocolos internos para minimizar responsabilidades estatales',
      ],
    ),
    ServiceCategory(
      title: 'Responsabilidades administrativas',
      icon: Icons.security,
      color: Color(0xFFDC2626), // Red
      details: [
        'Diseño e implementación de programas de compliance para servidores públicos',
        'Asesoría en sistemas de control interno institucional',
        'Elaboración de códigos de ética y conducta para entidades públicas',
        'Capacitación especializada en normativa anticorrupción',
        'Evaluación de riesgos de responsabilidades administrativas',
        'Asesoría en procedimientos de declaración de situación patrimonial',
        'Diseño de políticas de transparencia y rendición de cuentas',
      ],
    ),
    ServiceCategory(
      title: 'Amparo en materia administrativa',
      icon: Icons.gavel,
      color: AppColors.accentGold,
      details: [
        'Evaluación de conceptos de violación en materia administrativa',
        'Asesoría en estrategias de suspensión del acto reclamado',
        'Asesoría en cumplimiento de ejecutorias de amparo',
        'Análisis de efectos de sentencias de amparo',
        'Evaluación de procedencia de amparo contra leyes',
      ],
    ),
    ServiceCategory(
      title: 'Expropiaciones',
      icon: Icons.landscape,
      color: Color(0xFF059669), // Green
      details: [
        'Análisis de causa de utilidad pública en proyectos expropiatorios',
        'Evaluación y elaboración de avalúos especializados',
        'Asesoría en procedimientos de expropiación',
        'Análisis de viabilidad de reversión expropiatoria',
        'Cálculos conforme a derecho de indemnizaciones',
        'Evaluación de afectaciones parciales en expropiaciones',
      ],
    ),
    ServiceCategory(
      title: 'Servicios públicos',
      icon: Icons.apartment,
      color: Color(0xFF0891B2), // Cyan
      details: [
        'Diseño y estructuración de marcos regulatorios para servicios públicos',
        'Asesoría en concesiones',
        'Análisis de viabilidad económica de proyectos de servicios públicos',
        'Evaluación de tarifas y modelos de financiamiento',
        'Asesoría en transferencia de servicios públicos a particulares',
        'Diseño de indicadores de calidad y cumplimiento',
        'Análisis de riesgos regulatorios en concesiones',
        'Asesoría en resolución de controversias entre concesionarios y usuarios',
      ],
    ),
    ServiceCategory(
      title: 'Políticas públicas',
      icon: Icons.policy,
      color: Color(0xFF8B5CF6), // Violet
      details: [
        'Diseño de políticas públicas',
        'Análisis de marcos normativos en el diseño y ejecución de políticas públicas',
        'Asesoría en coordinación intergubernamental',
        'Diseño de indicadores de evaluación y seguimiento',
        'Análisis de viabilidad presupuestal de políticas públicas',
        'Asesoría en consulta pública y participación ciudadana',
      ],
    ),
    ServiceCategory(
      title: 'Seguridad social',
      icon: Icons.health_and_safety,
      color: Color(0xFFEA580C), // Orange
      details: [
        'Asesoría en transición de sistemas pensionarios',
        'Evaluación de derechos adquiridos en seguridad social',
        'Análisis de viabilidad de reclamaciones pensionarias',
        'Evaluación de incapacidades y pensiones por invalidez',
        'Asesoría en cálculo de semanas cotizadas y salarios base',
        'Diseño de estrategias de ahorro complementario',
      ],
    ),
    ServiceCategory(
      title: 'Derecho Ambiental',
      icon: Icons.eco,
      color: Color(0xFF16A34A), // Green
      details: [
        'Tramitación y seguimiento de licencias ambientales',
        'Diseño de programas de compliance ambiental empresarial',
        'Asesoría en evaluaciones de impacto ambiental',
        'Diseño de programas de manejo de residuos',
        'Evaluación de riesgos ambientales',
      ],
    ),
    ServiceCategory(
      title: 'Derecho Urbanístico',
      icon: Icons.location_city,
      color: Color(0xFF0EA5E9), // Sky
      details: [
        'Asesoría en desarrollos residenciales, industriales, turísticos o de infraestructura.',
        'Tramitación de licencias de construcción y uso de suelo',
        'Asesoría en densificación y aprovechamiento urbano',
        'Gestión de cambios de uso de suelo',
        'Asesoría en regularización de construcciones',
        'Análisis de planes de desarrollo urbano municipal y normativa',
        'Realizar dictámenes legales sobre la viabilidad jurídica de desarrollos',
        'Identificar riesgos de conflictos con planes de desarrollo urbano o restricciones ecológicas.',
        'Protección del patrimonio cultural en contextos de planeación urbana',
      ],
    ),
    ServiceCategory(
      title: 'Derecho Sanitario',
      icon: Icons.local_hospital,
      color: Color(0xFFE11D48), // Rose
      details: [
        'Prevención, gestión, defensa y diseño normativo dentro del campo sanitario.',
        'Asesoría normativa y regulatoria en salud pública',
        'Asesoría en Tramites y autorizaciones de funcionamiento, registros sanitarios, licencias de operación, permisos de publicidad médica',
        'Asesoría en procedimientos por negligencia médica en hospitales públicos.',
        'Asesoría para defender el acceso a medicamentos, servicios de salud o atención oportuna, especialmente para poblaciones vulnerables.',
      ],
    ),
    ServiceCategory(
      title: 'Derecho Tributario',
      icon: Icons.receipt_long,
      color: Color(0xFF6366F1), // Indigo
      details: [
        'Asesoría en procedimientos fiscales',
        'Planeación fiscal para entidades gubernamentales',
        'Asesoría en cumplimiento de obligaciones fiscales',
        'Evaluación de riesgos tributarios en operaciones gubernamentales',
        'Asesoría en fiscalización de contribuyentes',
        'Prevención, gestión, defensa y diseño normativo interno dentro del campo fiscal.',
      ],
    ),
    ServiceCategory(
      title: 'Derecho Energético',
      icon: Icons.bolt,
      color: Color(0xFFF59E0B), // Amber
      details: [
        'Tramitación de permisos energéticos',
        'Asesoría en contratos de suministro y distribución energética',
        'Evaluación de compliance en sectores de hidrocarburos y electricidad',
        'Estructuración legal de proyectos de energías renovables',
        'Análisis de regulación energética',
        'Evaluación de riesgos regulatorios en inversiones energéticas',
        'Consultoría en políticas públicas, litigio estratégico y transición energética',
      ],
    ),
    ServiceCategory(
      title: 'Asesorías a Abogados en Litigios ante el TFJA y PJF',
      icon: Icons.support_agent,
      color: Color(0xFF9333EA), // Purple
      details: [
        'Análisis especializado de jurisprudencia del TFJA',
        'Revisión técnica de demandas y escritos procesales',
        'Estrategias procesales específicas para el tribunal',
        'Segunda opinión en casos complejos de derecho administrativo',
        'Análisis de viabilidad de recursos',
        'Capacitación en procedimientos especializados del TFJA',
        'Análisis de procedencia constitucional de amparos administrativos',
        'Revisión especializada de conceptos de violación',
        'Estrategias de suspensión en materia administrativa',
        'Asesoría en cumplimiento de ejecutorias',
        'Capacitación en amparo administrativo especializado',
      ],
    ),
    ServiceCategory(
      title: 'Asesoría y seguimientos en procedimientos administrativos',
      icon: Icons.assignment,
      color: Color(0xFF14B8A6), // Teal
      details: [
        'Representación en audiencias administrativas',
        'Seguimiento especializado de expedientes gubernamentales',
        'Estrategias para interposición de recursos administrativos',
        'Asesoría en cumplimiento de requerimientos administrativos',
        'Gestión de trámites administrativos complejos',
        'Análisis de plazos y términos procesales',
        'Coordinación con múltiples dependencias gubernamentales',
        'Evaluación de estrategias de defensa administrativa',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final selectedCategory = _services[selectedIndex.value];

    return SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(),
          ScreenTypeLayout.builder(
            mobile: (context) => _MobileLayout(
              services: _services,
              selectedIndex: selectedIndex.value,
              onCategorySelected: (index) => selectedIndex.value = index,
              selectedCategory: selectedCategory,
            ),
            desktop: (context) => _DesktopLayout(
              services: _services,
              selectedIndex: selectedIndex.value,
              onCategorySelected: (index) => selectedIndex.value = index,
              selectedCategory: selectedCategory,
            ),
          ),
        ],
      ),
    );
  }
}

// Hero Section with gradient and animation
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryNavy,
            AppColors.primaryNavy.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern - Removed since asset doesn't exist
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
              ),
            ),
          ),
          // Content
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
                  children: [
                    Icon(Icons.balance, size: 80, color: AppColors.accentGold)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                          'Servicios Jurídicos Especializados',
                          style: AppTypography.displayLarge.copyWith(
                            color: Colors.white,
                            fontSize: 56,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: Text(
                            'Más de 16 áreas de especialización en derecho administrativo con un equipo experto para cada necesidad',
                            style: AppTypography.bodyLarge.copyWith(
                              color: Colors.white70,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
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
}

// Desktop Layout - Fixed height constraints
class _DesktopLayout extends StatelessWidget {
  final List<ServiceCategory> services;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final ServiceCategory selectedCategory;

  const _DesktopLayout({
    required this.services,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8, // Fixed height
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar
                Container(
                  width: 350,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          'Áreas de Práctica',
                          style: AppTypography.headingMedium,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            final isSelected = index == selectedIndex;

                            return _ServiceListTile(
                              service: service,
                              isSelected: isSelected,
                              onTap: () => onCategorySelected(index),
                            ).animate().fadeIn(
                              delay: (50 * index).ms,
                              duration: 400.ms,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Detail View
                Expanded(
                  child: SingleChildScrollView(
                    child: _ServiceDetailView(
                      category: selectedCategory,
                    ).animate().fadeIn().slideX(begin: 0.1, end: 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Mobile Layout - Fixed to work without constraints issues
class _MobileLayout extends StatelessWidget {
  final List<ServiceCategory> services;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final ServiceCategory selectedCategory;

  const _MobileLayout({
    required this.services,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        children: [
          // Category Grid
          Text(
            'Seleccione un área de práctica',
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.5,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              final isSelected = index == selectedIndex;

              return _ServiceGridCard(
                    service: service,
                    isSelected: isSelected,
                    onTap: () => onCategorySelected(index),
                  )
                  .animate()
                  .fadeIn(delay: (50 * index).ms, duration: 400.ms)
                  .scale(begin: const Offset(0.9, 0.9));
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          // Detail View
          _ServiceDetailView(
            category: selectedCategory,
          ).animate().fadeIn().slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

// Service List Tile for desktop sidebar
class _ServiceListTile extends StatelessWidget {
  final ServiceCategory service;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceListTile({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Material(
        color: isSelected ? service.color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isSelected ? service.color : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: service.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Icon(service.icon, color: service.color, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    service.title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected ? service.color : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Service Grid Card for mobile
class _ServiceGridCard extends StatelessWidget {
  final ServiceCategory service;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceGridCard({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: isSelected ? 8 : 2,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      color: isSelected ? service.color : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                service.icon,
                size: 32,
                color: isSelected ? Colors.white : service.color,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                service.title,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Service Detail View - Fixed without Expanded issues
class _ServiceDetailView extends StatelessWidget {
  final ServiceCategory category;

  const _ServiceDetailView({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [category.color, category.color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Icon(category.icon, size: 32, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: AppTypography.headingLarge.copyWith(
                        color: category.color,
                      ),
                    ),
                    Text(
                      '${category.details.length} servicios especializados',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [category.color, category.color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Services List - Now properly constrained
          ...category.details.asMap().entries.map((entry) {
            final index = entry.key;
            final detail = entry.value;

            return _ServiceItem(text: detail, color: category.color)
                .animate()
                .fadeIn(delay: (50 * index).ms, duration: 400.ms)
                .slideX(begin: 0.1, end: 0);
          }).toList(),
          const SizedBox(height: AppSpacing.xxxl),
          // CTA Button
          Center(
            child:
                ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.contact_mail),
                      label: const Text('Solicitar Asesoría sobre este tema'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: category.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.lg,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMedium,
                          ),
                        ),
                        elevation: 4,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
          ),
        ],
      ),
    );
  }
}

// Service Item
class _ServiceItem extends StatelessWidget {
  final String text;
  final Color color;

  const _ServiceItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border(
          left: BorderSide(color: color.withOpacity(0.3), width: 3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Icon(Icons.check_circle, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: AppTypography.bodyMedium)),
        ],
      ),
    );
  }
}
