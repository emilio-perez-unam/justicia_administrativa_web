class BlogPost {
  final String id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String category;
  final List<String> tags;
  final String imageUrl;
  final String authorName;
  final String authorRole;
  final String authorBio;
  final String authorImageUrl;
  final int readMinutes;
  final int viewsCount;
  final int commentsCount;
  final bool isFeatured;
  final bool isPublished;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;

  const BlogPost({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.tags,
    required this.imageUrl,
    required this.authorName,
    required this.authorRole,
    required this.authorBio,
    required this.authorImageUrl,
    required this.readMinutes,
    required this.viewsCount,
    required this.commentsCount,
    required this.isFeatured,
    required this.isPublished,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  bool get isDraft => !isPublished;

  BlogPost copyWith({
    String? id,
    String? title,
    String? slug,
    String? excerpt,
    String? content,
    String? category,
    List<String>? tags,
    String? imageUrl,
    String? authorName,
    String? authorRole,
    String? authorBio,
    String? authorImageUrl,
    int? readMinutes,
    int? viewsCount,
    int? commentsCount,
    bool? isFeatured,
    bool? isPublished,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return BlogPost(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      excerpt: excerpt ?? this.excerpt,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorBio: authorBio ?? this.authorBio,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      readMinutes: readMinutes ?? this.readMinutes,
      viewsCount: viewsCount ?? this.viewsCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isFeatured: isFeatured ?? this.isFeatured,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value, DateTime fallback) {
      if (value is String && value.isNotEmpty) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      return fallback;
    }

    final now = DateTime.now();
    return BlogPost(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      excerpt: (json['excerpt'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      tags: _parseTags(json['tags']),
      imageUrl: (json['image_url'] ?? '').toString(),
      authorName: (json['author_name'] ?? '').toString(),
      authorRole: (json['author_role'] ?? '').toString(),
      authorBio: (json['author_bio'] ?? '').toString(),
      authorImageUrl: (json['author_image_url'] ?? '').toString(),
      readMinutes: (json['read_minutes'] as num?)?.toInt() ?? 1,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      isPublished: json['is_published'] as bool? ?? false,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.tryParse(json['published_at'].toString()),
      createdAt: parseDate(json['created_at'], now),
      updatedAt: parseDate(json['updated_at'], now),
      createdBy: json['created_by']?.toString(),
    );
  }

  static List<String> _parseTags(dynamic value) {
    if (value is List) {
      return value
          .whereType<Object>()
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
    }
    if (value is String && value.trim().isNotEmpty) {
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
    }
    return const <String>[];
  }
}

class BlogPostDraftInput {
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String category;
  final List<String> tags;
  final String imageUrl;
  final String authorName;
  final String authorRole;
  final String authorBio;
  final String authorImageUrl;
  final bool isFeatured;
  final bool isPublished;

  const BlogPostDraftInput({
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.tags,
    required this.imageUrl,
    required this.authorName,
    required this.authorRole,
    required this.authorBio,
    required this.authorImageUrl,
    required this.isFeatured,
    required this.isPublished,
  });
}
