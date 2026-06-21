import 'package:file_picker/file_picker.dart';

import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import '../../../core/models/document.dart';
import 'documents_repository.dart';

/// Uploads a document file and records it in the database.
class UploadDocumentUseCase {
  final DocumentsRepository _repository;

  const UploadDocumentUseCase(this._repository);

  Future<Result<Unit>> call({
    required PlatformFile file,
    DocumentCategory category = DocumentCategory.otro,
    String? matterId,
  }) => _repository.upload(file: file, category: category, matterId: matterId);
}
