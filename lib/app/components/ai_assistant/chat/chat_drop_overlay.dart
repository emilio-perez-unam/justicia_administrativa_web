// Renders the drag-and-drop affordance for chat attachments.

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Overlay shown while a file is dragged over the chat surface.
class ChatDropOverlay extends StatelessWidget {
  final Color color;

  const ChatDropOverlay({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: color.withValues(alpha: 0.1),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.uploadCloud, size: 48, color: color),
                const Gap(16),
                Text(
                  'Soltar archivo aquí',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
