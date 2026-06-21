// Renders the active message thread header and call actions.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/matter.dart';
import '../../../../core/presentation/future_result_view.dart';

/// Header for the selected matter conversation.
class MessagesThreadHeader extends StatelessWidget {
  /// Loader function — called on init and on retry.
  final Future<List<Matter>> Function() mattersLoader;
  final String selectedMatterId;
  final VoidCallback onStartVoiceCall;
  final VoidCallback onStartVideoCall;

  const MessagesThreadHeader({
    super.key,
    required this.mattersLoader,
    required this.selectedMatterId,
    required this.onStartVoiceCall,
    required this.onStartVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: const Icon(LucideIcons.user, color: navyColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureResultView<List<Matter>>(
                  loader: mattersLoader,
                  builder: (context, matters) {
                    final matter = matters
                        .where((item) => item.id == selectedMatterId)
                        .firstOrNull;
                    return Text(
                      matter?.title ?? selectedMatterId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  },
                  loadingBuilder: (ctx) => const Text(
                    'Cargando...',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  errorBuilder: (ctx, failure, retry) => Text(
                    selectedMatterId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  "Asesoría Legal Activa",
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.phone),
            onPressed: onStartVoiceCall,
            tooltip: 'Llamada de voz',
          ),
          IconButton(
            icon: const Icon(LucideIcons.video),
            onPressed: onStartVideoCall,
            tooltip: 'Videollamada',
          ),
        ],
      ),
    );
  }
}
