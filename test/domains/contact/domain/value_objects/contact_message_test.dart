import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/contact_message.dart';

void main() {
  group('ContactMessage.create', () {
    group('valid inputs', () {
      test('accepts non-empty message', () {
        final result = ContactMessage.create('Hola, necesito ayuda legal.');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'Hola, necesito ayuda legal.');
      });

      test('trims surrounding whitespace', () {
        final result = ContactMessage.create('  Mensaje  ');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'Mensaje');
      });

      test('accepts message at exactly 5000 characters', () {
        final msg = 'A' * 5000;
        final result = ContactMessage.create(msg);
        expect(result.isOk, isTrue);
      });
    });

    group('invalid inputs', () {
      test('rejects empty string', () {
        final result = ContactMessage.create('');
        expect(result.isErr, isTrue);
        result.fold((_) => fail('Should be Err'), (f) {
          expect(f, isA<ValidationFailure>());
          expect(f.message, 'El mensaje es obligatorio.');
        });
      });

      test('rejects whitespace-only string', () {
        final result = ContactMessage.create('   ');
        expect(result.isErr, isTrue);
        final failure = (result as Err).failure;
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'El mensaje es obligatorio.');
      });

      test('rejects message exceeding 5000 characters', () {
        final msg = 'A' * 5001;
        final result = ContactMessage.create(msg);
        expect(result.isErr, isTrue);
        final failure = (result as Err).failure;
        expect(failure, isA<ValidationFailure>());
      });
    });

    group('value equality', () {
      test('two ContactMessage with same value are equal', () {
        final a = ContactMessage.create('hola').valueOrNull!;
        final b = ContactMessage.create('hola').valueOrNull!;
        expect(a, equals(b));
      });

      test('two ContactMessage with different values are not equal', () {
        final a = ContactMessage.create('hola').valueOrNull!;
        final b = ContactMessage.create('adios').valueOrNull!;
        expect(a, isNot(equals(b)));
      });

      test('hashCode is consistent with equality', () {
        final a = ContactMessage.create('texto').valueOrNull!;
        final b = ContactMessage.create('texto').valueOrNull!;
        expect(a.hashCode, equals(b.hashCode));
      });
    });
  });
}
