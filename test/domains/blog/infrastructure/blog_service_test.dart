import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domains/blog/infrastructure/blog_service.dart';

void main() {
  group('BlogService infrastructure helpers', () {
    test('slugify preserves existing production slug behavior', () {
      expect(
        BlogService.slugify('IA y Transformación del Derecho Administrativo'),
        'ia-y-transformacion-del-derecho-administrativo',
      );
      expect(
        BlogService.slugify('  Expediente   Digital  '),
        'expediente-digital',
      );
      expect(BlogService.slugify(''), startsWith('entrada-'));
    });

    test('parseTags trims blanks and removes duplicates', () {
      expect(BlogService.parseTags('IA, Tribunal, IA, , Procedimiento'), [
        'IA',
        'Tribunal',
        'Procedimiento',
      ]);
    });

    test('estimateReadMinutes has the same one-minute lower bound', () {
      expect(BlogService.estimateReadMinutes(''), 1);
      expect(BlogService.estimateReadMinutes('palabra ' * 221), 2);
    });
  });
}
