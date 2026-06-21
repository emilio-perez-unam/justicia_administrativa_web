// Renders the portal sidebar footer actions and version marker.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../legal_corpus_launcher.dart';

/// Displays the logout action and app version in the portal sidebar.
class PortalSidebarFooter extends StatelessWidget {
  final VoidCallback onLogout;

  const PortalSidebarFooter({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        children: [
          const LegalCorpusLauncher(),
          Semantics(
            button: true,
            label: 'Cerrar sesión',
            child: InkWell(
              onTap: onLogout,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.logOut,
                      size: 20,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Cerrar Sesión",
                      style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Versión 1.0.0+1",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
