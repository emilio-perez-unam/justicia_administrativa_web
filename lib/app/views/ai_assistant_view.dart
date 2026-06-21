import 'package:flutter/material.dart';
import '../components/ai_assistant/chat_area.dart';
import '../components/ai_assistant/sidebar_right.dart';

class AiAssistantView extends StatefulWidget {
  final String? conversationId;
  final Function(String) onConversationCreated;

  const AiAssistantView({
    super.key,
    this.conversationId,
    required this.onConversationCreated,
  });

  @override
  State<AiAssistantView> createState() => _AiAssistantViewState();
}

class _AiAssistantViewState extends State<AiAssistantView> {
  /// Retrieval sources surfaced by the most recent assistant reply. Lifted to
  /// this view so the chat surface (which produces them) and the right sidebar
  /// (which displays them) stay in sync.
  List<dynamic> _sources = const [];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Container(
      color: const Color(0xFFF8FAFC), // slate-50
      child: Row(
        children: [
          // Main Chat Area
          Expanded(
            child: ChatArea(
              conversationId: widget.conversationId,
              onConversationCreated: widget.onConversationCreated,
              onSourcesUpdated: (sources) {
                if (!mounted) return;
                setState(() => _sources = sources);
              },
            ),
          ),

          // Right sidebar (desktop only)
          if (isDesktop) SidebarRight(sources: _sources),
        ],
      ),
    );
  }
}
