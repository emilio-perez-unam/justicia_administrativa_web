/// A type with exactly one value used as the return type for operations that
/// succeed with no meaningful payload (similar to Void, but usable in generics).
///
/// Use as the type parameter for [Result] when a use case returns only
/// success/failure with no data: `Future<Result<Unit>>`.
class Unit {
  const Unit();
}

/// The single canonical instance of [Unit].
const unit = Unit();
