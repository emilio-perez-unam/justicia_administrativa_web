import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme_extension.dart';
import 'section_container.dart';

part 'team/team_widgets.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

enum MemberType { lawyer, engineer }

class TeamMember {
  final String name;
  final String title;
  final String? imageAsset;
  final String location;
  final MemberType type;
  final List<String> specialties;
  final List<String> details;
  final String? linkedinUrl;

  const TeamMember({
    required this.name,
    required this.title,
    this.imageAsset,
    required this.location,
    required this.type,
    required this.specialties,
    required this.details,
    this.linkedinUrl,
  });
}

// ---------------------------------------------------------------------------
// Team members data
// ---------------------------------------------------------------------------

const _members = <TeamMember>[
  // ── Lawyers ──────────────────────────────────────────────────────────────
  TeamMember(
    name: 'Lic. Alfredo Delgadillo López',
    title: 'Fundador y Director General',
    imageAsset: 'assets/images/alfredo-delgadillo-lopez.jpg',
    location: 'Ciudad de México',
    type: MemberType.lawyer,
    specialties: [
      'Derecho Administrativo',
      'Derecho Digital',
      'Litigio Público',
      'Expropiaciones',
    ],
    details: [
      'Fundador de justicIAdministrativa',
      'Abogado Digital certificado por la Academia Mexicana de Derecho Informático',
      'Coordinador del Seminario Derecho Administrativo 4RI — IIJUNAM',
    ],
    linkedinUrl: 'https://www.linkedin.com/in/alfredodelgadillomx/',
  ),
  TeamMember(
    name: 'Dr. Luís Humberto Delgadillo Gutiérrez',
    title: 'Asesor y Consultor Jurídico Senior',
    imageAsset: 'assets/images/luis-delgadillo-gutierrez.jpg',
    location: 'Ciudad de México',
    type: MemberType.lawyer,
    specialties: [
      'Derecho Tributario',
      'Contratación pública',
      'Responsabilidades administrativas',
      'Derecho Fiscal',
    ],
    details: [
      'Doctor en Derecho por la UNAM',
      'Ex Magistrado del Tribunal Federal de JusticI Fiscal y Administrativa',
      'Más de 50 años en la Administración Pública Federal',
    ],
  ),
  TeamMember(
    name: 'Dr. Jaime Rodríguez-Arana Muñoz',
    title: 'Consejero Académico Internacional',
    imageAsset: 'assets/images/jaime-rodriguez-arana.jpg',
    location: 'A Coruña, España',
    type: MemberType.lawyer,
    specialties: [
      'Políticas públicas',
      'Servicios públicos',
      'Responsabilidad patrimonial del Estado',
      'Buena Administración',
    ],
    details: [
      'Catedrático de Derecho Administrativo — Universidad da Coruña',
      'Presidente del Foro Iberoamericano de Derecho Administrativo',
      'Miembro de la Real Academia Española de Jurisprudencia y Legislación',
    ],
    linkedinUrl:
        'https://www.linkedin.com/in/jaime-rodr%C3%ADguez-arana-2941771b/',
  ),
  TeamMember(
    name: 'Dra. Míriam Mabel Ivanega',
    title: 'Consejera Académica Internacional',
    imageAsset: 'assets/images/miriam-ivanega.jpg',
    location: 'Buenos Aires, Argentina',
    type: MemberType.lawyer,
    specialties: [
      'Contratación pública',
      'Responsabilidades administrativas',
      'Servicios públicos',
      'Derecho y Ciencias Sociales',
    ],
    details: [
      'Doctora en Derecho y Ciencias Sociales — Universidad Austral',
      'Directora de la Maestría en Derecho Administrativo — U. Austral',
      'Miembro fundador del Foro Iberoamericano de Derecho Administrativo',
    ],
    linkedinUrl: 'https://www.linkedin.com/in/miriam-mabel-ivanega-182a1310/',
  ),
  TeamMember(
    name: 'Dr. Luís José Béjar Rivera',
    title: 'Profesor e Investigador · Consejero Internacional',
    imageAsset: 'assets/images/luis-bejar-rivera.jpg',
    location: 'Sherbrooke, Quebec, Canadá',
    type: MemberType.lawyer,
    specialties: [
      'Políticas públicas',
      'Responsabilidad patrimonial del Estado',
      'Servicios públicos',
      'Derecho y Política',
    ],
    details: [
      'Profesor en Bishop\'s University, Canadá',
      'Doctor en Derecho por la Universidad Panamericana',
      'Autor y coautor de más de 20 libros',
    ],
    linkedinUrl:
        'https://www.linkedin.com/in/luis-jos%C3%A9-b%C3%A9jar-rivera-5941186b/',
  ),
  TeamMember(
    name: 'Lic. Raúl Rosales Rosas',
    title: 'Consultor Senior en Derecho Público',
    imageAsset: 'assets/images/raul-rosales-rosas.jpg',
    location: 'Nayarit, México',
    type: MemberType.lawyer,
    specialties: [
      'Responsabilidades administrativas',
      'Contratación pública',
      'Derecho urbanístico',
      'Finanzas Públicas',
    ],
    details: [
      'Ex Director Jurídico del Órgano de Fiscalización Superior de Nayarit',
      'Maestro en Derecho Público — Universidad Panamericana',
      'Fundador de la Comisión Municipal de Derechos Humanos de Tepic',
    ],
  ),

  // ── Engineers ────────────────────────────────────────────────────────────
  TeamMember(
    name: 'Dr. Jose Alberto de la Paz',
    title: 'Research Associate',
    imageAsset: 'assets/images/alberto_de_la_paz.jpg',
    location: 'University of Texas at Dallas, USA',
    type: MemberType.engineer,
    specialties: [
      'Machine Learning',
      'Data Analysis',
      'Evolutionary Biology',
      'Python',
    ],
    details: [
      'PhD in Physics — Sorbonne Université',
      'Computational methods for biological systems',
      'Published researcher in ML applications',
    ],
    linkedinUrl: 'https://linkedin.com/in/alberto-de-la-paz',
  ),
  TeamMember(
    name: 'Dr. Sergio Enrique Yarza Acuña',
    title: 'Data Scientist',
    location: 'Tepic, Nayarit, México',
    type: MemberType.engineer,
    specialties: ['Applied Mathematics', 'Data Analysis', 'Python', 'R'],
    details: [
      'PhD in Applied Mathematics — UNAM',
      'Data Scientist at DeAcero Group',
      'Specialist in statistical modeling',
    ],
    linkedinUrl: 'https://www.linkedin.com/in/sergio-yarza/',
  ),
  TeamMember(
    name: 'Lic. Emilio Antonio Pérez Ocampo',
    title: 'Software Engineering Lead',
    location: 'Ciudad de México',
    type: MemberType.engineer,
    specialties: [
      'Flutter',
      'Machine Learning',
      'Cloud Computing (GCP/AWS)',
      'Microservices',
    ],
    details: [
      'Computer Science — UNAM',
      'Led software development at JusticIAdministrativa',
      'Multiple Google Cloud Certifications',
    ],
    linkedinUrl: 'https://www.linkedin.com/in/emilio-antonio-perez-ocampo/',
  ),
];

// ---------------------------------------------------------------------------
// Color constants
// ---------------------------------------------------------------------------

const _navyColor = Color(0xFF1E3A8A);
const _goldColor = Color(0xFFD4AF37);
const _tealColor = Color(0xFF0D9488);

// ---------------------------------------------------------------------------
// TeamSection — main widget
// ---------------------------------------------------------------------------

class TeamSection extends StatefulWidget {
  const TeamSection({super.key});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
  MemberType? _filter; // null = show all

  List<TeamMember> get _filtered => _filter == null
      ? _members
      : _members.where((m) => m.type == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Column(
      children: [
        const _TeamHeader(),
        SectionContainer(
          padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
          child: Column(
            children: [
              // Filter chips
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _FilterChip(
                    label: 'Todos',
                    icon: LucideIcons.users,
                    isActive: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  _FilterChip(
                    label: 'Abogados',
                    icon: LucideIcons.scale,
                    isActive: _filter == MemberType.lawyer,
                    onTap: () => setState(() => _filter = MemberType.lawyer),
                  ),
                  _FilterChip(
                    label: 'Ingenieros',
                    icon: LucideIcons.cpu,
                    isActive: _filter == MemberType.engineer,
                    onTap: () => setState(() => _filter = MemberType.engineer),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Responsive grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final int cols;
                  if (width >= 1024) {
                    cols = 3;
                  } else if (width >= 640) {
                    cols = 2;
                  } else {
                    cols = 1;
                  }
                  final cardWidth = (width - (cols - 1) * 24) / cols;

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      for (var i = 0; i < filtered.length; i++)
                        SizedBox(
                          width: cardWidth,
                          child: _TeamMemberCard(member: filtered[i])
                              .animate()
                              .fadeIn(duration: 400.ms, delay: (i * 80).ms)
                              .slideY(begin: 0.05, end: 0),
                        ),
                    ],
                  );
                },
              ),
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
