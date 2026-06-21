// Tests for BillingView — verifies that the invoices read gains proper
// error+retry states via FutureResultView.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/billing_view.dart';
import 'package:justicia_administrativa_site/core/models/invoice.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SizedBox(height: 600, width: 800, child: child)),
);

Invoice _invoice(int i) => Invoice(
  id: 'inv$i',
  clientId: 'c1',
  invoiceNumber: 'FAC-00$i',
  amount: 1000.0 * i,
  currency: 'MXN',
  status: InvoiceStatus.pendiente,
  createdAt: DateTime(2025, 1, i + 1),
);

void main() {
  // Invoices read (read #4)
  group('BillingView invoices read', () {
    testWidgets('shows Reintentar when invoices loader throws', (tester) async {
      await tester.pumpWidget(
        _wrap(
          BillingView(
            invoicesLoaderOverride: () async => throw TimeoutException('x'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('shows empty state when invoices list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(BillingView(invoicesLoaderOverride: () async => <Invoice>[])),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('No hay facturas.'), findsOneWidget);
    });

    testWidgets('shows invoice cards when loader returns data', (tester) async {
      await tester.pumpWidget(
        _wrap(
          BillingView(
            invoicesLoaderOverride: () async => [_invoice(1), _invoice(2)],
          ),
        ),
      );
      // Two pumps: first drains microtasks (future resolves), second rebuilds.
      await tester.pump();
      await tester.pump();
      // Settle animations (flutter_animate on _InvoiceCard).
      await tester.pumpAndSettle();

      expect(find.text('FAC-001'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}
