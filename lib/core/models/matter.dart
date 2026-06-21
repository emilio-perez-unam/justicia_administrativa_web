import 'package:flutter/material.dart';

class Matter {
  final String id;
  final String clientId;
  final String? lawyerId;
  final String referenceCode;
  final String title;
  final String? subtitle;
  final MatterType matterType;
  final MatterStatus status;
  final DateTime lastUpdate;
  final DateTime createdAt;
  final String? lawyerName;
  final String? lawyerAvatarUrl;

  const Matter({
    required this.id,
    required this.clientId,
    this.lawyerId,
    required this.referenceCode,
    required this.title,
    this.subtitle,
    required this.matterType,
    required this.status,
    required this.lastUpdate,
    required this.createdAt,
    this.lawyerName,
    this.lawyerAvatarUrl,
  });

  factory Matter.fromJson(Map<String, dynamic> json) {
    final lawyer = json['lawyers'] as Map<String, dynamic>?;
    return Matter(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      lawyerId: json['lawyer_id'] as String?,
      referenceCode: json['reference_code'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      matterType: MatterType.fromDb(json['matter_type']),
      status: MatterStatus.fromDb(json['status']),
      lastUpdate: DateTime.parse(json['last_update'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      lawyerName: lawyer != null
          ? '${lawyer['title']} ${lawyer['full_name']}'
          : null,
      lawyerAvatarUrl: lawyer?['avatar_url'] as String?,
    );
  }
}

enum MatterType {
  amparo('amparo', 'Amparo', Color(0xFF1E40AF), Color(0xFFDBEAFE)),
  licitacion('licitacion', 'Licitación', Color(0xFF7C3AED), Color(0xFFEDE9FE)),
  compliance('compliance', 'Compliance', Color(0xFF0D9488), Color(0xFFF0FDFA)),
  consulta('consulta', 'Consulta', Color(0xFF059669), Color(0xFFECFDF5)),
  litigio('litigio', 'Litigio', Color(0xFFDC2626), Color(0xFFFEF2F2));

  final String dbValue;
  final String displayName;
  final Color textColor;
  final Color bgColor;

  const MatterType(
    this.dbValue,
    this.displayName,
    this.textColor,
    this.bgColor,
  );

  static MatterType fromDb(dynamic value) => MatterType.values.firstWhere(
    (e) => e.dbValue == value.toString(),
    orElse: () => MatterType.consulta,
  );
}

enum MatterStatus {
  enProceso('en_proceso', 'En proceso', Color(0xFF15803D), Color(0xFFDCFCE7)),
  revision('revision', 'Revisión', Color(0xFFB45309), Color(0xFFFEF3C7)),
  completado('completado', 'Completado', Color(0xFF1E40AF), Color(0xFFDBEAFE)),
  suspendido('suspendido', 'Suspendido', Color(0xFF6B7280), Color(0xFFF3F4F6)),
  archivado('archivado', 'Archivado', Color(0xFF6B7280), Color(0xFFF3F4F6));

  final String dbValue;
  final String displayName;
  final Color textColor;
  final Color bgColor;

  const MatterStatus(
    this.dbValue,
    this.displayName,
    this.textColor,
    this.bgColor,
  );

  static MatterStatus fromDb(dynamic value) => MatterStatus.values.firstWhere(
    (e) => e.dbValue == value.toString(),
    orElse: () => MatterStatus.enProceso,
  );
}
