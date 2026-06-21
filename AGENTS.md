# Repository Instructions

This repository is the authoritative source for the Justicia Administrativa production website at `https://www.justiciadministrativa.com/`.

## Boundaries
- This is a Flutter web application.
- Source lives in `lib/`, `web/`, `assets/`, `test/`, `scripts/`, `supabase_migrations/`, and `docs/`.
- `build/`, `.dart_tool/`, generated Flutter web output, local environment files, and deployment artifacts are not source.
- Do not edit generated Flutter web files by hand. Generate them with `flutter build web --release --base-href /`.

## Required Verification
Run these before claiming a change is complete:

```bash
flutter --version
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release --base-href /
```

For deployment-affecting changes, serve `build/web` over HTTP with history fallback and smoke-test the release artifact, including direct navigation to nested routes.

## Deployment
- Normal production deployment is GitHub Actions workflow `.github/workflows/deploy-production.yml`.
- The workflow builds from `master`, runs format/analyze/tests, creates a release artifact, and deploys to the configured production host.
- Do not deploy by copying `build/web` to another repository.
- `scripts/deploy-web.sh` is a server-local fallback for emergency deployments from a verified checkout.

## Security
- Never commit secrets, `.env`, `.env.local`, `.env.*.local`, `.env.php`, service-role keys, SMTP credentials, or private tokens.
- Flutter web `--dart-define` values are public in delivered browser assets unless they are non-secret public configuration.
- Production contact, auth, and legal-corpus flows must fail safely without exposing stack traces or credentials.

## Documentation
When changing deployment, routes, architecture, or production behavior, update the relevant document under `docs/`.
