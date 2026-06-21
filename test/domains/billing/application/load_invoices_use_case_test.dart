import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/models/invoice.dart';
import 'package:justicia_administrativa_site/domains/billing/application/billing_repository.dart';
import 'package:justicia_administrativa_site/domains/billing/application/load_invoices_use_case.dart';

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class _FakeBillingRepo implements BillingRepository {
  final Result<List<Invoice>> result;

  const _FakeBillingRepo(this.result);

  @override
  Future<Result<List<Invoice>>> invoices() async => result;
}

// ---------------------------------------------------------------------------
// Helper builders
// ---------------------------------------------------------------------------

Invoice _invoice(String id) => Invoice(
  id: id,
  clientId: 'client-1',
  invoiceNumber: 'FAC-00$id',
  amount: 1500.0,
  currency: 'MXN',
  status: InvoiceStatus.pendiente,
  createdAt: DateTime(2025, 1, 1),
);

void main() {
  group('LoadInvoicesUseCase', () {
    test('returns Ok with invoices on repository success', () async {
      final invoices = [_invoice('1'), _invoice('2')];
      final useCase = LoadInvoicesUseCase(_FakeBillingRepo(Ok(invoices)));

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, hasLength(2));
      expect(result.valueOrNull!.first.id, equals('1'));
    });

    test('returns Ok with empty list when repository returns empty', () async {
      final useCase = LoadInvoicesUseCase(_FakeBillingRepo(Ok(<Invoice>[])));

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    test('returns Err when repository returns failure', () async {
      const failure = NetworkFailure();
      final useCase = LoadInvoicesUseCase(
        _FakeBillingRepo(Err<List<Invoice>>(failure)),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<NetworkFailure>()),
      );
    });

    test('returns ServerFailure on server error', () async {
      const failure = ServerFailure(message: 'Error de datos');
      final useCase = LoadInvoicesUseCase(
        _FakeBillingRepo(Err<List<Invoice>>(failure)),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<ServerFailure>()),
      );
    });
  });
}
