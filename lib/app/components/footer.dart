import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../router.dart';
import 'section_container.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Matches bg-slate-900
    const backgroundColor = Color(0xFF0F172A);
    const borderColor = Color(0xFF1E293B); // border-slate-800

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        children: [
          SectionContainer(
            background: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const _FooterTop(),
                const SizedBox(height: 48),
                Divider(color: borderColor),
                const SizedBox(height: 32),
                const _FooterBottom(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterTop extends StatelessWidget {
  const _FooterTop();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 2, child: _BrandColumn()),
              const SizedBox(width: 40),
              const Expanded(child: _LinksColumn()),
            ],
          );
        }

        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_BrandColumn(), SizedBox(height: 40), _LinksColumn()],
        );
      },
    );
  }
}

class _BrandColumn extends StatelessWidget {
  const _BrandColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/brand/001-logo-primary.jpg',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image not found
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A), // Navy
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.scale,
                      color: Colors.white,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                children: [
                  TextSpan(
                    text: "JusticI",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: "Administrativa",
                    style: TextStyle(color: Color(0xFF0D9488)),
                  ), // Teal
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          "Combinamos la excelencia en derecho administrativo con el poder de la inteligencia artificial para ofrecer soluciones legales más rápidas, precisas y eficientes en México.",
          style: TextStyle(
            color: Color(0xFF94A3B8),
            height: 1.6,
            fontSize: 16,
          ), // slate-400
        ),
      ],
    );
  }
}

class _LinksColumn extends StatelessWidget {
  const _LinksColumn();

  static const _links = [
    {'text': 'Inicio', 'route': AppRouter.home},
    {'text': 'Servicios', 'route': AppRouter.services},
    {'text': 'Nosotros', 'route': AppRouter.about},
    {'text': 'Equipo', 'route': AppRouter.team},
    {'text': 'Contacto', 'route': AppRouter.contact},
  ];

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enlaces Rápidos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ..._links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _FooterLink(
              text: link['text']!,
              hoverColor: goldColor,
              onTap: () {
                // If route is current, scroll? For now, standard push.
                // Assuming AppRouter uses string routes.
                context.go(link['route']!);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;
  final Color hoverColor;
  final VoidCallback? onTap;

  const _FooterLink({required this.text, required this.hoverColor, this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? () {},
      onHover: (val) => setState(() => _isHovered = val),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      child: Text(
        widget.text,
        style: TextStyle(
          color: _isHovered ? widget.hoverColor : const Color(0xFF94A3B8),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _FooterBottom extends StatelessWidget {
  const _FooterBottom();

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Text(
      "© $year JusticIAdministrativa S.A. de C.V. Todos los derechos reservados.",
      style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
