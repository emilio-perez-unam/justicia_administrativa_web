/// Port to the authenticated legal-corpus dashboard.
///
/// The dashboard is served by the Caddy `/api/legal-corpus/*` reverse proxy to
/// the RAG FastAPI app, which validates the Supabase bearer token (mirrored
/// into a cookie by web/index.html). It is therefore only reachable when the
/// user has an active session.
abstract class LegalCorpusGateway {
  /// True when the corpus is reachable (the user has an active session).
  bool get isAvailable;

  /// Same-origin URL of the authenticated corpus dashboard.
  Uri get dashboardUrl;
}
