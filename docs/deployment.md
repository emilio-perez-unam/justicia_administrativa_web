# Deployment

## Authoritative Repository

`emilio-perez-unam/justicia_administrativa_web` on branch `master` is the canonical source repository.

## Production Hosting

Evidence gathered on 2026-06-20:

- `https://www.justiciadministrativa.com/` returns HTTP 200 through Cloudflare.
- `https://new.justiciadministrativa.com/` returns HTTP 301 to `https://www.justiciadministrativa.com/`.
- DNS for both names resolves to Cloudflare addresses.
- GitHub Pages API calls for `emilio-perez-unam/justicia_administrativa_web` and `emilio-perez-unam/justiciadministrativa-website` returned 404.
- The served production `index.html` matches the server-local `001-apps/001-site/web/index.html` legal-corpus bridge and not the obsolete artifact repository `index.html`.

Conclusion: current production is Cloudflare-fronted static hosting backed by the Justicia Administrativa production server path `/var/www/new`, not GitHub Pages.

## Deployment Workflow

Primary workflow: `.github/workflows/deploy-production.yml`.

Trigger:

- push to `master`;
- manual `workflow_dispatch`.

Required environment secrets:

- `PRODUCTION_HOST`
- `PRODUCTION_USER`
- `PRODUCTION_SSH_KEY`
- optional `PRODUCTION_PORT`, default `22`
- optional `PRODUCTION_PATH`, default `/var/www/new`
- optional `PRODUCTION_BACKUP_DIR`, default `/var/www/backups`

Workflow stages:

1. install Flutter `3.38.9`;
2. run `flutter pub get`;
3. run `dart format --output=none --set-exit-if-changed .`;
4. run `flutter analyze`;
5. run `flutter test`;
6. run `flutter build web --release --base-href /`;
7. assert `build/web/index.html` contains the legal-corpus bridge;
8. stamp `main.dart.js` references in `flutter_bootstrap.js` with a content hash query string;
9. create `.nojekyll` and `SHA256SUMS.txt`;
10. upload the release artifact;
11. back up current production files on the host;
12. rsync the artifact into `PRODUCTION_PATH`;
13. smoke-test home, `flutter_bootstrap.js`, and unauthenticated legal-corpus 401 behavior.

## Local Reproduction

```bash
flutter --version
flutter clean
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release --base-href /
```

Serve `build/web` through an HTTP server that falls back to `index.html` for unknown paths. A plain `python3 -m http.server` is useful for asset checks, but it does not validate direct navigation to nested Flutter routes.

Smoke-test at least:

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
- `/manifest.json`
- `/favicon.png`
- `/flutter_bootstrap.js`

Each route must return HTTP `200` from the served release artifact.

## Server-Local Emergency Deployment

`scripts/deploy-web.sh` remains as an emergency server-local fallback. It builds from source, asserts the legal-corpus bridge, stamps the Flutter entrypoint, backs up `/var/www/new`, deploys the artifact, and runs public smoke tests.

Normal deployment must use the GitHub Actions workflow.

## Rollback

Rollback uses the backup directory created during deployment:

```bash
sudo rsync -a --delete /var/www/backups/new-YYYYMMDD-HHMMSS/ /var/www/new/
```

After rollback, smoke-test:

```bash
curl -I -L https://www.justiciadministrativa.com/
curl -I -L https://www.justiciadministrativa.com/flutter_bootstrap.js
curl -sS -o /dev/null -w '%{http_code}\n' https://www.justiciadministrativa.com/api/legal-corpus/me
```

Expected legal-corpus unauthenticated result is `401`.

## Generated Artifact Policy

`build/web` is generated and must not be committed. The deployment artifact is produced by CI from source.
