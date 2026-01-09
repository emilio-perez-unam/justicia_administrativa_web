import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:justicia_administrativa_web/core/routes/app_routes.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_layout.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Container(
      height: AppSpacing.headerHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          padding: AppSpacing.pagePaddingHorizontal,
          child: ResponsiveLayout(
            mobile: _MobileHeader(currentRoute: currentRoute),
            tablet: _MobileHeader(currentRoute: currentRoute), // Using mobile header for tablet as well
            desktop: _DesktopHeader(currentRoute: currentRoute),
          ),
        ),
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  final String currentRoute;

  const _DesktopHeader({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo and brand name
        _LogoSection(),

        // Navigation items with scroll for overflow protection
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _NavItem(
                  label: 'Inicio',
                  route: AppRoutes.home,
                  isActive: currentRoute == AppRoutes.home,
                ),
                _NavItem(
                  label: 'Nosotros',
                  route: AppRoutes.about,
                  isActive: currentRoute == AppRoutes.about,
                ),
                _NavItem(
                  label: 'Servicios Legales',
                  route: AppRoutes.legalServices,
                  isActive: currentRoute == AppRoutes.legalServices,
                ),
                _NavItem(
                  label: 'Soluciones IA',
                  route: AppRoutes.aiSolutions,
                  isActive: currentRoute == AppRoutes.aiSolutions,
                ),
                _NavItem(
                  label: 'Equipo',
                  route: AppRoutes.team,
                  isActive:
                      currentRoute == AppRoutes.team ||
                      currentRoute.startsWith('/equipo/'),
                ),
                _NavItem(
                  label: 'Publicaciones',
                  route: AppRoutes.publications,
                  isActive: currentRoute == AppRoutes.publications,
                ),
                _NavItem(
                  label: 'Blog',
                  route: AppRoutes.blog,
                  isActive: currentRoute == AppRoutes.blog,
                ),
                _NavItem(
                  label: 'Contacto',
                  route: AppRoutes.contact,
                  isActive: currentRoute == AppRoutes.contact,
                ),
                const SizedBox(width: AppSpacing.lg),
                // Portal login button
                TextButton(
                  onPressed: () => context.go(AppRoutes.portal),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.techBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  child: const Text('Portal'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileHeader extends StatefulWidget {
  final String currentRoute;

  const _MobileHeader({required this.currentRoute});

  @override
  State<_MobileHeader> createState() => _MobileHeaderState();
}

class _MobileHeaderState extends State<_MobileHeader> {
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _LogoSection(),
        IconButton(
          icon: const Icon(Icons.menu, size: 28),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  _MobileMenu(currentRoute: widget.currentRoute),
            );
          },
        ),
      ],
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final String currentRoute;

  const _MobileMenu({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            _MobileNavItem(
              label: 'Inicio',
              route: AppRoutes.home,
              isActive: currentRoute == AppRoutes.home,
              icon: Icons.home,
            ),
            _MobileNavItem(
              label: 'Nosotros',
              route: AppRoutes.about,
              isActive: currentRoute == AppRoutes.about,
              icon: Icons.info,
            ),
            _MobileNavItem(
              label: 'Servicios Legales',
              route: AppRoutes.legalServices,
              isActive: currentRoute == AppRoutes.legalServices,
              icon: Icons.gavel,
            ),
            _MobileNavItem(
              label: 'Soluciones IA',
              route: AppRoutes.aiSolutions,
              isActive: currentRoute == AppRoutes.aiSolutions,
              icon: Icons.psychology,
            ),
            _MobileNavItem(
              label: 'Equipo',
              route: AppRoutes.team,
              isActive:
                  currentRoute == AppRoutes.team ||
                  currentRoute.startsWith('/equipo/'),
              icon: Icons.group,
            ),
            _MobileNavItem(
              label: 'Publicaciones',
              route: AppRoutes.publications,
              isActive: currentRoute == AppRoutes.publications,
              icon: Icons.book,
            ),
            _MobileNavItem(
              label: 'Blog',
              route: AppRoutes.blog,
              isActive: currentRoute == AppRoutes.blog,
              icon: Icons.article,
            ),
            _MobileNavItem(
              label: 'Contacto',
              route: AppRoutes.contact,
              isActive: currentRoute == AppRoutes.contact,
              icon: Icons.contact_mail,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.portal);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.techBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Portal'),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label;
  final String route;
  final bool isActive;
  final IconData icon;

  const _MobileNavItem({
    required this.label,
    required this.route,
    required this.isActive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppColors.accentGold : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: AppTypography.bodyMedium(context).copyWith(
          color: isActive ? AppColors.accentGold : AppColors.textPrimary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isActive
          ? const Icon(Icons.chevron_right, color: AppColors.accentGold)
          : null,
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(AppRoutes.home),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: const Icon(Icons.balance, color: Colors.white, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < ResponsiveLayout.tabletBreakpoint) { // Using tabletBreakpoint as the threshold for showing "JA"
                return Text(
                  'JA',
                  style: AppTypography.headingMedium(context).copyWith(
                    color: AppColors.primaryNavy,
                  ),
                );
              } else {
                return Text(
                  'Justicia Administrativa',
                  style: AppTypography.headingMedium(context).copyWith(
                    color: AppColors.primaryNavy,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final String route;
  final bool isActive;

  const _NavItem({
    required this.label,
    required this.route,
    required this.isActive,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () => context.go(widget.route),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTypography.navItem(context).copyWith(
                  color: widget.isActive
                      ? AppColors.accentGold
                      : isHovered
                      ? AppColors.navyHover
                      : AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive || isHovered ? 30 : 0,
                color: widget.isActive
                    ? AppColors.accentGold
                    : AppColors.primaryNavy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
