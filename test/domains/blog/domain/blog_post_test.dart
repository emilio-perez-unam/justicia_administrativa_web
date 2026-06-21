import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domains/blog/domain/blog_post.dart';

void main() {
  group('BlogPost domain model', () {
    test('parses database rows without leaking the model through core', () {
      final post = BlogPost.fromJson({
        'id': 'post-1',
        'title': 'Derecho administrativo digital',
        'slug': 'derecho-administrativo-digital',
        'excerpt': 'Una lectura breve',
        'content': 'Contenido del artículo',
        'category': 'Derecho Administrativo',
        'tags': ['IA', 'Procedimiento'],
        'image_url': '',
        'author_name': 'JusticIA Administrativa',
        'author_role': 'Equipo editorial',
        'author_bio': 'Especialistas en derecho administrativo',
        'author_image_url': '',
        'read_minutes': 4,
        'views_count': 12,
        'comments_count': 3,
        'is_featured': true,
        'is_published': true,
        'published_at': '2026-06-01T12:00:00.000Z',
        'created_at': '2026-05-31T12:00:00.000Z',
        'updated_at': '2026-06-02T12:00:00.000Z',
        'created_by': 'editor-1',
      });

      expect(post.id, 'post-1');
      expect(post.slug, 'derecho-administrativo-digital');
      expect(post.tags, ['IA', 'Procedimiento']);
      expect(post.isFeatured, isTrue);
      expect(post.isDraft, isFalse);
      expect(post.publishedAt, DateTime.parse('2026-06-01T12:00:00.000Z'));
    });

    test('normalizes comma-separated tags from legacy payloads', () {
      final post = _postFromJson(tags: 'IA, Tribunal, , Procedimiento');

      expect(post.tags, ['IA', 'Tribunal', 'Procedimiento']);
    });

    test(
      'copyWith preserves existing values and applies requested changes',
      () {
        final original = _postFromJson();

        final changed = original.copyWith(
          title: 'Nuevo título',
          isPublished: true,
        );

        expect(changed.id, original.id);
        expect(changed.slug, original.slug);
        expect(changed.title, 'Nuevo título');
        expect(changed.isPublished, isTrue);
        expect(changed.isDraft, isFalse);
      },
    );
  });
}

BlogPost _postFromJson({Object? tags = const ['IA']}) {
  return BlogPost.fromJson({
    'id': 'post-1',
    'title': 'Título',
    'slug': 'titulo',
    'excerpt': 'Extracto',
    'content': 'Contenido',
    'category': 'Categoría',
    'tags': tags,
    'image_url': '',
    'author_name': 'Autor',
    'author_role': 'Rol',
    'author_bio': '',
    'author_image_url': '',
    'read_minutes': 2,
    'views_count': 0,
    'comments_count': 0,
    'is_featured': false,
    'is_published': false,
    'published_at': null,
    'created_at': '2026-06-01T12:00:00.000Z',
    'updated_at': '2026-06-01T12:00:00.000Z',
    'created_by': 'editor-1',
  });
}
