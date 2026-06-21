/// Base of the sealed failure hierarchy surfaced to the presentation layer.
/// Every failure carries a human-readable [message] (Spanish, product language)
/// and an optional [cause] for logging. Value-equal by (runtimeType, message)
/// so tests and state comparisons are deterministic.
sealed class Failure {
  const Failure(this.message, {this.cause});

  /// Human-readable message in Spanish shown to end users.
  final String message;

  /// Low-level error retained for logging/debugging — NOT shown to users.
  final Object? cause;

  /// Value equality by (runtimeType, message) — ignores [cause].
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message);

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => '$runtimeType($message)';
}

/// Connectivity or network-level failure (DNS, no connection, timeout, etc.).
final class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Sin conexión. Revisa tu red e inténtalo de nuevo.',
    Object? cause,
  }) : super(message, cause: cause);
}

/// Authentication/authorization failure (session expired, bad credentials).
final class AuthFailure extends Failure {
  const AuthFailure({
    String message = 'Tu sesión expiró. Inicia sesión nuevamente.',
    Object? cause,
  }) : super(message, cause: cause);
}

/// The requested resource could not be found (404-equivalent).
final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'No se encontró el recurso solicitado.',
    Object? cause,
  }) : super(message, cause: cause);
}

/// User input or domain validation failure — message is always caller-supplied.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause});
}

/// Remote server or database returned an error.
final class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Ocurrió un error en el servidor. Inténtalo más tarde.',
    Object? cause,
  }) : super(message, cause: cause);
}

/// A catch-all for truly unexpected errors not covered above.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    String message = 'Ocurrió un error inesperado.',
    Object? cause,
  }) : super(message, cause: cause);
}
