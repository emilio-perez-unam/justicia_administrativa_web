import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:justicia_administrativa_web/core/routes/app_routes.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // --- THIS IS THE FIX ---
    // Switched from GoRouter.of(context).routerDelegate.currentConfiguration.uri
    // to GoRouterState.of(context).uri, which correctly rebuilds the widget on route changes.
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and brand name
              InkWell(
                onTap: () => context.go(AppRoutes.home),
                child: Row(
                  children: [
                    // Logo placeholder - will add actual logo later
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSmall,
                        ),
                      ),
                      child: const Icon(
                        Icons.balance,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Justicia Administrativa',
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation items
              Row(
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
                    isActive: currentRoute == AppRoutes.team,
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
            ],
          ),
        ),
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
                style: AppTypography.navItem.copyWith(
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
