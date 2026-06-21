import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/domains/auth/domain/value_objects/password.dart';

void main() {
  group('Password value object', () {
    group('create — valid inputs', () {
      test('accepts a password of exactly 8 characters', () {
        final result = Password.create('12345678');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, '12345678');
      });

      test('accepts a password longer than 8 characters', () {
        final result = Password.create('securePass99!');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'securePass99!');
      });

      test('trims leading and trailing whitespace', () {
        final result = Password.create('  mypassword  ');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'mypassword');
      });

      test('accepts password with exactly 8 chars after trimming', () {
        // "  pass1234  " trims to "pass1234" which is exactly 8 chars.
        final result = Password.create('  pass1234  ');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'pass1234');
      });
    });

    group('create — invalid inputs', () {
      test('rejects an empty string', () {
        final result = Password.create('');
        expect(result.isErr, isTrue);
        result.fold((_) => fail('Expected Err'), (f) {
          expect(f, isA<ValidationFailure>());
          expect(f.message, 'La contraseña debe tener al menos 8 caracteres.');
        });
      });

      test('rejects a password shorter than 8 characters', () {
        final result = Password.create('short');
        expect(result.isErr, isTrue);
        result.fold(
          (_) => fail('Expected Err'),
          (f) => expect(f, isA<ValidationFailure>()),
        );
      });

      test('rejects a 7-character password', () {
        final result = Password.create('1234567');
        expect(result.isErr, isTrue);
      });

      test('rejects whitespace-only string', () {
        final result = Password.create('        ');
        expect(result.isErr, isTrue);
      });

      test('rejects string that is only 7 chars after trimming', () {
        final result = Password.create('  abc12  ');
        expect(result.isErr, isTrue);
      });
    });

    group('equality and hash', () {
      test('two Passwords with same value are equal', () {
        final a = Password.create('securePass').valueOrNull!;
        final b = Password.create('securePass').valueOrNull!;
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('two Passwords with different values are not equal', () {
        final a = Password.create('password1').valueOrNull!;
        final b = Password.create('password2').valueOrNull!;
        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('does not expose the raw password', () {
        final pwd = Password.create('supersecret').valueOrNull!;
        expect(pwd.toString(), contains('****'));
        expect(pwd.toString(), isNot(contains('supersecret')));
      });
    });
  });
}
