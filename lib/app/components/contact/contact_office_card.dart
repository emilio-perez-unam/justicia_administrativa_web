// Renders one contact office card with its local contact affordances.

part of '../contact.dart';

class _OfficeCard extends StatelessWidget {
  final _OfficeData office;
  final Duration delay;

  const _OfficeCard({required this.office, required this.delay});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const goldColor = Color(0xFFD4AF37);

    return Semantics(
      container: true,
      label: '${office.city}, ${office.role}. ${office.address}',
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(colors.radiusXl),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _OfficeCardHeader(office: office),
            _OfficeCardBody(office: office, goldColor: goldColor),
          ],
        ),
      ).animate().fadeIn(delay: delay).slideY(begin: 0.1, end: 0),
    );
  }
}

class _OfficeCardHeader extends StatelessWidget {
  final _OfficeData office;

  const _OfficeCardHeader({required this.office});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: office.headerColor,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(office.icon, color: office.headerColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            office.city,
            style: TextStyle(
              fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            office.role.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficeCardBody extends StatelessWidget {
  final _OfficeData office;
  final Color goldColor;

  const _OfficeCardBody({required this.office, required this.goldColor});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OfficeInfoRow(
            icon: LucideIcons.mapPin,
            text: office.address,
            goldColor: goldColor,
            semanticLabel: 'Dirección de ${office.city}: ${office.address}',
          ),
          const SizedBox(height: 24),
          Text(
            "Áreas de Práctica",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          _PracticeTags(tags: office.tags),
        ],
      ),
    );
  }
}

class _OfficeInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color goldColor;
  final String semanticLabel;

  const _OfficeInfoRow({
    required this.icon,
    required this.text,
    required this.goldColor,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: goldColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: context.colors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeTags extends StatelessWidget {
  final List<String> tags;

  const _PracticeTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colors.border),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 10,
                  color: colors.mutedForeground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
