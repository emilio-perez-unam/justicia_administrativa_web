import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_theme_extension.dart';
import '../router.dart';
import 'section_container.dart';

part 'services/services_ai_solutions.dart';
part 'services/services_hero_overview.dart';
part 'services/services_practice_areas.dart';

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class _PracticeArea {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> services;

  const _PracticeArea({
    required this.title,
    required this.icon,
    required this.color,
    required this.services,
  });
}

class _AiFeature {
  final String name;
  final String description;
  const _AiFeature(this.name, this.description);
}

class _AiSolution {
  final String title;
  final IconData icon;
  final String description;
  final List<_AiFeature> features;
  final List<String>? formats;

  const _AiSolution({
    required this.title,
    required this.icon,
    required this.description,
    required this.features,
    this.formats,
  });
}

// ---------------------------------------------------------------------------
// Practice areas data
// ---------------------------------------------------------------------------

const _practiceAreas = <_PracticeArea>[
  _PracticeArea(
    title: 'Derecho Digital',
    icon: LucideIcons.cpu,
    color: Color(0xFF0052CC),
    services: [
      'Asesoría en protección de datos personales',
      'Asesoría en derecho a no ser indexado',
      'Acompañamiento en procesos de desindexación ante Google y Meta',
      'Opiniones en peritajes informáticos',
      'Traductores entre abogados e ingenieros',
    ],
  ),
  _PracticeArea(
    title: 'Contratación Pública',
    icon: LucideIcons.fileText,
    color: Color(0xFF1A2942),
    services: [
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
  _PracticeArea(
    title: 'Responsabilidad Patrimonial del Estado',
    icon: LucideIcons.landmark,
    color: Color(0xFF7C3AED),
    services: [
      'Evaluación de viabilidad de reclamaciones patrimoniales contra el Estado',
      'Análisis y cuantificación de daños por actividad administrativa',
      'Estrategias para determinar el nexo causal entre acto administrativo y daño',
      'Asesoría en procedimientos de reclamación administrativa previa',
      'Asesoría preventiva para entidades públicas sobre riesgos de responsabilidad',
      'Diseño de protocolos internos para minimizar responsabilidades estatales',
    ],
  ),
  _PracticeArea(
    title: 'Responsabilidades Administrativas',
    icon: LucideIcons.shield,
    color: Color(0xFFDC2626),
    services: [
      'Diseño e implementación de programas de compliance para servidores públicos',
      'Asesoría en sistemas de control interno institucional',
      'Elaboración de códigos de ética y conducta para entidades públicas',
      'Capacitación especializada en normativa anticorrupción',
      'Evaluación de riesgos de responsabilidades administrativas',
      'Asesoría en procedimientos de declaración de situación patrimonial',
      'Diseño de políticas de transparencia y rendición de cuentas',
    ],
  ),
  _PracticeArea(
    title: 'Amparo en Materia Administrativa',
    icon: LucideIcons.gavel,
    color: Color(0xFFD4AF37),
    services: [
      'Evaluación de conceptos de violación en materia administrativa',
      'Asesoría en estrategias de suspensión del acto reclamado',
      'Asesoría en cumplimiento de ejecutorias de amparo',
      'Análisis de efectos de sentencias de amparo',
      'Evaluación de procedencia de amparo contra leyes',
    ],
  ),
  _PracticeArea(
    title: 'Expropiaciones',
    icon: LucideIcons.mapPin,
    color: Color(0xFF059669),
    services: [
      'Análisis de causa de utilidad pública en proyectos expropiatorios',
      'Evaluación y elaboración de avalúos especializados',
      'Asesoría en procedimientos de expropiación',
      'Análisis de viabilidad de reversión expropiatoria',
      'Cálculos conforme a derecho de indemnizaciones',
      'Evaluación de afectaciones parciales en expropiaciones',
    ],
  ),
  _PracticeArea(
    title: 'Servicios Públicos',
    icon: LucideIcons.building2,
    color: Color(0xFF0891B2),
    services: [
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
  _PracticeArea(
    title: 'Políticas Públicas',
    icon: LucideIcons.briefcase,
    color: Color(0xFF8B5CF6),
    services: [
      'Diseño de políticas públicas',
      'Análisis de marcos normativos en el diseño y ejecución de políticas públicas',
      'Asesoría en coordinación intergubernamental',
      'Diseño de indicadores de evaluación y seguimiento',
      'Análisis de viabilidad presupuestal de políticas públicas',
      'Asesoría en consulta pública y participación ciudadana',
    ],
  ),
  _PracticeArea(
    title: 'Seguridad Social',
    icon: LucideIcons.users,
    color: Color(0xFFEA580C),
    services: [
      'Asesoría en transición de sistemas pensionarios',
      'Evaluación de derechos adquiridos en seguridad social',
      'Análisis de viabilidad de reclamaciones pensionarias',
      'Evaluación de incapacidades y pensiones por invalidez',
      'Asesoría en cálculo de semanas cotizadas y salarios base',
      'Diseño de estrategias de ahorro complementario',
    ],
  ),
  _PracticeArea(
    title: 'Derecho Ambiental',
    icon: LucideIcons.globe,
    color: Color(0xFF16A34A),
    services: [
      'Tramitación y seguimiento de licencias ambientales',
      'Diseño de programas de compliance ambiental empresarial',
      'Asesoría en evaluaciones de impacto ambiental',
      'Diseño de programas de manejo de residuos',
      'Evaluación de riesgos ambientales',
    ],
  ),
  _PracticeArea(
    title: 'Derecho Urbanístico',
    icon: LucideIcons.building,
    color: Color(0xFF0EA5E9),
    services: [
      'Asesoría en desarrollos residenciales, industriales, turísticos o de infraestructura',
      'Tramitación de licencias de construcción y uso de suelo',
      'Asesoría en densificación y aprovechamiento urbano',
      'Gestión de cambios de uso de suelo',
      'Asesoría en regularización de construcciones',
      'Análisis de planes de desarrollo urbano municipal y normativa',
      'Dictámenes legales sobre viabilidad jurídica de desarrollos',
      'Identificación de riesgos con planes de desarrollo o restricciones ecológicas',
      'Protección del patrimonio cultural en contextos de planeación urbana',
    ],
  ),
  _PracticeArea(
    title: 'Derecho Sanitario',
    icon: LucideIcons.heart,
    color: Color(0xFFE11D48),
    services: [
      'Prevención, gestión, defensa y diseño normativo dentro del campo sanitario',
      'Asesoría normativa y regulatoria en salud pública',
      'Trámites y autorizaciones de funcionamiento, registros sanitarios y licencias',
      'Asesoría en procedimientos por negligencia médica en hospitales públicos',
      'Defensa del acceso a medicamentos y servicios de salud para poblaciones vulnerables',
    ],
  ),
  _PracticeArea(
    title: 'Derecho Tributario',
    icon: LucideIcons.creditCard,
    color: Color(0xFF6366F1),
    services: [
      'Asesoría en procedimientos fiscales',
      'Planeación fiscal para entidades gubernamentales',
      'Asesoría en cumplimiento de obligaciones fiscales',
      'Evaluación de riesgos tributarios en operaciones gubernamentales',
      'Asesoría en fiscalización de contribuyentes',
      'Prevención, gestión, defensa y diseño normativo interno dentro del campo fiscal',
    ],
  ),
  _PracticeArea(
    title: 'Derecho Energético',
    icon: LucideIcons.zap,
    color: Color(0xFFF59E0B),
    services: [
      'Tramitación de permisos energéticos',
      'Asesoría en contratos de suministro y distribución energética',
      'Evaluación de compliance en sectores de hidrocarburos y electricidad',
      'Estructuración legal de proyectos de energías renovables',
      'Análisis de regulación energética',
      'Evaluación de riesgos regulatorios en inversiones energéticas',
      'Consultoría en políticas públicas, litigio estratégico y transición energética',
    ],
  ),
  _PracticeArea(
    title: 'Asesorías a Abogados en Litigios ante el TFJA y PJF',
    icon: LucideIcons.scale,
    color: Color(0xFF9333EA),
    services: [
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
  _PracticeArea(
    title: 'Asesoría y Seguimiento en Procedimientos Administrativos',
    icon: LucideIcons.fileCheck,
    color: Color(0xFF14B8A6),
    services: [
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

// ---------------------------------------------------------------------------
// AI solutions data
// ---------------------------------------------------------------------------

const _aiSolutions = <_AiSolution>[
  _AiSolution(
    title: 'JusticIGPT',
    icon: LucideIcons.bot,
    description:
        'Modelo de lenguaje especializado entrenado con la legislación mexicana, '
        'jurisprudencia y doctrina legal. Proporciona respuestas precisas a '
        'consultas jurídicas complejas en segundos.',
    features: [
      _AiFeature(
        'Investigación Jurídica',
        'Encuentra precedentes y normativa relevante en segundos.',
      ),
      _AiFeature(
        'Redacción de Documentos',
        'Genera borradores de escritos legales con fundamentos jurídicos.',
      ),
      _AiFeature(
        'Análisis Predictivo',
        'Evalúa probabilidades de éxito basado en casos similares.',
      ),
    ],
  ),
  _AiSolution(
    title: 'LexisRAG System',
    icon: LucideIcons.search,
    description:
        'Sistema de Recuperación Aumentada por Generación (RAG) que analiza, '
        'clasifica y extrae información clave de grandes volúmenes de documentos '
        'legales en minutos.',
    features: [
      _AiFeature(
        'Análisis de Contratos',
        'Identifica cláusulas de riesgo y discrepancias.',
      ),
      _AiFeature(
        'Due Diligence',
        'Procesa miles de documentos para auditorías y transacciones.',
      ),
      _AiFeature(
        'Extracción de Datos',
        'Obtiene información estructurada de documentos no estructurados.',
      ),
    ],
    formats: ['PDF', 'DOCX', 'TXT', 'HTML', 'JPG/PNG (OCR)'],
  ),
  _AiSolution(
    title: 'ComplianceAI Monitor',
    icon: LucideIcons.eye,
    description:
        'Sistema de monitoreo regulatorio en tiempo real que rastrea cambios en '
        'la legislación mexicana, alertando sobre modificaciones relevantes para '
        'su industria o caso específico.',
    features: [
      _AiFeature(
        'Alertas Personalizadas',
        'Notificaciones inmediatas sobre cambios regulatorios relevantes.',
      ),
      _AiFeature(
        'Análisis de Impacto',
        'Evaluación automática del impacto de nuevas normativas.',
      ),
      _AiFeature(
        'Seguimiento Legislativo',
        'Monitoreo de iniciativas desde su propuesta hasta su aprobación.',
      ),
    ],
    formats: ['API REST', 'Webhooks', 'Email Digest', 'Slack/Teams'],
  ),
];

// ---------------------------------------------------------------------------
// Main section widget
// ---------------------------------------------------------------------------

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ServicesHero(),
        SectionContainer(
          padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
          child: const Column(
            children: [
              _ServicesOverview(),
              SizedBox(height: 96),
              _PracticeAreasSection(),
              SizedBox(height: 96),
              _AiSolutionsSection(),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Hero header
// ---------------------------------------------------------------------------
