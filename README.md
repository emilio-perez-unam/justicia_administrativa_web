# Justicia Administrativa Website

This repository is the authoritative source for the Justicia Administrativa production website.

Canonical repository:

```text
emilio-perez-unam/justicia_administrativa_web
```

Production URL:

```text
https://www.justiciadministrativa.com/
```

The obsolete generated-artifact repository `emilio-perez-unam/justiciadministrativa-website` is not an active source implementation.

## Purpose

The app is a Flutter web application for Justicia Administrativa. It includes the public marketing site, contact flow, blog, client portal, AI assistant entry points, legal-corpus launcher, and Supabase-backed domain flows.

## Prerequisites

- Flutter `3.38.9` for CI parity.
- Dart from the selected Flutter SDK.
- A browser for local release smoke tests.

## Setup

```bash
flutter pub get
```

No production secrets are required for local static build validation. Do not commit local environment files or credentials.

## Local Development

```bash
flutter run -d web-server
```

## Formatting, Analysis, and Tests

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Release Build

```bash
flutter build web --release --base-href /
```

Serve the release artifact through HTTP before validating:

Use a static server with history fallback so direct navigation to nested Flutter routes returns `index.html`. See [docs/deployment.md](docs/deployment.md) for the route smoke checklist.

## Deployment

Primary deployment is `.github/workflows/deploy-production.yml`.

The workflow builds from source, runs formatting/analyzer/tests, creates a release artifact, deploys to the production host, and runs smoke tests. It does not copy generated files to a second repository.

Full details: [docs/deployment.md](docs/deployment.md).

## Documentation

- [Architecture](docs/architecture.md)
- [Deployment](docs/deployment.md)
- [Testing](docs/testing.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Consolidation baseline](docs/consolidation/001-baseline.md)
- [Comparison matrix](docs/consolidation/001-comparison-matrix.md)
- [Migration ledger](docs/consolidation/001-migration-ledger.md)
- [Validation report](docs/consolidation/001-validation-report.md)
- [Rollback](docs/consolidation/001-rollback.md)

## Known Limitations

- Production deployment requires configured GitHub Actions secrets documented in [docs/deployment.md](docs/deployment.md).
- The previously committed SMTP credential in the old canonical history must be rotated outside this repository. The value is intentionally not documented here.
- DNS and Cloudflare settings are not managed by this repository.
