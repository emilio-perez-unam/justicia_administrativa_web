part of '../about.dart';

class _AffiliationBanner extends StatelessWidget {
  const _AffiliationBanner();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);
    const goldColor = Color(0xFFD4AF37);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: Border(
          left: const BorderSide(color: goldColor, width: 4),
          top: BorderSide(color: colors.border),
          right: BorderSide(color: colors.border),
          bottom: BorderSide(color: colors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: navyColor.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.globe, size: 40, color: navyColor),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AFILIACIÓN PROFESIONAL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: goldColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Foro Iberoamericano de Derecho Administrativo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: navyColor,
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Participamos activamente en las principales '
                  'organizaciones y asociaciones del sector legal y '
                  'tecnológico, contribuyendo al desarrollo de '
                  'nuestra profesión.',
                  style: TextStyle(color: colors.mutedForeground, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

// ---------------------------------------------------------------------------
// Social responsibility (2 real programs)
// ---------------------------------------------------------------------------

class _SocialResponsibilitySection extends StatelessWidget {
  const _SocialResponsibilitySection();

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);
    const tealColor = Color(0xFF0D9488);

    return Column(
      children: [
        Text(
          'Responsabilidad Social',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: navyColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Creemos firmemente en devolver a la sociedad y contribuir al '
          'desarrollo de un sistema legal más justo, accesible y '
          'eficiente para todos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.mutedForeground),
        ),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 768;
            final itemWidth = isDesktop
                ? (constraints.maxWidth - 32) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: 32,
              runSpacing: 32,
              children: [
                _SocialCard(
                  width: itemWidth,
                  icon: LucideIcons.heart,
                  iconColor: tealColor,
                  title: 'Programa Pro Bono',
                  description:
                      'Representamos de forma gratuita a personas y '
                      'comunidades de escasos recursos en asuntos '
                      'administrativos frente a las autoridades.',
                ),
                _SocialCard(
                  width: itemWidth,
                  icon: LucideIcons.graduationCap,
                  iconColor: tealColor,
                  title: 'Educación Legal',
                  description:
                      'Ofrecemos talleres y cursos gratuitos sobre derecho '
                      'administrativo en universidades públicas y '
                      'comunidades rurales, democratizando el conocimiento '
                      'legal.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SocialCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _SocialCard({
    required this.width,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radius),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: navyColor),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Leadership (founder)
// ---------------------------------------------------------------------------

class _LeadershipSection extends StatelessWidget {
  const _LeadershipSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: colors.secondary.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(bottom: BorderSide(color: colors.border)),
          ),
          child: Column(
            children: [
              Text(
                'Nuestro Liderazgo',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: navyColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Conoce al socio fundador que lidera nuestra firma, '
                'combinando experiencia jurídica de primer nivel con '
                'innovación tecnológica.',
                style: TextStyle(fontSize: 14, color: colors.mutedForeground),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const _CoFounderCard(
          name: 'Lic. Alfredo Delgadillo López',
          title: 'CO-FUNDADOR Y SOCIO DIRECTOR',
          titleColor: Color(0xFFD4AF37),
          imagePath: 'assets/images/alfredo-delgadillo-lopez.jpg',
          education: [
            'Licenciatura en Derecho (UAN)',
            'Maestría en Anticorrupción (Universidad Panamericana)',
          ],
          trajectory: [
            'Fundador de justicIAdministrativa',
            'Profesor en universidades de México e Iberoamérica en Derecho Administrativo y Digital',
            'Autor y coordinador de libros sobre derecho administrativo y derecho digital',
            'Abogado Digital certificado por la Academia Mexicana de Derecho Informático',
            'Coordinador del Seminario Derecho Administrativo en la 4ª Revolución Industrial — IIJUNAM',
            'Columnista en diversos periódicos en México',
            'Asesor jurídico y litigante en derecho público y derecho digital',
          ],
          specialties: [
            'Amparo Administrativo',
            'Contencioso Administrativo',
            'Licitaciones Públicas',
            'Derecho Digital',
          ],
        ),
      ],
    );
  }
}
