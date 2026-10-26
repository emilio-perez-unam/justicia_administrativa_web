# Architecture

The site is a Flutter web application for Justicia Administrativa.

## Runtime Shape

- `lib/main.dart` initializes Flutter, Supabase, telemetry, localization, and dependency injection.
- `lib/app/router.dart` defines public and protected routes with `go_router`.
- `lib/app/` contains presentation views and reusable UI components.
- `lib/domains/` contains feature-local domain, application, actor, and infrastructure code.
- `lib/core/` contains cross-cutting configuration, dependency injection, error/result types, services, theme, and presentation helpers.

## Public Routes

- `/`
- `/servicios`
- `/nosotros`
- `/equipo`
- `/blog`
- `/contacto`
- `/login`
- `/reset-password`
- `/portal`
- `/asistente-ia`

`/portal` and `/asistente-ia` require authentication. Unknown routes render the Spanish 404 experience in `AppRouter`.

## Production Web Shell

`web/index.html` intentionally contains:

- product metadata (title, description, canonical, Open Graph/Twitter cards, JSON-LD `LegalService` structured data);
- a branded loading splash (`#ja-splash`) removed on `flutter-first-frame`;
- stale service-worker cleanup;
- CanvasKit renderer selection;
- the legal-corpus auth bridge that mirrors the browser Supabase session into the `ja_supabase_access_token_b64` cookie scoped to `/api/legal-corpus`.

The legal-corpus bridge is production infrastructure and must not be removed without changing the Caddy/RAG bridge.

`web/` also contains crawl/social support files served at the site root: `robots.txt` (auth-only routes disallowed), `sitemap.xml` (public routes), and `og-cover.jpg` (1200x630 social card). Keep `sitemap.xml` in sync with the public route set.

## Data and Integrations

- Supabase is used for auth and persisted portal/contact/blog data.
- `/api/legal-corpus/*` is provided by the production reverse proxy and RAG service, not by Flutter.
- Contact form submissions use a Supabase-backed repository under `lib/domains/contact/`.
- AI consultation and portal features are implemented as domain/application/infrastructure slices under `lib/domains/`.

## Generated Files

Do not commit or edit:

- `build/web/main.dart.js`
- `build/web/flutter_bootstrap.js`
- `build/web/flutter_service_worker.js`
- CanvasKit/SkWasm output
- `AssetManifest*`, `FontManifest*`, and other build output

These files are produced by `flutter build web --release --base-href /`.
