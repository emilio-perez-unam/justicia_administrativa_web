import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/models/invoice.dart';
import '../../../core/services/portal_service.dart';
import '../application/billing_repository.dart';

/// Supabase-backed implementation that delegates to [PortalService].
class PortalServiceBillingRepository implements BillingRepository {
  const PortalServiceBillingRepository();

  @override
  Future<Result<List<Invoice>>> invoices() async {
    try {
      final invoices = await PortalService.getInvoices();
      return Ok(invoices);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
