part of '../about.dart';

class _CoFounderCard extends StatelessWidget {
  final String name;
  final String title;
  final Color titleColor;
  final String imagePath;
  final List<String> education;
  final List<String> trajectory;
  final List<String> specialties;

  const _CoFounderCard({
    required this.name,
    required this.title,
    required this.titleColor,
    required this.imagePath,
    required this.education,
    required this.trajectory,
    required this.specialties,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);
    const goldColor = Color(0xFFD4AF37);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 768;
          return Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            children: [
              // Image
              SizedBox(
                width: isDesktop
                    ? constraints.maxWidth * 0.33
                    : double.infinity,
                height: isDesktop ? 450 : 300,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: navyColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Education
                      const Text(
                        'Formación Académica',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...education.map(
                        (e) => _LeadershipItem(text: e, iconColor: goldColor),
                      ),
                      const SizedBox(height: 20),

                      // Trajectory
                      const Text(
                        'Trayectoria Profesional',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...trajectory.map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                margin: const EdgeInsets.only(top: 7),
                                decoration: BoxDecoration(
                                  color: titleColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.foreground.withValues(
                                      alpha: 0.8,
                                    ),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Specialties
                      const Text(
                        'Áreas de Especialización',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: specialties
                            .map((s) => _Pill(text: s, color: navyColor))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LeadershipItem extends StatelessWidget {
  final String text;
  final Color iconColor;

  const _LeadershipItem({required this.text, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.graduationCap, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;

  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Founder quote
// ---------------------------------------------------------------------------

class _FounderQuoteSection extends StatelessWidget {
  const _FounderQuoteSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const goldColor = Color(0xFFD4AF37);
    const navyColor = Color(0xFF1E3A8A);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(colors.radiusXl),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(LucideIcons.quote, color: goldColor, size: 40),
              const SizedBox(height: 24),
              Text(
                'Las posibles vulneraciones a derechos fundamentales por '
                'el uso de tecnologías quedan limitadas cuando se '
                'implementan como marco los principios generales del '
                'derecho administrativo; y los problemas del derecho '
                'administrativo, son mitigados cuando se utilizan '
                'tecnologías. Se complementan.\n\n'
                'Por lo tanto, la clave para implementar las tecnologías '
                'digitales más avanzadas de manera continua sin sacrificar '
                'el interés general ni vulnerar derechos fundamentales es '
                'advertir los problemas que genera el lenguaje con que '
                'está construido el derecho administrativo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  color: colors.foreground,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 48,
                height: 3,
                decoration: BoxDecoration(
                  color: goldColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '— Lic. Alfredo Delgadillo López',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: navyColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Co-Fundador y Socio Director',
                style: TextStyle(
                  fontSize: 12,
                  color: goldColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }
}
