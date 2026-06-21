import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/person_name.dart';

void main() {
  group('PersonName.create', () {
    group('valid inputs', () {
      test('accepts a non-empty name', () {
        final result = PersonName.create('Ana García');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'Ana García');
      });

      test('trims surrounding whitespace', () {
        final result = PersonName.create('  Juan  ');
        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.value, 'Juan');
      });

      test('accepts a single character name', () {
        final result = PersonName.create('X');
        expect(result.isOk, isTrue);
      });
    });

    group('invalid inputs', () {
      test('rejects empty string', () {
        final result = PersonName.create('');
        expect(result.isErr, isTrue);
        result.fold((_) => fail('Should be Err'), (f) {
          expect(f, isA<ValidationFailure>());
          expect(f.message, 'El nombre es obligatorio.');
        });
      });

      test('rejects whitespace-only string', () {
        final result = PersonName.create('   ');
        expect(result.isErr, isTrue);
        final failure = (result as Err).failure;
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'El nombre es obligatorio.');
      });
    });

    group('value equality', () {
      test('two PersonName with same value are equal', () {
        final a = PersonName.create('Ana').valueOrNull!;
        final b = PersonName.create('Ana').valueOrNull!;
        expect(a, equals(b));
      });

      test('two PersonName with different values are not equal', () {
        final a = PersonName.create('Ana').valueOrNull!;
        final b = PersonName.create('Juan').valueOrNull!;
        expect(a, isNot(equals(b)));
      });

      test('hashCode is consistent with equality', () {
        final a = PersonName.create('Pedro').valueOrNull!;
        final b = PersonName.create('Pedro').valueOrNull!;
        expect(a.hashCode, equals(b.hashCode));
      });
    });
  });
}
