import 'package:supabase_flutter/supabase_flutter.dart';

import '../application/legal_corpus_gateway.dart';

/// Session-backed [LegalCorpusGateway].
///
/// Availability mirrors the Supabase auth session — the same session
/// web/index.html base64-encodes into the `ja_supabase_access_token_b64`
/// cookie that the `/api/legal-corpus` bridge validates. The dashboard URL is
/// resolved against the current origin so it works in any deployment.
class SupabaseLegalCorpusGateway implements LegalCorpusGateway {
  final SupabaseClient _client;

  SupabaseLegalCorpusGateway({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  @override
  bool get isAvailable => _client.auth.currentSession != null;

  @override
  Uri get dashboardUrl => Uri.base.resolve('/api/legal-corpus/');
}
