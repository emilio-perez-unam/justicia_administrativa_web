// Renders the AI assistant welcome state before a conversation begins.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/context_extension.dart';

/// Empty state for the AI assistant chat surface.
class ChatEmptyState extends StatelessWidget {
  static const _navy = Color(0xFF1A365D);

  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/brand/001-logo-primary.jpg',
            width: 80,
          ).animate().scale(delay: 200.ms),
          const Gap(24),
          Text(
            'JusticIAdministrativa',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _navy,
              fontFamily: 'serif',
            ),
          ),
          const Gap(8),
          Text(
            'Tu asistente jurídico avanzado.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
