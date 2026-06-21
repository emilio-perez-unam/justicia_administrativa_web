part of '../navbar.dart';

class _MobileDrawerMenu extends StatelessWidget {
  const _MobileDrawerMenu({
    super.key,
    required this.currentPath,
    required this.isPortalOpen,
    required this.links,
    required this.onNavigate,
    required this.gold,
    required this.navySurface,
    required this.inkOnDark,
    required this.inkMuted,
  });

  final String currentPath;
  final bool isPortalOpen;
  final List<_NavDestination> links;
  final ValueChanged<String> onNavigate;
  final Color gold;
  final Color navySurface;
  final Color inkOnDark;
  final Color inkMuted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: navySurface,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menú',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                children: [
                  if (!isPortalOpen)
                    ...links.map(
                      (link) => _DrawerNavLink(
                        label: link.label,
                        icon: link.icon,
                        isActive: currentPath == link.route,
                        onTap: () => onNavigate(link.route),
                        activeColor: gold,
                        textColor: inkOnDark,
                        mutedTextColor: inkMuted,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListenableBuilder(
                    listenable: AppRouter.authNotifier,
                    builder: (context, _) {
                      final isAuth = AppRouter.authNotifier.isAuthenticated;
                      final label = isPortalOpen
                          ? 'Volver al Sitio'
                          : isAuth
                          ? 'Mi Portal'
                          : 'Portal Cliente';

                      final actionIcon = isPortalOpen
                          ? LucideIcons.arrowLeft
                          : isAuth
                          ? LucideIcons.lock
                          : LucideIcons.user;

                      return _PrimaryActionButton(
                        label: label,
                        icon: actionIcon,
                        onTap: () => onNavigate(
                          isPortalOpen ? AppRouter.home : AppRouter.portal,
                        ),
                        background: isAuth && !isPortalOpen
                            ? gold
                            : const Color(0xFF1F3359),
                        foreground: isAuth && !isPortalOpen
                            ? const Color(0xFF10203D)
                            : Colors.white,
                        borderColor: isAuth && !isPortalOpen
                            ? null
                            : Colors.white.withValues(alpha: 0.18),
                        expand: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
