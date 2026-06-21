import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Document {
  final String id;
  final String? matterId;
  final String clientId;
  final String name;
  final String? fileUrl;
  final int? fileSize;
  final String? mimeType;
  final DocumentCategory category;
  final DateTime createdAt;

  const Document({
    required this.id,
    this.matterId,
    required this.clientId,
    required this.name,
    this.fileUrl,
    this.fileSize,
    this.mimeType,
    required this.category,
    required this.createdAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      matterId: json['matter_id'] as String?,
      clientId: json['client_id'] as String,
      name: json['name'] as String,
      fileUrl: json['file_url'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      mimeType: json['mime_type'] as String?,
      category: DocumentCategory.fromDb(json['category'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

enum DocumentCategory {
  contrato('contrato', 'Contrato', LucideIcons.fileSignature),
  demanda('demanda', 'Demanda', LucideIcons.gavel),
  resolucion('resolucion', 'Resolución', LucideIcons.fileCheck),
  evidencia('evidencia', 'Evidencia', LucideIcons.image),
  factura('factura', 'Factura', LucideIcons.receipt),
  otro('otro', 'Otro', LucideIcons.file);

  final String dbValue;
  final String displayName;
  final IconData icon;

  const DocumentCategory(this.dbValue, this.displayName, this.icon);

  static DocumentCategory fromDb(String value) =>
      DocumentCategory.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => DocumentCategory.otro,
      );
}
