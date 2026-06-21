# Troubleshooting

## Dependency Resolution Fails

Run:

```bash
flutter --version
flutter pub get
```

The CI workflow uses Flutter `3.38.9`. Do not upgrade Flutter or dependencies as part of an unrelated fix.

## Analyzer or Tests Fail

Run the failing command locally and inspect the first actual Dart error. Do not suppress analyzer errors or skip tests to deploy.

## Production Still Shows an Old Build

Cloudflare may cache unhashed Flutter entrypoints. The deployment workflow stamps `main.dart.js` with a content hash query string in `flutter_bootstrap.js`. Confirm:

```bash
grep 'main.dart.js?v=' build/web/flutter_bootstrap.js
curl -I -L https://www.justiciadministrativa.com/flutter_bootstrap.js
```

## Legal Corpus Fails

Confirm `web/index.html` and `build/web/index.html` contain `ja_supabase_access_token_b64`.

Unauthenticated `/api/legal-corpus/me` should return `401`. A different result means the Caddy/RAG bridge needs investigation.

## Deployment Fails in CI

Check:

- production environment secrets exist;
- SSH key can connect to the production host;
- deployment user can write to `PRODUCTION_PATH`;
- backup path `/var/www/backups` is writable or the server policy has been adjusted;
- `rsync` completed without deleting preserved server-only files such as `onlyoffice.html`.
