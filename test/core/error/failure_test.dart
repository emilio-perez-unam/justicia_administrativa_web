import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';

void main() {
  group('Failure — message content', () {
    test('NetworkFailure has non-empty default message', () {
      expect(const NetworkFailure().message.trim(), isNotEmpty);
    });

    test('AuthFailure has non-empty default message', () {
      expect(const AuthFailure().message.trim(), isNotEmpty);
    });

    test('NotFoundFailure has non-empty default message', () {
      expect(const NotFoundFailure().message.trim(), isNotEmpty);
    });

    test('ServerFailure has non-empty default message', () {
      expect(const ServerFailure().message.trim(), isNotEmpty);
    });

    test('UnexpectedFailure has non-empty default message', () {
      expect(const UnexpectedFailure().message.trim(), isNotEmpty);
    });

    test('ValidationFailure takes a custom message', () {
      expect(
        const ValidationFailure('Campo requerido.').message,
        'Campo requerido.',
      );
    });

    test("ValidationFailure('x').message == 'x'", () {
      expect(const ValidationFailure('x').message, 'x');
    });
  });

  group('Failure — equality', () {
    test('Two NetworkFailure() are equal', () {
      expect(const NetworkFailure(), equals(const NetworkFailure()));
    });

    test('NetworkFailure != ServerFailure', () {
      expect(const NetworkFailure(), isNot(equals(const ServerFailure())));
    });

    test('Two AuthFailure() with same message are equal', () {
      expect(const AuthFailure(), equals(const AuthFailure()));
    });

    test('AuthFailure with different message is not equal', () {
      const a = AuthFailure(message: 'Mensaje A');
      const b = AuthFailure(message: 'Mensaje B');
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      expect(
        const NetworkFailure().hashCode,
        equals(const NetworkFailure().hashCode),
      );
    });
  });

  group('Failure — cause', () {
    test('cause is accessible for logging', () {
      final e = Exception('detail');
      final f = NetworkFailure(cause: e);
      expect(f.cause, same(e));
    });

    test('cause does NOT participate in equality', () {
      final f1 = NetworkFailure(cause: Exception('a'));
      final f2 = NetworkFailure(cause: Exception('b'));
      expect(f1, equals(f2));
    });
  });

  group('Failure — toString', () {
    test('toString includes runtimeType and message', () {
      final s = const NetworkFailure().toString();
      expect(s, contains('NetworkFailure'));
    });
  });

  group('Failure — custom-message constructors', () {
    test('NetworkFailure accepts a custom message', () {
      const f = NetworkFailure(message: 'Sin WiFi.');
      expect(f.message, 'Sin WiFi.');
    });

    test('ServerFailure accepts a custom message', () {
      const f = ServerFailure(message: 'DB timeout.');
      expect(f.message, 'DB timeout.');
    });
  });
}
