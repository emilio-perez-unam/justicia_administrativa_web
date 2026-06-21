// Composes the active message thread, message list, and composer.

import 'package:flutter/material.dart';

import '../../../../core/models/matter.dart';
import '../../../../core/models/portal_message.dart';
import '../../../../core/presentation/future_result_view.dart';
import '../../../../core/presentation/states/app_empty_state.dart';
import 'message_bubble.dart';
import 'messages_composer.dart';
import 'messages_thread_header.dart';

/// Active conversation panel for a selected matter.
class MessagesThreadPanel extends StatelessWidget {
  /// Loader for the matters list — passed down to the thread header.
  final Future<List<Matter>> Function() mattersLoader;

  /// Loader for the messages in the selected thread.  Nullable so the panel
  /// can be shown before a matter is selected.
  final Future<List<PortalMessage>> Function()? messagesLoader;
  final String selectedMatterId;
  final String? currentUserId;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final VoidCallback onSendMessage;
  final VoidCallback onStartVoiceCall;
  final VoidCallback onStartVideoCall;
  final VoidCallback onPickAttachment;
  final VoidCallback onClearAttachment;
  final String? pendingAttachmentName;
  final bool isUploadingAttachment;

  const MessagesThreadPanel({
    super.key,
    required this.mattersLoader,
    required this.messagesLoader,
    required this.selectedMatterId,
    required this.currentUserId,
    required this.messageController,
    required this.scrollController,
    required this.onSendMessage,
    required this.onStartVoiceCall,
    required this.onStartVideoCall,
    required this.onPickAttachment,
    required this.onClearAttachment,
    this.pendingAttachmentName,
    this.isUploadingAttachment = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MessagesThreadHeader(
          mattersLoader: mattersLoader,
          selectedMatterId: selectedMatterId,
          onStartVoiceCall: onStartVoiceCall,
          onStartVideoCall: onStartVideoCall,
        ),
        const Divider(height: 1),
        Expanded(
          child: messagesLoader == null
              ? const Center(child: CircularProgressIndicator())
              : FutureResultView<List<PortalMessage>>(
                  loader: messagesLoader!,
                  builder: (context, messages) {
                    if (messages.isEmpty) {
                      return const AppEmptyState(
                        message: 'No hay mensajes en esta conversación.',
                      );
                    }
                    final reversed = messages.reversed.toList();
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      itemCount: reversed.length,
                      itemBuilder: (context, index) {
                        final message = reversed[index];
                        return MessageBubble(
                          message: message,
                          isMe: message.senderId == currentUserId,
                        );
                      },
                    );
                  },
                ),
        ),
        MessagesComposer(
          controller: messageController,
          onSendMessage: onSendMessage,
          onPickAttachment: onPickAttachment,
          onClearAttachment: onClearAttachment,
          pendingAttachmentName: pendingAttachmentName,
          isUploading: isUploadingAttachment,
        ),
      ],
    );
  }
}
