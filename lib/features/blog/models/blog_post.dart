import 'package:flutter/material.dart';

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

class BlogPost {
  final String id;
  final String title;
  final String excerpt;
  final String imageUrl;
  final Author author;
  final String category;
  final Color categoryColor;
  final DateTime publishedDate;
  final int readTime;
  final int viewCount;
  final int commentCount;
  final bool isFeatured;

  const BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.author,
    required this.category,
    required this.categoryColor,
    required this.publishedDate,
    required this.readTime,
    required this.viewCount,
    required this.commentCount,
    this.isFeatured = false,
  });
}
