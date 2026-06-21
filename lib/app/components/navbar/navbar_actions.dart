part of '../navbar.dart';

class _MenuToggleButton extends StatelessWidget {
  const _MenuToggleButton({required this.isOpen, required this.onPressed});

  final bool isOpen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isOpen ? 'Cerrar menú' : 'Abrir menú',
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          isOpen ? LucideIcons.x : LucideIcons.menu,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  final String text;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isActive || _isHovered;
    final textColor = isHighlighted
        ? const Color(0xFFD4AF37)
        : Colors.white.withValues(alpha: 0.85);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width > 1100 ? 16 : 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.sizeOf(context).width > 1100 ? 14 : 13,
                  fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                height: 2,
                width: widget.isActive ? 24 : (_isHovered ? 12 : 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isHighlighted
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerNavLink extends StatelessWidget {
  const _DrawerNavLink({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.textColor,
    required this.mutedTextColor,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color textColor;
  final Color mutedTextColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: Icon(icon, color: isActive ? activeColor : mutedTextColor),
      title: Text(
        label,
        style: GoogleFonts.inter(
          color: isActive ? activeColor : textColor,
          fontSize: 17,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
          height: 1.2,
        ),
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        size: 18,
        color: isActive ? activeColor : mutedTextColor,
      ),
      onTap: onTap,
    );
  }
}

class _TabletQuickLink extends StatelessWidget {
  const _TabletQuickLink({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.textColor,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? activeColor : textColor,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
      child: Text(label),
    );
  }
}

class _UserIdentityChip extends StatelessWidget {
  const _UserIdentityChip({
    required this.displayName,
    required this.initials,
    required this.gold,
    required this.textColor,
  });

  final String displayName;
  final String initials;
  final Color gold;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: gold, shape: BoxShape.circle),
            child: Text(
              initials,
              style: GoogleFonts.inter(
                color: const Color(0xFF10203D),
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            displayName,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.background,
    required this.foreground,
    this.borderColor,
    this.textColor,
    this.expand = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final Color? textColor;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: background,
        foregroundColor: foreground,
        minimumSize: Size(expand ? double.infinity : 0, 46),
        padding: EdgeInsets.symmetric(
          horizontal: expand ? 18 : 14,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: borderColor == null
              ? BorderSide.none
              : BorderSide(color: borderColor!),
        ),
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor ?? foreground,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.1,
        ),
      ),
    );

    return expand ? button : FittedBox(child: button);
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final IconData icon;
}
