import 'package:email_validator/email_validator.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';

/// Value object representing a validated email address.
///
/// Construct via [create] — direct construction is private to enforce the
/// invariant that every instance holds a syntactically valid email.
/// Value-equal by the trimmed string value.
final class EmailAddress {
  /// The normalised (trimmed) email string.
  final String value;

  const EmailAddress._(this.value);

  /// Trusted back-door constructor for in-memory test fixtures and
  /// deserialization paths where the value is already known to be valid.
  /// Never pass user-supplied raw input here.
  const EmailAddress.fromTrusted(this.value);

  /// Validates [raw] and returns [Ok] with a new [EmailAddress] or
  /// [Err] with a [ValidationFailure] if the value is blank or invalid.
  static Result<EmailAddress> create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty || !EmailValidator.validate(trimmed)) {
      return const Err(ValidationFailure('Ingrese un correo válido.'));
    }
    return Ok(EmailAddress._(trimmed));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is EmailAddress && value == other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'EmailAddress($value)';
}
