import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../router.dart';
import 'section_container.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.sizeOf(context);
    // Floor keeps the CTAs and scroll indicator reachable on short
    // viewports (mobile browser chrome, landscape phones); the parent is a
    // vertical SingleChildScrollView so the section can grow past it.
    final double heroHeight = viewport.height < 620 ? 620 : viewport.height;
    final double headlineSize = viewport.width < 600
        ? 34
        : (viewport.width < 1200 ? 44 : 56);
    final double subheadlineSize = viewport.width < 600 ? 16 : 20;
    return SizedBox(
      height: heroHeight, // min-h-screen with a usable minimum
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image with Overlay
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1764920940838-2dfdc55e8bd0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1920',
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(color: const Color(0xFF1E3A8A)),
              errorWidget: (context, url, error) =>
                  Container(color: const Color(0xFF1E3A8A)),
            ),
          ),
          // Navy Overlay (Approximate mix-blend-multiply with opacity)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.85),
            ),
          ),
          // Black Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          // Main Content
          Column(
            children: [
              Expanded(
                child: Center(
                  child: MaxWidth(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFD4AF37,
                                ).withValues(alpha: 0.2),
                                border: Border.all(
                                  color: const Color(0xFFD4AF37),
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                "LÍDERES EN LEGALTECH",
                                style: TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 24),

                        // Headline
                        Text(
                              "Transformando el Derecho Administrativo Mexicano con Inteligencia Artificial",
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.playfairDisplay()
                                        .fontFamily,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                    fontSize: headlineSize,
                                  ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 800.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 24),

                        // Subheadline
                        ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: Text(
                                "Con un equipo multidisciplinario conformado por juristas referentes en Iberoamérica y expertos en tecnologías digitales.",
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontWeight: FontWeight.w300,
                                      height: 1.6,
                                      fontSize: subheadlineSize,
                                    ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 800.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 40),

                        // Buttons
                        Wrap(
                              spacing: 24,
                              runSpacing: 16,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      context.go(AppRouter.contact),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD4AF37),
                                    foregroundColor: const Color(0xFF1E3A8A),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 20,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Consulta Legal"),
                                ),
                                OutlinedButton(
                                  onPressed: () =>
                                      context.go(AppRouter.aiAssistant),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 20,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Demo IA"),
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 800.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ),
              ),

              // Scroll indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.chevronsDown,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scroll para descubrir más',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 1000.ms).fadeIn(duration: 800.ms),
            ],
          ),
        ],
      ),
    );
  }
}
