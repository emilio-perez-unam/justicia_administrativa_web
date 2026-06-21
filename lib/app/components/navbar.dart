import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../router.dart';
import 'section_container.dart';

part 'navbar/navbar_actions.dart';
part 'navbar/navbar_brand_desktop.dart';
part 'navbar/navbar_mobile_menu.dart';

enum _BrandDensity { full, compact, minimal }

class Navbar extends StatefulWidget {
  const Navbar({
    super.key,
    this.forceSolidBackground = false,
    this.maxContentWidth = kMaxWidth,
  });

  static const double height = 76;

  final bool forceSolidBackground;
  final double maxContentWidth;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  static const Color _navy = Color(0xFF10203D);
  static const Color _navySoft = Color(0xFF1A2D4F);
  static const Color _navySurface = Color(0xFF0E1A31);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _inkOnDark = Color(0xFFE8EEFF);
  static const Color _inkMuted = Color(0xFFB8C6E5);

  bool _mobileMenuOpen = false;

  static const List<_NavDestination> _publicLinks = [
    _NavDestination(
      label: 'Inicio',
      route: AppRouter.home,
      icon: Icons.home_outlined,
    ),
    _NavDestination(
      label: 'Nosotros',
      route: AppRouter.about,
      icon: Icons.account_balance_outlined,
    ),
    _NavDestination(
      label: 'Servicios',
      route: AppRouter.services,
      icon: Icons.gavel_outlined,
    ),
    _NavDestination(
      label: 'Equipo',
      route: AppRouter.team,
      icon: Icons.groups_outlined,
    ),
    _NavDestination(
      label: 'Blog',
      route: AppRouter.blog,
      icon: Icons.article_outlined,
    ),
    _NavDestination(
      label: 'Contacto',
      route: AppRouter.contact,
      icon: Icons.contact_mail_outlined,
    ),
  ];

  String get _currentPath {
    try {
      return GoRouterState.of(context).uri.path;
    } catch (_) {
      return AppRouter.home;
    }
  }

  bool get _isPortalOpen => _currentPath == AppRouter.portal;

  bool _isActive(String route) => _currentPath == route;

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  void _navigate(String route) {
    setState(() => _mobileMenuOpen = false);
    context.go(route);
  }

  void _toggleMenu() => setState(() => _mobileMenuOpen = !_mobileMenuOpen);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 950;
    final isTablet = screenWidth >= 600 && screenWidth < 950;

    final isSolid =
        widget.forceSolidBackground ||
        _isPortalOpen ||
        _currentPath != AppRouter.home ||
        _mobileMenuOpen;

    // Gracefully scale down elements based on screen width instead of harsh snapping
    final double horizontalPadding = screenWidth > 1200
        ? 64.0
        : (screenWidth > 950 ? 32.0 : (isTablet ? 24.0 : 16.0));
    final double brandSize = screenWidth > 1100
        ? 22.0
        : (screenWidth > 950 ? 18.0 : (screenWidth > 400 ? 17.0 : 15.0));
    final double gapSize = screenWidth > 1100 ? 20.0 : 8.0;

    // Only show the subtitle if we have plenty of room
    final brandDensity = screenWidth > 1150
        ? _BrandDensity.full
        : _BrandDensity.compact;
    final mobileMenuDuration = Duration(milliseconds: isTablet ? 220 : 280);
    final mobileMenuOffset = isTablet
        ? const Offset(0, -0.03)
        : const Offset(0.06, 0);

    return Stack(
      children: [
        AnimatedContainer(
          duration: 260.ms,
          curve: Curves.easeOutCubic,
          height: Navbar.height,
          decoration: BoxDecoration(
            color: isSolid ? _navy : _navy.withValues(alpha: 0.9),
            gradient: isSolid
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _navy.withValues(alpha: 0.92),
                      _navy.withValues(alpha: 0.7),
                    ],
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSolid ? 0.2 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: MaxWidth(
            maxWidth: widget.maxContentWidth,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                Flexible(
                  child: _BrandLockup(
                    size: brandSize,
                    isSolid: isSolid,
                    density: brandDensity,
                    onTap: () => _navigate(AppRouter.home),
                  ),
                ),
                const SizedBox(width: 12),
                if (isDesktop)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isPortalOpen)
                              _DesktopNav(
                                links: _publicLinks,
                                isActive: _isActive,
                                onNavigate: _navigate,
                              ),
                            SizedBox(width: gapSize),
                            _DesktopAuthActions(
                              isPortalOpen: _isPortalOpen,
                              onNavigate: _navigate,
                              getInitials: _getInitials,
                              gold: _gold,
                              navy: _navy,
                              navySoft: _navySoft,
                              inkMuted: _inkMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else ...[
                  const Spacer(),
                  if (isTablet && !_isPortalOpen)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _TabletQuickLink(
                        label: 'Servicios',
                        isActive: _isActive(AppRouter.services),
                        onTap: () => _navigate(AppRouter.services),
                        activeColor: _gold,
                        textColor: _inkOnDark,
                      ),
                    ),
                  _MenuToggleButton(
                    isOpen: _mobileMenuOpen,
                    onPressed: _toggleMenu,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!isDesktop)
          Positioned(
            top: Navbar.height,
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSwitcher(
              duration: mobileMenuDuration,
              reverseDuration: mobileMenuDuration,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final slideAnimation =
                    Tween<Offset>(
                      begin: mobileMenuOffset,
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                        reverseCurve: Curves.easeInCubic,
                      ),
                    );
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: _mobileMenuOpen
                  ? _MobileDrawerMenu(
                      key: const ValueKey('mobile-menu-open'),
                      currentPath: _currentPath,
                      isPortalOpen: _isPortalOpen,
                      links: _publicLinks,
                      onNavigate: _navigate,
                      gold: _gold,
                      navySurface: _navySurface,
                      inkOnDark: _inkOnDark,
                      inkMuted: _inkMuted,
                    )
                  : const SizedBox.shrink(key: ValueKey('mobile-menu-closed')),
            ),
          ),
      ],
    );
  }
}
