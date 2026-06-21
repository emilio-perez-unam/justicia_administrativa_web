// Displays the empty state before a matter conversation is selected.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Centered prompt shown when no portal conversation is active.
class MessagesEmptyState extends StatelessWidget {
  const MessagesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: navyColor.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.messageSquare,
              size: 48,
              color: navyColor.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Selecciona un asunto para chatear",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
