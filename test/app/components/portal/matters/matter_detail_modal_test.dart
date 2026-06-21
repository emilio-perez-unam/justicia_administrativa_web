// Tests for MatterDetailModal — verifies the matter header and its aggregated
// documents / events / invoices / messages render from an injected loader.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/matters/matter_detail_modal.dart';
import 'package:justicia_administrativa_site/core/models/calendar_event.dart';
import 'package:justicia_administrativa_site/core/models/document.dart';
import 'package:justicia_administrativa_site/core/models/invoice.dart';
import 'package:justicia_administrativa_site/core/models/matter.dart';
import 'package:justicia_administrativa_site/core/models/portal_message.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';

Matter _matter() => Matter(
  id: 'm1',
  clientId: 'c1',
  referenceCode: 'DEMO-2026-001',
  title: 'Amparo demo',
  subtitle: 'Crédito fiscal',
  matterType: MatterType.amparo,
  status: MatterStatus.enProceso,
  lastUpdate: DateTime(2026),
  createdAt: DateTime(2026),
  lawyerName: 'Lic. Demo',
);

MatterDetailData _data() => MatterDetailData(
  documents: [
    Document(
      id: 'd1',
      clientId: 'c1',
      matterId: 'm1',
      name: 'Demanda.pdf',
      fileUrl: 'https://example.com/demanda.pdf',
      category: DocumentCategory.demanda,
      createdAt: DateTime(2026),
    ),
  ],
  messages: [
    PortalMessage(
      id: 'msg1',
      matterId: 'm1',
      senderId: 's1',
      senderType: 'lawyer',
      content: 'Mensaje de prueba',
      isRead: true,
      createdAt: DateTime(2026),
      senderName: 'Lic. Demo',
    ),
  ],
  events: [
    CalendarEvent(
      id: 'e1',
      clientId: 'c1',
      matterId: 'm1',
      title: 'Audiencia constitucional',
      eventType: 'audiencia',
      eventDate: DateTime(2026, 6, 1),
    ),
  ],
  invoices: [
    Invoice(
      id: 'i1',
      clientId: 'c1',
      matterId: 'm1',
      invoiceNumber: 'INV-2026-0001',
      amount: 45000,
      currency: 'MXN',
      status: InvoiceStatus.pendiente,
      createdAt: DateTime(2026),
    ),
  ],
);

void main() {
  testWidgets('renders the matter header and its related records', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MatterDetailModal(
            matter: _matter(),
            loader: (_) async => _data(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    // Header
    expect(find.text('Amparo demo'), findsOneWidget);
    expect(find.text('DEMO-2026-001'), findsOneWidget);
    // Each section's records
    expect(find.text('Demanda.pdf'), findsOneWidget);
    expect(find.text('Audiencia constitucional'), findsOneWidget);
    expect(find.textContaining('INV-2026-0001'), findsOneWidget);
    expect(find.text('Mensaje de prueba'), findsOneWidget);
  });

  testWidgets('shows empty notes for sections with no records', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MatterDetailModal(
            matter: _matter(),
            loader: (_) async => const MatterDetailData(
              documents: [],
              messages: [],
              events: [],
              invoices: [],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Sin documentos.'), findsOneWidget);
    expect(find.text('Sin facturas.'), findsOneWidget);
  });
}
