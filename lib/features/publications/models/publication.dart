import 'package:flutter/material.dart';

// Using a shared Author model structure. In a larger app, this might be moved
// to a shared models directory.
class Author {
  final String name;
  final String title;
  final String imageUrl;

  const Author({
    required this.name,
    required this.title,
    required this.imageUrl,
  });
}

class Publication {
  final String id;
  final String title;
  final String excerpt;
  final Author author;
  final String category;
  final Color categoryColor;
  final DateTime publishedDate;
  final String type; // e.g., 'Artículo', 'Libro', 'Opinión'
  final String? pdfUrl;
  final bool isFeatured;
  final String? featuredImage;
  final int readTimeInMinutes;

  const Publication({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.author,
    required this.category,
    required this.categoryColor,
    required this.publishedDate,
    required this.type,
    this.pdfUrl,
    this.isFeatured = false,
    this.featuredImage,
    required this.readTimeInMinutes,
  });
}
