import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';

/// Value object representing a validated plain-text password.
///
/// Enforces the invariant that every instance is at least 8 characters long
/// (after trimming). Construct via [create]; direct instantiation is private.
final class Password {
  /// The trimmed raw password string.
  final String value;

  const Password._(this.value);

  /// Validates [raw] and returns [Ok] with a new [Password] or
  /// [Err] with a [ValidationFailure] if the value is too short.
  static Result<Password> create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.length < 8) {
      return const Err(
        ValidationFailure('La contraseña debe tener al menos 8 caracteres.'),
      );
    }
    return Ok(Password._(trimmed));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Password && value == other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Password(****)';
}
