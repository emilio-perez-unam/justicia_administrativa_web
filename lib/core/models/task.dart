import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final String? assignedTo;
  final String assigneeName;
  final String? createdBy;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.status,
    this.assignedTo,
    required this.assigneeName,
    this.createdBy,
    this.dueDate,
    this.completedAt,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: TaskPriority.fromDb(json['priority'] as String),
      status: TaskStatus.fromDb(json['status'] as String),
      assignedTo: json['assigned_to'] as String?,
      assigneeName: json['assignee_name'] as String,
      createdBy: json['created_by'] as String?,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      category: json['category'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  bool get isOverdue =>
      dueDate != null &&
      dueDate!.isBefore(DateTime.now()) &&
      status != TaskStatus.completada &&
      status != TaskStatus.cancelada;
}

enum TaskPriority {
  alta('alta', 'Alta', Color(0xFFDC2626), Color(0xFFFEF2F2)),
  media('media', 'Media', Color(0xFFD97706), Color(0xFFFFFBEB)),
  baja('baja', 'Baja', Color(0xFF16A34A), Color(0xFFF0FDF4));

  final String dbValue;
  final String displayName;
  final Color textColor;
  final Color bgColor;

  const TaskPriority(
    this.dbValue,
    this.displayName,
    this.textColor,
    this.bgColor,
  );

  static TaskPriority fromDb(String value) => TaskPriority.values.firstWhere(
    (e) => e.dbValue == value,
    orElse: () => TaskPriority.media,
  );
}

enum TaskStatus {
  pendiente('pendiente', 'Pendiente', Color(0xFFD97706), Color(0xFFFFFBEB)),
  enProgreso(
    'en_progreso',
    'En progreso',
    Color(0xFF2563EB),
    Color(0xFFEFF6FF),
  ),
  completada('completada', 'Completada', Color(0xFF16A34A), Color(0xFFF0FDF4)),
  cancelada('cancelada', 'Cancelada', Color(0xFF6B7280), Color(0xFFF3F4F6));

  final String dbValue;
  final String displayName;
  final Color textColor;
  final Color bgColor;

  const TaskStatus(
    this.dbValue,
    this.displayName,
    this.textColor,
    this.bgColor,
  );

  static TaskStatus fromDb(String value) => TaskStatus.values.firstWhere(
    (e) => e.dbValue == value,
    orElse: () => TaskStatus.pendiente,
  );
}
