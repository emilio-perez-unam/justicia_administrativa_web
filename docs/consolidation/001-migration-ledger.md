# Prompt 001 Migration Ledger

## Retained From Original Canonical Repository

- Repository identity: `emilio-perez-unam/justicia_administrativa_web`.
- Baseline history preserved in a verified Git bundle.
- Shared first-party assets that also exist in the production source, such as `alfredo.jpg` and `hero_background.png`.

## Removed From Original Canonical Repository

- Stock Flutter README and metadata: replaced with product/deployment documentation.
- `.env.php`: removed because it contained a committed SMTP password.
- Incomplete feature folders with TODO/no-op behavior: replaced by the verified production source.
- Generated/developer-local files that are not source.

## Retained From Obsolete Repository

- Evidence only: generated artifact resource inventory, manifest metadata, and commit SHA.
- No generated JavaScript or build output was copied into source.

## Removed From Active Use

- The obsolete repository is no longer treated as a deployment source.
- Generated artifacts are produced from canonical source by `.github/workflows/deploy-production.yml`.

## Retained From Current Production Source

- Flutter app source, tests, assets, Supabase migrations, documentation, and server-local deploy script from `001-site`.
- Production web shell including legal-corpus auth bridge and service-worker cleanup.
- Cloudflare cache-busting deployment behavior.
- Production route set: `/`, `/servicios`, `/nosotros`, `/equipo`, `/blog`, `/contacto`, `/login`, `/reset-password`, `/portal`, and `/asistente-ia`.

## New Canonical Deployment Path

- `master` push or manual workflow dispatch triggers verification, release build, artifact upload, SSH backup, rsync deployment, and production smoke checks.
- The workflow requires `PRODUCTION_HOST`, `PRODUCTION_USER`, and `PRODUCTION_SSH_KEY`.
- Optional workflow secrets: `PRODUCTION_PORT`, `PRODUCTION_PATH`, and `PRODUCTION_BACKUP_DIR`.
- The repository-local `scripts/deploy-web.sh` now resolves the repository root dynamically instead of depending on the old monorepo checkout path.

## Security Actions

- Removed tracked `.env.php` from the working tree.
- Documented that the exposed SMTP credential must be rotated and the old repository history remains sensitive until purged or the secret is invalidated.
- No committed generated Flutter web output is retained in the canonical source tree.

## Blockers

- The local `gh` account cannot clone or administer the private obsolete repository even though the GitHub App can read metadata and files.
- DNS/Cloudflare configuration cannot be changed from this session.
- Production GitHub Actions secrets are not visible from this session; deployment workflow can be created but cannot be proven deployed until secrets are configured or a manual workflow run succeeds.
