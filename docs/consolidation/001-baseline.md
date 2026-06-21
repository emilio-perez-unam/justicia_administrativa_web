# Prompt 001 Baseline

Date: 2026-06-20 America/Mexico_City.

## Repositories

### Canonical Source Repository

Facts:

- Repository: `emilio-perez-unam/justicia_administrativa_web`
- Visibility: public
- Default branch: `master`
- Baseline commit: `6861a2c44de784b5f906915e77f1b1043ea23f56`
- Tags before baseline: none
- Releases observed: none through local clone
- Local baseline bundle: `/home/emilio/ja-consolidation-001/justicia_administrativa_web-baseline-6861a2c.bundle`
- Bundle SHA256: `0bcd8c237d27f43dcd60061a3f3c3189be89bcc794ed952fe6cb49a07fb7bec4`
- Bundle verification: `git bundle verify` exited 0
- Baseline local archival tag: `archive/prompt-001-canonical-baseline-20260620`

Evidence:

- GitHub repository metadata returned default branch `master`, public visibility, and admin permissions.
- Local clone HEAD was `6861a2c44de784b5f906915e77f1b1043ea23f56`.
- `git bundle verify` reported a complete history.

Baseline defects:

- `README.md` was the stock Flutter starter README.
- No `.github` workflow existed.
- `.env.php` contained an SMTP password and was tracked in history. The value is intentionally not reproduced here.
- Many visible buttons were no-op callbacks.
- Contact submission had a TODO implementation marker.
- Metadata in `web/index.html` and `web/manifest.json` was stock Flutter metadata.

### Obsolete Artifact Repository

Facts:

- Repository: `emilio-perez-unam/justiciadministrativa-website`
- Visibility: private
- Default branch: `main`
- Baseline commit: `28620706446fe90efb64c85b4018eb404b28aaea`
- Branches observed: `main`
- `README.md`: absent
- `CNAME`: absent
- Contents observed through GitHub App: generated Flutter web files including `index.html`, `flutter_bootstrap.js`, `flutter_service_worker.js`, `manifest.json`, `assets/AssetManifest.json`, CanvasKit files, icons, and `main.dart.js`.

Evidence:

- GitHub repository metadata returned default branch `main`, private visibility, and admin permissions through the GitHub App.
- Local `gh` account could not clone or resolve the private repository.
- GitHub App `compare main...main` returned baseline commit `28620706446fe90efb64c85b4018eb404b28aaea`.
- `flutter_service_worker.js` resource map listed the generated artifact files.

Conclusion:

- This repository is generated Flutter web output, not maintainable source.

### Current Production Source Evidence

Facts:

- Server-local source path: `/mnt/monorepository/JusticiaAdmin/001-apps/001-site`
- Server-local source commit: `cde3a296d8fe1e4bbbe4c9e4bd317bcd4e0df8a5` in `general-analytic-solutions/JusticiaAdmin`
- Production deploy script: `scripts/deploy-web.sh`
- Production path used by script: `/var/www/new`
- Production backup path used by script: `/var/www/backups/new-<timestamp>`

Evidence:

- `https://www.justiciadministrativa.com/` served HTML containing the same legal-corpus bridge as `/mnt/monorepository/JusticiaAdmin/001-apps/001-site/web/index.html`.
- The deploy script documents Cloudflare cache busting and `/var/www/new`.

## Production HTTP and DNS

Facts:

- `https://new.justiciadministrativa.com/` returns HTTP 301 to `https://www.justiciadministrativa.com/`.
- `https://www.justiciadministrativa.com/` returns HTTP 200.
- `https://justiciadministrativa.com/` returns HTTP 200.
- `new.justiciadministrativa.com` and `www.justiciadministrativa.com` resolve to Cloudflare IP addresses.
- GitHub Pages API returned 404 for both listed repositories.
- Candidate GitHub Pages URLs returned GitHub 404 pages.

Conclusion:

- Production is Cloudflare-fronted static hosting backed by the production server, not GitHub Pages from either listed repository.
