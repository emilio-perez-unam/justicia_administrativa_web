// Renders the message composer, attachment affordance, and send button.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_theme_extension.dart';

/// Input row for composing and sending a portal message, with an optional
/// file attachment pending above the input.
class MessagesComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;
  final VoidCallback onPickAttachment;
  final VoidCallback onClearAttachment;

  /// Name of the file staged for sending, or `null` when none is selected.
  final String? pendingAttachmentName;

  /// True while the staged attachment is uploading — disables send + pick.
  final bool isUploading;

  const MessagesComposer({
    super.key,
    required this.controller,
    required this.onSendMessage,
    required this.onPickAttachment,
    required this.onClearAttachment,
    this.pendingAttachmentName,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pendingAttachmentName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AttachmentChip(
                name: pendingAttachmentName!,
                isUploading: isUploading,
                onClear: onClearAttachment,
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.paperclip),
                tooltip: 'Adjuntar archivo',
                onPressed: isUploading ? null : onPickAttachment,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Escribe un mensaje...",
                    filled: true,
                    fillColor: colors.secondary.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => onSendMessage(),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: navyColor,
                child: isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          LucideIcons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: onSendMessage,
                        tooltip: 'Enviar mensaje',
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The staged-attachment pill shown above the input before sending.
class _AttachmentChip extends StatelessWidget {
  final String name;
  final bool isUploading;
  final VoidCallback onClear;

  const _AttachmentChip({
    required this.name,
    required this.isUploading,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.secondary.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.paperclip, size: 14),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            if (isUploading)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              InkWell(
                onTap: onClear,
                child: const Icon(LucideIcons.x, size: 14),
              ),
          ],
        ),
      ),
    );
  }
}
