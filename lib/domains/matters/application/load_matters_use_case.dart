import '../../../core/error/result.dart';
import '../../../core/models/matter.dart';
import 'matters_repository.dart';

/// Retrieves all matters for the current authenticated client.
class LoadMattersUseCase {
  final MattersRepository _repository;

  const LoadMattersUseCase(this._repository);

  Future<Result<List<Matter>>> call() => _repository.matters();
}
