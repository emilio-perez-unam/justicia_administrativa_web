// Renders the AI assistant message transcript and typing state.

import 'package:flutter/material.dart';

import '../../../../core/models/message.dart';
import '../chat_message.dart';
import 'chat_empty_state.dart';

/// Scrollable transcript for the AI assistant conversation.
class ChatMessageList extends StatelessWidget {
  final List<Message> messages;
  final bool isLoading;
  final bool isTyping;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.isTyping,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (messages.isEmpty) {
      return const ChatEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ).copyWith(bottom: 80),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < messages.length) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 896),
              child: ChatMessage(message: messages[index]),
            ),
          );
        }
        return const _TypingIndicator();
      },
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 896),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'JusticIA está analizando...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
