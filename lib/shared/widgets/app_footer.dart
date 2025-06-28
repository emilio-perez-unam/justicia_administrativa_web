import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';

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
          child: Column(
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
                          style: AppTypography.headingSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Transformando el derecho administrativo iberoamericano con tecnología de vanguardia.',
                          style: AppTypography.bodySmall.copyWith(
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
                          style: AppTypography.bodyMedium.copyWith(
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
                          style: AppTypography.bodyMedium.copyWith(
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
                          style: AppTypography.bodyMedium.copyWith(
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
                              '+52 (55) 1234-5678',
                              style: AppTypography.bodySmall.copyWith(
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
                              'contacto@justicia-administrativa.mx',
                              style: AppTypography.bodySmall.copyWith(
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
                                style: AppTypography.bodySmall.copyWith(
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
                    style: AppTypography.caption.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Aviso de Privacidad',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ),
                      Text(
                        '|',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white60,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Términos de Uso',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ],
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

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _FooterLink({required this.label, this.onTap});

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
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            widget.label,
            style: AppTypography.bodySmall.copyWith(
              color: isHovered ? AppColors.accentGold : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
