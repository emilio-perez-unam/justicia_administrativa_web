import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';

void main() {
  group('Result — Ok variant', () {
    const ok = Ok(42);

    test('isOk is true', () => expect(ok.isOk, isTrue));
    test('isErr is false', () => expect(ok.isErr, isFalse));
    test('valueOrNull returns the value', () => expect(ok.valueOrNull, 42));

    test('fold picks onOk branch', () {
      final result = ok.fold((v) => 'ok:$v', (_) => 'err');
      expect(result, 'ok:42');
    });
  });

  group('Result — Err variant', () {
    const err = Err<int>(NetworkFailure());

    test('isErr is true', () => expect(err.isErr, isTrue));
    test('isOk is false', () => expect(err.isOk, isFalse));
    test('valueOrNull returns null', () => expect(err.valueOrNull, isNull));

    test('fold picks onErr branch', () {
      final result = err.fold((v) => 'ok:$v', (f) => 'err:${f.runtimeType}');
      expect(result, 'err:NetworkFailure');
    });

    test('fold delivers the correct Failure instance', () {
      Failure? captured;
      err.fold((_) {}, (f) => captured = f);
      expect(captured, isA<NetworkFailure>());
    });
  });

  group('Result — generic type parameter', () {
    test('Ok<String> works', () {
      const r = Ok('hello');
      expect(r.valueOrNull, 'hello');
    });

    test('Ok<List<int>> works', () {
      const r = Ok(<int>[1, 2, 3]);
      expect(r.valueOrNull, [1, 2, 3]);
    });

    test('Err with AuthFailure works', () {
      const r = Err<String>(AuthFailure());
      expect(r.isErr, isTrue);
      expect(r.valueOrNull, isNull);
    });
  });
}
