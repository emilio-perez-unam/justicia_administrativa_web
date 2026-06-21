import '../../../core/error/result.dart';
import '../../../core/models/invoice.dart';
import 'billing_repository.dart';

/// Retrieves all invoices for the current authenticated client.
class LoadInvoicesUseCase {
  final BillingRepository _repository;

  const LoadInvoicesUseCase(this._repository);

  Future<Result<List<Invoice>>> call() => _repository.invoices();
}
