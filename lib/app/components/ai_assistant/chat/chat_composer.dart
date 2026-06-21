// Owns the AI assistant input row, attachment chip, and local controls.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Composer for text, attachment, voice, web-search, and send actions.
class ChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function([String? text]) onSend;
  final VoidCallback onUpload;
  final VoidCallback onVoice;
  final ValueNotifier<bool> webSearchEnabled;
  final ValueNotifier<PlatformFile?> attachment;
  final bool uploading;
  final bool listening;

  const ChatComposer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onUpload,
    required this.onVoice,
    required this.webSearchEnabled,
    required this.attachment,
    required this.uploading,
    required this.listening,
  });

  static const _navy = Color(0xFF1A365D);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 896),
          child: Column(
            children: [
              if (attachment.value != null) _AttachmentChip(attachment),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: listening ? Colors.red : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (uploading) const LinearProgressIndicator(minHeight: 2),
                    TextField(
                      controller: controller,
                      focusNode: focusNode,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Describe tu caso...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.paperclip, size: 20),
                            onPressed: onUpload,
                            tooltip: 'Adjuntar',
                          ),
                          IconButton(
                            icon: Icon(
                              listening ? LucideIcons.micOff : LucideIcons.mic,
                              size: 20,
                              color: listening ? Colors.red : null,
                            ),
                            onPressed: onVoice,
                            tooltip: 'Dictar',
                          ),
                          const Gap(8),
                          FilterChip(
                            label: const Text(
                              'Web',
                              style: TextStyle(fontSize: 12),
                            ),
                            selected: webSearchEnabled.value,
                            onSelected: (value) =>
                                webSearchEnabled.value = value,
                            checkmarkColor: _navy,
                            selectedColor: Colors.blue.shade50,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(LucideIcons.send, color: _navy),
                            onPressed: onSend,
                            tooltip: 'Enviar',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentChip extends StatelessWidget {
  final ValueNotifier<PlatformFile?> attachment;

  const _AttachmentChip(this.attachment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Chip(
        label: Text(
          attachment.value!.name,
          style: const TextStyle(fontSize: 12),
        ),
        onDeleted: () => attachment.value = null,
        deleteIconColor: Colors.red,
      ),
    );
  }
}
