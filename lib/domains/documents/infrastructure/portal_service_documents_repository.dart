import 'package:file_picker/file_picker.dart';

import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import '../../../core/models/document.dart';
import '../../../core/services/portal_service.dart';
import '../application/documents_repository.dart';

/// Supabase-backed implementation that delegates to [PortalService].
class PortalServiceDocumentsRepository implements DocumentsRepository {
  const PortalServiceDocumentsRepository();

  @override
  Future<Result<List<Document>>> documents({String? matterId}) async {
    try {
      final docs = await PortalService.getDocuments(matterId: matterId);
      return Ok(docs);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }

  @override
  Future<Result<Unit>> upload({
    required PlatformFile file,
    DocumentCategory category = DocumentCategory.otro,
    String? matterId,
  }) async {
    try {
      await PortalService.uploadDocument(
        file: file,
        category: category,
        matterId: matterId,
      );
      return const Ok(unit);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
