// In-app entry point to the authenticated legal-corpus dashboard.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../domains/legal_corpus/application/legal_corpus_gateway.dart';

/// Sidebar action that opens the authenticated legal-corpus dashboard in a new
/// browser tab. Hidden when no session is active (the bridge would 401).
///
/// Replaces the floating "Corpus legal" link that web/index.html used to inject
/// via JavaScript — the access path is now a first-class in-app element while
/// index.html keeps only the session→cookie mirroring the bridge needs.
class LegalCorpusLauncher extends StatelessWidget {
  /// Injectable for tests; defaults to the DI-registered gateway.
  final LegalCorpusGateway? gateway;

  /// Opens [url]; overridable in tests to avoid a real navigation.
  final Future<bool> Function(Uri url)? onOpen;

  const LegalCorpusLauncher({super.key, this.gateway, this.onOpen});

  @override
  Widget build(BuildContext context) {
    final corpus = gateway ?? getIt<LegalCorpusGateway>();
    if (!corpus.isAvailable) return const SizedBox.shrink();

    Future<void> open() async {
      final launcher =
          onOpen ?? (Uri url) => launchUrl(url, webOnlyWindowName: '_blank');
      await launcher(corpus.dashboardUrl);
    }

    final muted = Colors.white.withValues(alpha: 0.7);
    return Semantics(
      button: true,
      label: 'Abrir corpus legal en una pestaña nueva',
      child: InkWell(
        onTap: open,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(LucideIcons.bookOpen, size: 20, color: muted),
              const SizedBox(width: 12),
              Text(
                'Corpus Legal',
                style: TextStyle(
                  color: muted,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Icon(
                LucideIcons.externalLink,
                size: 14,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
