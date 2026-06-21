import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/email_address.dart';

void main() {
  group('EmailAddress.create', () {
    group('valid inputs', () {
      test('accepts a well-formed email', () {
        final result = EmailAddress.create('usuario@example.com');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'usuario@example.com');
      });

      test('trims surrounding whitespace before validating', () {
        final result = EmailAddress.create('  a@b.com  ');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'a@b.com');
      });

      test('accepts subdomain email', () {
        final result = EmailAddress.create('user@mail.domain.org');
        expect(result.isOk, isTrue);
      });
    });

    group('invalid inputs', () {
      test('rejects empty string', () {
        final result = EmailAddress.create('');
        expect(result.isErr, isTrue);
        result.fold((_) => fail('Should be Err'), (f) {
          expect(f, isA<ValidationFailure>());
          expect(f.message, 'Ingrese un correo válido.');
        });
      });

      test('rejects whitespace-only string', () {
        final result = EmailAddress.create('   ');
        expect(result.isErr, isTrue);
        final failure = (result as Err).failure;
        expect(failure, isA<ValidationFailure>());
      });

      test('rejects string without @', () {
        final result = EmailAddress.create('notanemail');
        expect(result.isErr, isTrue);
        expect((result as Err).failure.message, 'Ingrese un correo válido.');
      });

      test('rejects string with @ but no domain', () {
        final result = EmailAddress.create('user@');
        expect(result.isErr, isTrue);
      });

      test('rejects string with only @domain', () {
        final result = EmailAddress.create('@domain.com');
        expect(result.isErr, isTrue);
      });
    });

    group('value equality', () {
      test('two EmailAddress with same value are equal', () {
        final a = EmailAddress.create('a@b.com').valueOrNull!;
        final b = EmailAddress.create('a@b.com').valueOrNull!;
        expect(a, equals(b));
      });

      test('two EmailAddress with different values are not equal', () {
        final a = EmailAddress.create('a@b.com').valueOrNull!;
        final b = EmailAddress.create('c@d.com').valueOrNull!;
        expect(a, isNot(equals(b)));
      });

      test('hashCode is consistent with equality', () {
        final a = EmailAddress.create('a@b.com').valueOrNull!;
        final b = EmailAddress.create('a@b.com').valueOrNull!;
        expect(a.hashCode, equals(b.hashCode));
      });
    });
  });
}
