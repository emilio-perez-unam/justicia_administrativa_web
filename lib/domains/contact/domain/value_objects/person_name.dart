import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';

/// Value object representing the full name of a contact person.
///
/// Invariant: non-empty after trimming.
/// Value-equal by the trimmed string value.
final class PersonName {
  /// The normalised (trimmed) full name string.
  final String value;

  const PersonName._(this.value);

  /// Trusted back-door constructor for in-memory test fixtures and
  /// deserialization paths where the value is already known to be valid.
  const PersonName.fromTrusted(this.value);

  /// Validates [raw] and returns [Ok] with a new [PersonName] or
  /// [Err] with a [ValidationFailure] if the value is blank.
  static Result<PersonName> create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const Err(ValidationFailure('El nombre es obligatorio.'));
    }
    return Ok(PersonName._(trimmed));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is PersonName && value == other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'PersonName($value)';
}
