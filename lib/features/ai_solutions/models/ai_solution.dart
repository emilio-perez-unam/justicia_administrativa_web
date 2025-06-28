import 'package:flutter/material.dart';

class AiSolution {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;
  final String demoImageAsset;
  final List<String> supportedFormats;
  final String callToAction;

  const AiSolution({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
    required this.demoImageAsset,
    required this.supportedFormats,
    required this.callToAction,
  });
}
