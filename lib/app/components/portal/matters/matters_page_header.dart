// Renders the portal matters page title and the new-matter action.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Header for the matters list view, with the "Nuevo Asunto" action.
class MattersPageHeader extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onNewMatter;

  const MattersPageHeader({
    super.key,
    required this.isMobile,
    required this.onNewMatter,
  });

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Mis Asuntos',
              style: TextStyle(
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                fontSize: isMobile ? 28 : 32,
                fontWeight: FontWeight.bold,
                color: navyColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: onNewMatter,
            icon: const Icon(LucideIcons.plus, size: 16),
            label: Text(isMobile ? 'Nuevo' : 'Nuevo Asunto'),
            style: FilledButton.styleFrom(
              backgroundColor: navyColor,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
