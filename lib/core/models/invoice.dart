import 'package:flutter/material.dart';

class Invoice {
  final String id;
  final String clientId;
  final String? matterId;
  final String invoiceNumber;
  final String? description;
  final double amount;
  final String currency;
  final InvoiceStatus status;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final String? fileUrl;
  final DateTime createdAt;

  const Invoice({
    required this.id,
    required this.clientId,
    this.matterId,
    required this.invoiceNumber,
    this.description,
    required this.amount,
    required this.currency,
    required this.status,
    this.dueDate,
    this.paidAt,
    this.fileUrl,
    required this.createdAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      matterId: json['matter_id'] as String?,
      invoiceNumber: json['invoice_number'] as String,
      description: json['description'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: InvoiceStatus.fromDb(json['status'] as String),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      fileUrl: json['file_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

enum InvoiceStatus {
  pendiente('pendiente', 'Pendiente', Color(0xFFD97706), Color(0xFFFFFBEB)),
  pagada('pagada', 'Pagada', Color(0xFF16A34A), Color(0xFFF0FDF4)),
  vencida('vencida', 'Vencida', Color(0xFFDC2626), Color(0xFFFEF2F2)),
  cancelada('cancelada', 'Cancelada', Color(0xFF6B7280), Color(0xFFF3F4F6));

  final String dbValue;
  final String displayName;
  final Color textColor;
  final Color bgColor;

  const InvoiceStatus(
    this.dbValue,
    this.displayName,
    this.textColor,
    this.bgColor,
  );

  static InvoiceStatus fromDb(String value) => InvoiceStatus.values.firstWhere(
    (e) => e.dbValue == value,
    orElse: () => InvoiceStatus.pendiente,
  );
}
