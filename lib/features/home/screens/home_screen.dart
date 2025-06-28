import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:justicia_administrativa_web/core/routes/app_routes.dart';
import 'package:justicia_administrativa_web/services/email_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Wrapped the main Column in a SingleChildScrollView to make the
    // page scrollable and prevent the RenderFlex overflow error.
    return SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(),
          _ClientLogosSection(),
          _DualExpertiseSection(),
          _ServicesSection(),
          _FounderSection(),
          // _RecentAchievementsSection(), // Temporarily removed as requested
          _TestimonialsSection(),
          _CTASection(),
        ],
      ),
    );
  }
}

// --- ALL WIDGETS BELOW THIS LINE REMAIN UNCHANGED ---

// Hero Section
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
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
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              padding: AppSpacing.pagePaddingHorizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Transformando el Derecho\nAdministrativo Mexicano con\nInteligencia Artificial',
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Con un equipo multidisciplinario conformado por juristas referentes en Iberoamérica y por expertos en tecnologías digitales, ofrecemos soluciones jurídicas con tecnologías en cualquier parte del mundo.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                            vertical: AppSpacing.lg,
                          ),
                        ),
                        child: Text(
                          'Consulta Legal',
                          style: AppTypography.button.copyWith(
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                            vertical: AppSpacing.lg,
                          ),
                        ),
                        child: Text(
                          'Demo IA',
                          style: AppTypography.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Client Logos Section
class _ClientLogosSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          padding: AppSpacing.pagePaddingHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clientes que confían en nosotros',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_ClientLogo(name: 'Notaría Pública 42')],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientLogo extends StatelessWidget {
  final String name;

  const _ClientLogo({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        name,
        style: AppTypography.bodyLarge.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Dual Expertise Section
class _DualExpertiseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      color: AppColors.background,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          padding: AppSpacing.pagePaddingHorizontal,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusMedium,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.gavel, size: 48, color: AppColors.primaryNavy),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Excelencia Legal Tradicional',
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.primaryNavy,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Ofrecemos servicios jurídicos de primer nivel con abogados especializados en derecho administrativo mexicano, respaldados por décadas de experiencia y un historial comprobado de éxito.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _BulletPoint(
                            'Amplia experiencia en tribunales administrativos',
                          ),
                          _BulletPoint(
                            'Asesoría especializada en regulación mexicana',
                          ),
                          _BulletPoint(
                            'Representación legal ante autoridades federales',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusMedium,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 48,
                        color: AppColors.techBlue,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Innovación Tecnológica',
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.techBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Integramos tecnologías de inteligencia artificial y aprendizaje automático para revolucionar la práctica legal, ofreciendo soluciones más rápidas, precisas y eficientes.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _BulletPoint(
                            'Análisis automatizado de documentos legales',
                          ),
                          _BulletPoint(
                            'Modelos de IA entrenados en leyes mexicanas',
                          ),
                          _BulletPoint('Monitoreo regulatorio en tiempo real'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 16, color: AppColors.accentGold),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesSection extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {
      'icon': Icons.smart_toy_outlined,
      'title': 'Inteligencia Artificial',
      'features': [
        'Desarrollo de software jurídico personalizado.',
        'Entrenamiento de algoritmos especializados en derecho administrativo.',
        'Sistemas de análisis predictivo de casos y resoluciones judiciales.',
        'Automatización de documentos y escritos legales.',
        'Modelo de lenguaje para investigación y análisis legal.',
        'Análisis documental RAG para leer y analizar miles de expedientes, resoluciones y leyes en segundos.',
        'Sistema KAG, para relacionar las diferentes normas entre sí, identificando contradicciones y analogías con el fin de sugerir argumentos basados en la jerarquía normativa de detectar oportunidades procesales que podrían pasarse por alto.',
      ],
      'route': AppRoutes.aiSolutions,
    },
    {
      'icon': Icons.transform_outlined,
      'title': 'Transformación digital',
      'features': [
        'Convertir expedientes físicos en archivos digitales.',
        'Control y búsqueda inmediata de expedientes e información.',
        'Creación de un ecosistema donde cada aspecto administrativo y legal queda registrado, monitoreado y optimizado automáticamente.',
        'Gestión inteligente de la carga de trabajo mediante dashboards.',
        'Seguimiento automatizado de honorarios y facturación con reportes personalizados.',
        'Generación de reportes a clientes.',
        'Seguimiento por parte de los clientes a sus expedientes en tiempo real.',
      ],
      'route': AppRoutes.legalServices,
    },
    {
      'icon': Icons.gavel_outlined,
      'title': 'Consultoría jurídica',
      'features': [
        'Contratación pública.',
        'Responsabilidad patrimonial del Estado.',
        'Responsabilidades administrativas.',
        'Amparo en materia administrativa.',
        'Expropiaciones.',
        'Servicios públicos.',
        'Derecho ambiental.',
        'Derecho urbanístico.',
        'Derecho sanitario.',
        'Derecho tributario.',
        'Derecho energético.',
        'Seguridad social (pensiones).',
        'Políticas públicas.',
        'Asesoría a abogados en sus litigios ante el TFJA.',
        'Asesorías a abogados en sus amparos.',
        'Asesoría y seguimiento en procedimientos Administrativos.',
      ],
      'route': AppRoutes.legalServices,
    },
    {
      'icon': Icons.public_outlined,
      'title': 'Enlace jurídico',
      'features': [
        'Conexión clientes en Iberoamérica con especialistas de Iberoamérica.',
        'Optimización para la búsqueda de especialistas por país, materia y experiencia de acuerdo a las necesidades del cliente.',
        'Sistema de consultas jurídicas en línea.',
        'Red de referenciación entre especialistas iberoamericanos.',
        'Coordinación de litigios transfronterizos.',
        'Asesoría en arbitrajes administrativos internacionales.',
        'Representación ante organismos supranacionales',
      ],
      'route': AppRoutes.legalServices,
    },
    {
      'icon': Icons.account_balance_outlined,
      'title': 'Gestión pública',
      'features': [
        'Soluciones integrales de modernización administrativa.',
        'Digitalización de procesos gubernamentales.',
        'Creación de chatbots para la administración pública.',
        'Digitalización de expedientes y gestión electrónica.',
        'Automatización de procesos internos y externos con IA.',
        'Sistemas de análisis predictivo para identificar áreas de riesgo, optimizar la asignación de recursos y mejorar la toma de decisiones.',
        'Actualización de reglamentos para adaptarlos a la era digital.',
        'Capacitación a funcionarios sobre Derecho administrativo.',
        'Capacitación a funcionarios en el uso de tecnologías digitales.',
      ],
      'route': AppRoutes.legalServices,
    },
    {
      'icon': Icons.cases_outlined,
      'title': 'Órganos jurisdiccionales',
      'features': [
        'Desarrollo de plataformas de gestión de expedientes que utilicen inteligencia artificial para clasificar automáticamente demandas, identificar precedentes relevantes y sugerir criterios jurisprudenciales aplicables.',
        'Entrenamiento de algoritmos personalizados para las necesidades del órgano jurisdiccional.',
        'Sistemas de análisis de consistencia jurisprudencial y normativa.',
        'Desarrollo de portales especializados que automaticen la publicación de estadísticas judiciales, tiempos promedio de resolución por tipo de caso, y seguimiento en tiempo real del avance de expedientes.',
        'Capacitación a funcionarios en el uso de tecnologías digitales.',
      ],
      'route': AppRoutes.legalServices,
    },
    {
      'icon': Icons.school_outlined,
      'title': 'Capacitación',
      'features': ['Derecho administrativo.', 'Derecho digital.', 'Software.'],
      'route': AppRoutes.legalServices,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          padding: AppSpacing.pagePaddingHorizontal,
          child: Column(
            children: [
              Text(
                'Nuestros Servicios',
                style: AppTypography.headingLarge.copyWith(
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSpacing.lg,
                  mainAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 0.8,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _ServiceCard(
                    icon: service['icon'] as IconData,
                    title: service['title'] as String,
                    features: service['features'] as List<String>,
                    route: service['route'] as String,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> features;
  final String route;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.features,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: AppColors.primaryNavy),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: features
                  .map((feature) => _FeatureListItem(text: feature))
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go(route),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Conocer más'),
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureListItem extends StatelessWidget {
  final String text;
  const _FeatureListItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Icon(Icons.check, size: 14, color: AppColors.accentGold),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: AppTypography.bodySmall)),
        ],
      ),
    );
  }
}

class _FounderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      color: AppColors.background,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          padding: AppSpacing.pagePaddingHorizontal,
          child: Row(
            children: [
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  image: DecorationImage(
                    image: AssetImage('assets/images/alfredo.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xxxl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lic. Alfredo Delgadillo López',
                      style: AppTypography.headingLarge.copyWith(
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Fundador y Director General',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: 80,
                      height: 4,
                      color: AppColors.accentGold,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.only(left: AppSpacing.lg),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: AppColors.accentGold,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Text(
                        'Las posibles vulneraciones a derechos fundamentales por el uso de tecnologías quedan limitadas cuando se implementan como marco los principios generales del derecho administrativo; y los problemas del derecho administrativo, son mitigados cuando se utilizan tecnologías. Se complementan. Pero estas deben de ser diseñadas sin las deficiencias que esta disciplina ha desarrollado desde su nacimiento.\n\nPor lo tanto, la clave para implementar las tecnologías digitales más avanzadas de manera continua sin sacrificar el interés general ni vulnerar derechos fundamentales es advertir los problemas que genera el lenguaje con que está construido el derecho administrativo. En este sentido, es posible filtrarlos y corregirlos antes de programar y entrenar algoritmos; es decir, no trasladar las limitaciones y deficiencias del derecho administrativo al mundo digital.',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          padding: AppSpacing.pagePaddingHorizontal,
          child: Column(
            children: [
              Text(
                'Lo que dicen nuestros clientes',
                style: AppTypography.headingLarge.copyWith(
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                children: [
                  Expanded(
                    child: _TestimonialCard(
                      name: 'Notario Público',
                      position: 'Notaría Pública 42',
                      testimonial:
                          '"La implementación de las soluciones tecnológicas de Justicia Administrativa ha modernizado significativamente nuestros procesos. La eficiencia y precisión en el manejo de documentación legal ha mejorado notablemente."',
                      rating: 5,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMedium,
                        ),
                        border: Border.all(
                          color: AppColors.divider,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.format_quote,
                            size: 48,
                            color: AppColors.accentGold,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Próximamente más testimonios',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Estamos trabajando con nuevos clientes para transformar sus procesos legales',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMedium,
                        ),
                        border: Border.all(
                          color: AppColors.divider,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.star_outline,
                            size: 48,
                            color: AppColors.accentGold,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            '¿Necesita asesoría legal?',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Contáctenos para conocer cómo podemos ayudarle con sus necesidades legales y tecnológicas',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String position;
  final String testimonial;
  final int rating;

  const _TestimonialCard({
    required this.name,
    required this.position,
    required this.testimonial,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.primaryNavy,
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    Text(
                      position,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            testimonial,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 18,
                color: index < rating
                    ? AppColors.accentGold
                    : AppColors.divider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CTASection extends StatefulWidget {
  @override
  State<_CTASection> createState() => _CTASectionState();
}

class _CTASectionState extends State<_CTASection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final success = await EmailService.sendContactForm(
        name: _nameController.text,
        email: _emailController.text,
        company: _companyController.text,
        message: _messageController.text,
      );

      setState(() => _isLoading = false);

      if (success) {
        // Limpiar campos
        _nameController.clear();
        _emailController.clear();
        _companyController.clear();
        _messageController.clear();

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitud enviada correctamente'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar la solicitud'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      color: AppColors.background,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          padding: AppSpacing.pagePaddingHorizontal,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Necesita asesoría legal o soluciones tecnológicas?',
                        style: AppTypography.headingMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Complete el formulario y un especialista se pondrá en contacto con usted inmediatamente para analizar su caso y ofrecerle las mejores soluciones.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: AppColors.accentGold,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Asesoría personalizada por expertos en derecho administrativo',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: AppColors.accentGold,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Soluciones tecnológicas adaptadas a sus necesidades específicas',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: AppColors.accentGold,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Primera consulta sin costo para evaluar su caso',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: AppColors.accentGold,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '+52 1 311 125 0906',
                            style: AppTypography.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xxxl),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMedium,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Solicite información',
                            style: AppTypography.headingSmall.copyWith(
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre completo',
                              hintText: 'Ingrese su nombre',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              hintText: 'correo@ejemplo.com',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo';
                              }
                              if (!value.contains('@')) {
                                return 'Por favor ingrese un correo válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _companyController,
                            decoration: InputDecoration(
                              labelText: 'Empresa (opcional)',
                              hintText: 'Nombre de su empresa',
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              labelText: 'Mensaje',
                              hintText: 'Describa brevemente su consulta',
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor escriba su mensaje';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentGold,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.primaryNavy,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Enviar solicitud',
                                      style: AppTypography.button.copyWith(
                                        color: AppColors.primaryNavy,
                                      ),
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
          ),
        ),
      ),
    );
  }
}
