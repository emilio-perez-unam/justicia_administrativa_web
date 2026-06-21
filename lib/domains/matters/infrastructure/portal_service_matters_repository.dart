import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/models/matter.dart';
import '../../../core/services/portal_service.dart';
import '../application/matters_repository.dart';

/// Supabase-backed implementation that delegates to [PortalService].
class PortalServiceMattersRepository implements MattersRepository {
  const PortalServiceMattersRepository();

  @override
  Future<Result<List<Matter>>> matters() async {
    try {
      final matters = await PortalService.getMatters();
      return Ok(matters);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
