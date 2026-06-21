import 'package:intl/intl.dart';

class Source {
  final String id;
  final String title;
  final String institution;
  final String date;
  final int relevance;
  final String type; // jurisprudencia | aislada | orientador | web
  final String citation;
  final String? registro;
  final String url;
  final String reliability; // alta | media | verificar

  const Source({
    required this.id,
    required this.title,
    required this.institution,
    required this.date,
    required this.relevance,
    required this.type,
    required this.citation,
    this.registro,
    required this.url,
    required this.reliability,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String? ?? '0',
      title: json['title'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      date: json['date'] as String? ?? '',
      relevance: (json['relevance'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'web',
      citation: json['citation'] as String? ?? '',
      registro: json['registro'] as String?,
      url: json['url'] as String? ?? '',
      reliability: json['reliability'] as String? ?? 'media',
    );
  }
}

class Message {
  final String id;
  final String role; // user | assistant | system
  final String content;
  final DateTime createdAt;
  final List<Source>? sources;
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.sources,
    this.metadata,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>?;
    final sourcesList = meta?['sources'] as List<dynamic>?;

    return Message(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      metadata: meta,
      sources: sourcesList?.map((e) => Source.fromJson(e)).toList(),
    );
  }

  String get timestamp => DateFormat('HH:mm').format(createdAt);
}
