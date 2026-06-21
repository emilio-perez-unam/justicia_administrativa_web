import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../router.dart';
import '../../../core/models/message.dart';

const _navy = Color(0xFF1A365D);
const _gold = Color(0xFFD69E2E);

class ChatMessage extends StatefulWidget {
  final Message message;
  const ChatMessage({super.key, required this.message});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  bool _showSources = true;

  Message get msg => widget.message;
  bool get isUser => msg.role == 'user';
  bool get hasSources =>
      !isUser && msg.sources != null && msg.sources!.isNotEmpty;

  String _getInitials() {
    final name = AppRouter.authNotifier.displayName;
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (isUser) ...[
            Flexible(child: _buildContent()),
            const SizedBox(width: 16),
            _buildUserAvatar(),
          ] else ...[
            _buildAssistantAvatar(),
            const SizedBox(width: 16),
            Flexible(child: _buildContent()),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        _getInitials(),
        style: const TextStyle(
          color: _navy,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAssistantAvatar() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/brand/001-logo-primary.jpg',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [_buildHeader(), const SizedBox(height: 4), _buildBubble()],
    );
  }

  Widget _buildHeader() {
    return Opacity(
      opacity: 0.6,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isUser ? AppRouter.authNotifier.displayName : 'JusticIA',
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' \u2022 ${msg.timestamp}',
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isUser ? _navy : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
        border: isUser ? null : Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: msg.content,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                color: isUser ? Colors.white : const Color(0xFF334155),
                fontSize: 15,
                height: 1.6,
              ),
              h1: TextStyle(
                color: isUser ? Colors.white : _navy,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              h2: TextStyle(
                color: isUser ? Colors.white : _navy,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              h3: TextStyle(
                color: isUser ? Colors.white : _navy,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              listBullet: TextStyle(color: isUser ? Colors.white70 : _navy),
              strong: const TextStyle(fontWeight: FontWeight.bold),
              blockquote: TextStyle(
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
              blockquoteDecoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border(left: BorderSide(color: _gold, width: 4)),
              ),
            ),
          ),
          if (hasSources) _buildSourcesSection(),
        ],
      ),
    );
  }

  Widget _buildSourcesSection() {
    final sources = msg.sources!;
    return Column(
      children: [
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => setState(() => _showSources = !_showSources),
          child: Row(
            children: [
              const Icon(LucideIcons.scale, size: 14, color: _navy),
              const SizedBox(width: 8),
              Text(
                'Fuentes Consultadas (${sources.length})',
                style: const TextStyle(
                  color: _navy,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(
                _showSources ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        if (_showSources) ...[
          const SizedBox(height: 16),
          ...sources.map((s) => _SourceCard(source: s)),
        ],
      ],
    );
  }
}

class _SourceCard extends StatelessWidget {
  final Source source;
  const _SourceCard({required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.landmark,
                size: 14,
                color: Colors.blueGrey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  source.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Relevancia: ${source.relevance}%',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
