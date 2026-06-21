// Renders a single portal message bubble.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/portal_message.dart';

/// Chat bubble for a portal message or generated call link notice.
class MessageBubble extends StatelessWidget {
  final PortalMessage message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);
    final isCall = message.content.contains('https://meet.jit.si/');

    return Semantics(
      label:
          '${isMe ? 'Mensaje enviado' : 'Mensaje recibido'} a las ${DateFormat('HH:mm').format(message.createdAt)}',
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCall
                ? Colors.amber.shade50
                : (isMe ? navyColor : Colors.grey.shade100),
            border: isCall ? Border.all(color: Colors.amber.shade200) : null,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: isCall
                      ? Colors.amber.shade900
                      : (isMe ? Colors.white : Colors.black87),
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: isCall ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (message.attachmentUrl != null) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse(message.attachmentUrl!),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.paperclip,
                        size: 14,
                        color: isMe ? Colors.white : navyColor,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          message.attachmentName ?? 'Archivo adjunto',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: isMe ? Colors.white : navyColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(message.createdAt),
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.grey.shade500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(),
    );
  }
}
