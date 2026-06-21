// Verifies the legal-corpus launcher shows only when a session is available
// and opens the gateway's dashboard URL on tap.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/legal_corpus_launcher.dart';
import 'package:justicia_administrativa_site/domains/legal_corpus/application/legal_corpus_gateway.dart';

class _FakeGateway implements LegalCorpusGateway {
  _FakeGateway(this._available);
  final bool _available;

  @override
  bool get isAvailable => _available;

  @override
  Uri get dashboardUrl => Uri.parse('https://example.test/api/legal-corpus/');
}

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows "Corpus Legal" when the corpus is available', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        LegalCorpusLauncher(
          gateway: _FakeGateway(true),
          onOpen: (_) async => true,
        ),
      ),
    );
    expect(find.text('Corpus Legal'), findsOneWidget);
  });

  testWidgets('is hidden when the corpus is unavailable (no session)', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        LegalCorpusLauncher(
          gateway: _FakeGateway(false),
          onOpen: (_) async => true,
        ),
      ),
    );
    expect(find.text('Corpus Legal'), findsNothing);
  });

  testWidgets('tapping opens the gateway dashboard URL', (tester) async {
    Uri? opened;
    await tester.pumpWidget(
      host(
        LegalCorpusLauncher(
          gateway: _FakeGateway(true),
          onOpen: (url) async {
            opened = url;
            return true;
          },
        ),
      ),
    );
    await tester.tap(find.text('Corpus Legal'));
    await tester.pump();
    expect(opened, Uri.parse('https://example.test/api/legal-corpus/'));
  });
}
