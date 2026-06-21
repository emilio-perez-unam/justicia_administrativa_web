import '../../../core/error/result.dart';
import '../../../core/models/document.dart';
import 'documents_repository.dart';

/// Retrieves all documents for the current authenticated client.
class LoadDocumentsUseCase {
  final DocumentsRepository _repository;

  const LoadDocumentsUseCase(this._repository);

  Future<Result<List<Document>>> call({String? matterId}) =>
      _repository.documents(matterId: matterId);
}
