import '../../../core/error/result.dart';
import '../../../core/models/matter.dart';

/// Port for the matters domain. Implementations delegate to whatever data
/// source is appropriate (Supabase, in-memory stub, etc.).
abstract class MattersRepository {
  /// Returns all matters for the current authenticated client.
  Future<Result<List<Matter>>> matters();
}
