import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_layout.dart'; // Added import

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          padding: AppSpacing.pagePaddingHorizontal,
          child: ResponsiveLayout(
            mobile: _MobileFooter(),
            tablet: _MobileFooter(), // Using mobile footer for tablet as well
            desktop: _DesktopFooter(),
          ),
        ),
      ),
    );
  }
}

class _DesktopFooter extends StatelessWidget {
  const _DesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main footer content
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company info
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Justicia Administrativa',
                    style: AppTypography.headingSmall(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Transformando el derecho administrativo iberoamericano con tecnología de vanguardia.',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xl),

            // Services
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Servicios',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FooterLink(label: 'Derecho Administrativo'),
                  _FooterLink(label: 'Soluciones IA'),
                  _FooterLink(label: 'Consultoría Legal'),
                  _FooterLink(label: 'Capacitación'),
                ],
              ),
            ),

            // Company
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Empresa',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FooterLink(label: 'Nosotros'),
                  _FooterLink(label: 'Equipo'),
                  _FooterLink(label: 'Blog'),
                  _FooterLink(label: 'Contacto'),
                ],
              ),
            ),

            // Contact
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contacto',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: AppColors.accentGold,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '+52 311 125 09 06',
                        style: AppTypography.bodySmall(context).copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: AppColors.accentGold,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'solicitudes@justiciadministrativa.com',
                        style: AppTypography.bodySmall(context).copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.accentGold,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Ciudad de México, México',
                          style: AppTypography.bodySmall(context).copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        // Divider
        Container(height: 1, color: Colors.white12),

        const SizedBox(height: AppSpacing.lg),

        // Copyright
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2025 Justicia Administrativa. Todos los derechos reservados.',
              style: AppTypography.caption(context).copyWith(
                color: Colors.white60,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Aviso de Privacidad',
                    style: AppTypography.caption(context).copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ),
                Text(
                  '|',
                  style: AppTypography.caption(context).copyWith(
                    color: Colors.white60,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Términos de Uso',
                    style: AppTypography.caption(context).copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MobileFooter extends StatelessWidget {
  const _MobileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Justicia Administrativa',
              style: AppTypography.headingSmall(context).copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Transformando el derecho administrativo iberoamericano con tecnología de vanguardia.',
              style: AppTypography.bodySmall(context).copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Services
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Servicios',
              style: AppTypography.bodyMedium(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _FooterLink(label: 'Derecho Administrativo'),
            _FooterLink(label: 'Soluciones IA'),
            _FooterLink(label: 'Consultoría Legal'),
            _FooterLink(label: 'Capacitación'),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Company
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Empresa',
              style: AppTypography.bodyMedium(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _FooterLink(label: 'Nosotros'),
            _FooterLink(label: 'Equipo'),
            _FooterLink(label: 'Blog'),
            _FooterLink(label: 'Contacto'),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Contact
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contacto',
              style: AppTypography.bodyMedium(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: AppColors.accentGold,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '+52 311 125 09 06',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: AppColors.accentGold,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'solicitudes@justiciadministrativa.com',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.accentGold,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Ciudad de México, México',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        // Divider
        Container(height: 1, color: Colors.white12),

        const SizedBox(height: AppSpacing.lg),

        // Copyright
        Column( // Changed to Column for mobile
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '© 2025 Justicia Administrativa. Todos los derechos reservados.',
              style: AppTypography.caption(context).copyWith(
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: AppSpacing.sm), // Added spacing
            Column( // Changed to Column for mobile
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Aviso de Privacidad',
                    style: AppTypography.caption(context).copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ),
                // Removed '|' as it's not needed when stacked
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Términos de Uso',
                    style: AppTypography.caption(context).copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  

  const _FooterLink({required this.label});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            widget.label,
            style: AppTypography.bodySmall(context).copyWith(
              color: isHovered ? AppColors.accentGold : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
