import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class SidebarRight extends StatelessWidget {
  final List<dynamic> sources;

  const SidebarRight({super.key, this.sources = const []});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1A365D);

    return Container(
      width: 280,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.bookOpen, color: navy, size: 18),
                SizedBox(width: 10),
                Text(
                  'Fuentes y Contexto',
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: sources.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildSectionHeader('DOCUMENTOS DE SESIÓN'),
                      ...sources
                          .where(
                            (s) => s['source'].toString().contains(
                              'chat-attachments',
                            ),
                          )
                          .map((s) => _SourceCard(source: s)),

                      const SizedBox(height: 24),
                      _buildSectionHeader('CORPUS LEGAL GLOBAL'),
                      ...sources
                          .where(
                            (s) => !s['source'].toString().contains(
                              'chat-attachments',
                            ),
                          )
                          .map((s) => _SourceCard(source: s)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.fileSearch, color: Colors.grey.shade200, size: 48),
            const SizedBox(height: 16),
            const Text(
              'No hay fuentes activas',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Las referencias de los documentos aparecerán aquí al conversar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final dynamic source;
  const _SourceCard({required this.source});

  @override
  Widget build(BuildContext context) {
    final title =
        source['title'] ?? source['source'].toString().split('/').last;
    final relevance = source['relevance'] ?? 0;
    final isSession = source['source'].toString().contains('chat-attachments');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSession ? const Color(0xFFF0F9FF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSession ? const Color(0xFFBAE6FD) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSession ? LucideIcons.fileText : LucideIcons.landmark,
                size: 14,
                color: isSession ? Colors.blue.shade700 : Colors.blueGrey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Relevancia: $relevance%',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (source['url'] != null && source['url'] != '#')
                GestureDetector(
                  onTap: () => launchUrl(Uri.parse(source['url'])),
                  child: const Icon(
                    LucideIcons.externalLink,
                    size: 12,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
