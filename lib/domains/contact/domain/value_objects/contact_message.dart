import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';

/// Value object for the body of a contact inquiry message.
///
/// Invariants: non-empty after trimming; at most 5 000 characters.
/// Value-equal by the trimmed string value.
final class ContactMessage {
  /// The normalised (trimmed) message text.
  final String value;

  /// Maximum allowed message length in characters.
  static const int maxLength = 5000;

  const ContactMessage._(this.value);

  /// Trusted back-door constructor for in-memory test fixtures and
  /// deserialization paths where the value is already known to be valid.
  const ContactMessage.fromTrusted(this.value);

  /// Validates [raw] and returns [Ok] with a new [ContactMessage] or
  /// [Err] with a [ValidationFailure] for empty or overlong text.
  static Result<ContactMessage> create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const Err(ValidationFailure('El mensaje es obligatorio.'));
    }
    if (trimmed.length > maxLength) {
      return Err(
        ValidationFailure('El mensaje no puede exceder $maxLength caracteres.'),
      );
    }
    return Ok(ContactMessage._(trimmed));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactMessage && value == other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ContactMessage(${value.length} chars)';
}
