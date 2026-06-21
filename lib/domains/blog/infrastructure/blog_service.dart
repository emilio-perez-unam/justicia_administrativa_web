import 'dart:math' as math;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/blog_post.dart';

class BlogService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const String _table = 'blog_posts';

  static String? get _userId => _client.auth.currentUser?.id;

  static Future<List<BlogPost>> getPublishedPosts() async {
    final data = await _client
        .from(_table)
        .select()
        .eq('is_published', true)
        .order('published_at', ascending: false)
        .order('created_at', ascending: false);

    return (data as List<dynamic>)
        .map((row) => BlogPost.fromJson(row as Map<String, dynamic>))
        .toList(growable: false);
  }

  static Future<List<BlogPost>> getAllPosts() async {
    final data = await _client
        .from(_table)
        .select()
        .order('updated_at', ascending: false)
        .order('created_at', ascending: false);

    return (data as List<dynamic>)
        .map((row) => BlogPost.fromJson(row as Map<String, dynamic>))
        .toList(growable: false);
  }

  static Future<BlogPost> createPost(BlogPostDraftInput input) async {
    final userId = _userId;
    if (userId == null) {
      throw Exception('Debe iniciar sesión para crear entradas.');
    }

    final payload = _payloadFromInput(
      input,
      createdBy: userId,
      previousPublishedAt: null,
    );

    final row = await _client.from(_table).insert(payload).select().single();
    return BlogPost.fromJson(row);
  }

  static Future<BlogPost> updatePost({
    required String id,
    required BlogPostDraftInput input,
    DateTime? previousPublishedAt,
  }) async {
    final payload = _payloadFromInput(
      input,
      createdBy: null,
      previousPublishedAt: previousPublishedAt,
    )..['updated_at'] = DateTime.now().toIso8601String();

    final row = await _client
        .from(_table)
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return BlogPost.fromJson(row);
  }

  static Future<BlogPost> setPublished({
    required String id,
    required bool isPublished,
  }) async {
    final nowIso = DateTime.now().toIso8601String();
    final row = await _client
        .from(_table)
        .update({
          'is_published': isPublished,
          'published_at': isPublished ? nowIso : null,
          'updated_at': nowIso,
        })
        .eq('id', id)
        .select()
        .single();
    return BlogPost.fromJson(row);
  }

  static Future<BlogPost> setFeatured({
    required String id,
    required bool isFeatured,
  }) async {
    final row = await _client
        .from(_table)
        .update({
          'is_featured': isFeatured,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .select()
        .single();
    return BlogPost.fromJson(row);
  }

  static Future<void> deletePost(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }

  static int estimateReadMinutes(String content) {
    final normalized = content.trim();
    if (normalized.isEmpty) return 1;
    final words = normalized.split(RegExp(r'\s+')).length;
    return math.max(1, (words / 220).ceil());
  }

  static String slugify(String value) {
    final lower = _removeAccents(value.trim().toLowerCase());
    final collapsed = lower
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-{2,}'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    if (collapsed.isNotEmpty) return collapsed;
    return 'entrada-${DateTime.now().millisecondsSinceEpoch}';
  }

  static List<String> parseTags(String value) {
    final unique = <String>{};
    for (final raw in value.split(',')) {
      final tag = raw.trim();
      if (tag.isNotEmpty) unique.add(tag);
    }
    return unique.toList(growable: false);
  }

  static Map<String, dynamic> _payloadFromInput(
    BlogPostDraftInput input, {
    required String? createdBy,
    required DateTime? previousPublishedAt,
  }) {
    final now = DateTime.now();
    final nowIso = now.toIso8601String();
    final shouldSetPublishedAt =
        input.isPublished && previousPublishedAt == null;

    final payload = <String, dynamic>{
      'title': input.title.trim(),
      'slug': slugify(input.slug.isEmpty ? input.title : input.slug),
      'excerpt': input.excerpt.trim(),
      'content': input.content.trim(),
      'category': input.category.trim(),
      'tags': input.tags,
      'image_url': input.imageUrl.trim(),
      'author_name': input.authorName.trim(),
      'author_role': input.authorRole.trim(),
      'author_bio': input.authorBio.trim(),
      'author_image_url': input.authorImageUrl.trim(),
      'read_minutes': estimateReadMinutes(input.content),
      'is_featured': input.isFeatured,
      'is_published': input.isPublished,
      'published_at': input.isPublished
          ? (shouldSetPublishedAt
                ? nowIso
                : previousPublishedAt?.toIso8601String())
          : null,
      'updated_at': nowIso,
    };

    if (createdBy != null) {
      payload['created_by'] = createdBy;
      payload['created_at'] = nowIso;
    }
    return payload;
  }

  static String _removeAccents(String input) {
    const replacements = <String, String>{
      'á': 'a',
      'à': 'a',
      'ä': 'a',
      'â': 'a',
      'ã': 'a',
      'é': 'e',
      'è': 'e',
      'ë': 'e',
      'ê': 'e',
      'í': 'i',
      'ì': 'i',
      'ï': 'i',
      'î': 'i',
      'ó': 'o',
      'ò': 'o',
      'ö': 'o',
      'ô': 'o',
      'õ': 'o',
      'ú': 'u',
      'ù': 'u',
      'ü': 'u',
      'û': 'u',
      'ñ': 'n',
      'ç': 'c',
    };

    final buffer = StringBuffer();
    for (final code in input.runes) {
      final char = String.fromCharCode(code);
      buffer.write(replacements[char] ?? char);
    }
    return buffer.toString();
  }
}
