part of '../navbar.dart';

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({
    required this.size,
    required this.isSolid,
    required this.density,
    required this.onTap,
  });

  final double size;
  final bool isSolid;
  final _BrandDensity density;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ir a la página de inicio',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/brand/001-logo-primary.jpg',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSolid
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFF10203D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.scale,
                      color: Color(0xFFD4AF37),
                      size: 21,
                    ),
                  );
                },
              ),
            ),
            if (density != _BrandDensity.minimal) ...[
              const SizedBox(width: 12),
              if (density == _BrandDensity.full)
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: GoogleFonts.playfairDisplay(
                            fontSize: size,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.15,
                          ),
                          children: const [
                            TextSpan(
                              text: 'JusticI',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Administrativa',
                              style: TextStyle(color: Color(0xFFD4AF37)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Derecho + Tecnología',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: const Color(0xFFB8C6E5),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: Text(
                    'JusticIAdministrativa',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: size,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.1,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DesktopNav extends StatelessWidget {
  const _DesktopNav({
    required this.links,
    required this.isActive,
    required this.onNavigate,
  });

  final List<_NavDestination> links;
  final bool Function(String route) isActive;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: links.map((link) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _NavLink(
            text: link.label,
            isActive: isActive(link.route),
            onTap: () => onNavigate(link.route),
          ),
        );
      }).toList(),
    );
  }
}

class _DesktopAuthActions extends StatelessWidget {
  const _DesktopAuthActions({
    required this.isPortalOpen,
    required this.onNavigate,
    required this.getInitials,
    required this.gold,
    required this.navy,
    required this.navySoft,
    required this.inkMuted,
  });

  final bool isPortalOpen;
  final ValueChanged<String> onNavigate;
  final String Function(String name) getInitials;
  final Color gold;
  final Color navy;
  final Color navySoft;
  final Color inkMuted;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppRouter.authNotifier,
      builder: (context, _) {
        final isAuth = AppRouter.authNotifier.isAuthenticated;

        if (isAuth && !isPortalOpen) {
          return Row(
            children: [
              _UserIdentityChip(
                displayName: AppRouter.authNotifier.displayName,
                initials: getInitials(AppRouter.authNotifier.displayName),
                gold: gold,
                textColor: Colors.white,
              ),
              const SizedBox(width: 10),
              _PrimaryActionButton(
                label: 'Mi Portal',
                icon: LucideIcons.lock,
                onTap: () => onNavigate(AppRouter.portal),
                background: gold,
                foreground: navy,
              ),
            ],
          );
        }

        if (isPortalOpen) {
          return _PrimaryActionButton(
            label: 'Volver al Sitio',
            icon: LucideIcons.arrowLeft,
            onTap: () => onNavigate(AppRouter.home),
            background: Colors.white,
            foreground: navy,
          );
        }

        return _PrimaryActionButton(
          label: 'Portal Cliente',
          icon: LucideIcons.user,
          onTap: () => onNavigate(AppRouter.portal),
          background: navySoft,
          foreground: Colors.white,
          borderColor: Colors.white.withValues(alpha: 0.18),
          textColor: inkMuted,
        );
      },
    );
  }
}
