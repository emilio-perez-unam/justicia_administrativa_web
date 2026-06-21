import 'failure.dart';

/// Sealed result type: either a successful [Ok] value or an [Err] carrying a
/// [Failure].  Forces callers to handle failure explicitly instead of relying
/// on thrown exceptions (which the UI previously swallowed silently).
///
/// Usage:
/// ```dart
/// final Result<User> r = await repo.fetchUser(id);
/// final String text = r.fold(
///   (user) => user.name,
///   (f)    => f.message,
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Branch on success/failure and reduce to a value of type [R].
  R fold<R>(R Function(T value) onOk, R Function(Failure failure) onErr) =>
      switch (this) {
        Ok<T>(:final value) => onOk(value),
        Err<T>(:final failure) => onErr(failure),
      };

  /// Returns the wrapped value, or `null` if this is an [Err].
  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  /// `true` if this is an [Ok].
  bool get isOk => this is Ok<T>;

  /// `true` if this is an [Err].
  bool get isErr => this is Err<T>;
}

/// Successful outcome wrapping a value of type [T].
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  /// The successful value.
  final T value;
}

/// Failed outcome wrapping a [Failure] describing what went wrong.
final class Err<T> extends Result<T> {
  const Err(this.failure);

  /// The failure that caused this result.
  final Failure failure;
}
