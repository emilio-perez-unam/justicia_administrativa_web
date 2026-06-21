import '../../../core/error/result.dart';
import '../../../core/models/invoice.dart';

/// Port for the billing domain. Implementations delegate to whatever data
/// source is appropriate (Supabase, in-memory stub, etc.).
abstract class BillingRepository {
  /// Returns all invoices for the current authenticated client.
  Future<Result<List<Invoice>>> invoices();
}
