part of '../about.dart';

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1763925407670-2fbc0f3cb9da'
                '?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1920',
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: const Color(0xFF1E3A8A)),
            errorWidget: (context, url, error) =>
                Container(color: const Color(0xFF1E3A8A)),
          ),
          Container(color: const Color(0xFF1E3A8A).withValues(alpha: 0.8)),
          Center(
            child: MaxWidth(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                        'Nuestra Historia',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                              fontFamily:
                                  GoogleFonts.playfairDisplay().fontFamily,
                            ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  Text(
                    'Un ecosistema jurídico-tecnológico que fusiona experiencia '
                    'legal, investigación científica e inteligencia artificial '
                    'para transformar el derecho administrativo en Iberoamérica.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Intro section (replaces fake timeline)
// ---------------------------------------------------------------------------

class _IntroSection extends StatelessWidget {
  const _IntroSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);
    const goldColor = Color(0xFFD4AF37);

    return Column(
      children: [
        const SectionHeader(
          eyebrow: 'Quiénes Somos',
          title: 'Un ecosistema jurídico-tecnológico',
          subtitle:
              'Donde convergen la experiencia jurídica y la inteligencia '
              'artificial para revolucionar el derecho administrativo.',
          center: true,
        ),
        const SizedBox(height: 48),

        // Ecosystem description
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Text(
            'Somos un ecosistema jurídico-tecnológico que revoluciona la '
            'práctica del derecho administrativo en Iberoamérica donde '
            'convergen tanto la experiencia jurídica de magistrados en '
            'retiro, funcionarios públicos, consultores, académicos y '
            'litigantes como los conocimientos de ingenieros expertos en '
            'inteligencia artificial. Nuestro equipo interdisciplinario, '
            'distribuido estratégicamente entre México, España, Argentina '
            'y Canadá crea soluciones que fusionan tres elementos: '
            'desarrollo de software jurídico con inteligencia artificial '
            'personalizada, prestación de servicios legales especializados '
            'y un sistema de conexión entre clientes iberoamericanos y '
            'expertos en derecho administrativo iberoamericano.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: colors.foreground,
              height: 1.8,
            ),
          ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 32),

        // Trayectoria description
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Text(
            'Nuestra trayectoria colectiva incluye la experiencia '
            'iberoamericana de dictar sentencias de lo contencioso '
            'administrativo, colaborar en las administraciones públicas, '
            'litigar derecho administrativo, impartir clases sobre esta '
            'disciplina y realizar investigaciones científicas, asimismo, '
            'más de 10 años de estudios y asesorías tanto en derecho '
            'digital como en informática. Todo esto proporciona el '
            'conocimiento empírico para entrenar algoritmos de '
            'inteligencia artificial que realmente permitan mejorar la '
            'práctica del derecho administrativo y solucionar problemas a '
            'las administraciones públicas, los órganos jurisdiccionales '
            'y los despachos jurídicos con el fin de construir una mejor '
            'sociedad.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: colors.mutedForeground,
              height: 1.8,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 48),

        // Founding card
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(colors.radiusXl),
              border: Border.all(color: goldColor.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: goldColor.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: goldColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.sparkles,
                    color: goldColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '2025',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fundación de JusticIAdministrativa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: navyColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Nace un nuevo ecosistema jurídico-tecnológico con el '
                  'objetivo de revolucionar la práctica del derecho '
                  'administrativo, fusionando la experiencia legal con la '
                  'inteligencia artificial para crear soluciones innovadoras '
                  'en Iberoamérica.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.mutedForeground, height: 1.6),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Mission & Vision
// ---------------------------------------------------------------------------
