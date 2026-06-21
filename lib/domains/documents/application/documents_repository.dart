import 'package:file_picker/file_picker.dart';

import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import '../../../core/models/document.dart';

/// Port for the documents domain. Implementations delegate to whatever data
/// source is appropriate (Supabase, in-memory stub, etc.).
abstract class DocumentsRepository {
  /// Returns all documents for the current authenticated client,
  /// optionally filtered by [matterId].
  Future<Result<List<Document>>> documents({String? matterId});

  /// Uploads [file] to storage and records the document in the database.
  /// Optionally associates the document with [matterId] and uses [category]
  /// for classification.
  Future<Result<Unit>> upload({
    required PlatformFile file,
    DocumentCategory category = DocumentCategory.otro,
    String? matterId,
  });
}
