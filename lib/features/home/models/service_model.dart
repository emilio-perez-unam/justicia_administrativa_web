// TODO Implement this library.
// lib/features/home/models/service_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel {
  const ServiceModel._();
  
  const factory ServiceModel({
    required String id,
    required String title,
    required String description,
    required String icon,
    required List<String> features,
    required String route,
    String? imageUrl,
    @Default(0) int order,
    @Default(true) bool isActive,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);
  
  // Helper to get IconData from string
  IconData get iconData {
    switch (icon) {
      case 'smart_toy':
        return Icons.smart_toy_outlined;
      case 'transform':
        return Icons.transform_outlined;
      case 'gavel':
        return Icons.gavel_outlined;
      case 'public':
        return Icons.public_outlined;
      case 'account_balance':
        return Icons.account_balance_outlined;
      case 'cases':
        return Icons.cases_outlined;
      case 'school':
        return Icons.school_outlined;
      default:
        return Icons.business_center_outlined;
    }
  }
}