#!/usr/bin/env bash
#
# Cache-safe production deploy for the canonical site → /var/www/new
# (justiciadministrativa.com).
#
# Why this script exists:
#   `flutter build web` emits an UNHASHED `main.dart.js` (stable filename,
#   changing content). Cloudflare (proxied) caches it for ~4h, so a plain
#   `cp build/web/* /var/www/new/` leaves users on the OLD app even though the
#   origin is updated. `flutter_bootstrap.js` is served `no-store` (always
#   fresh) but references the entrypoint by plain name. We therefore stamp the
#   bootstrap's `main.dart.js` reference with a CONTENT HASH (`?v=<md5>`), so a
#   new build is a new URL → Cloudflare cache-miss → fresh app immediately, and
#   identical builds keep their cache. No Cloudflare API / purge required.
#
# It also guarantees the production index.html customizations (legal-corpus
# auth bridge, etc.) are present — these live in web/index.html so the build
# reproduces them; we assert it before deploying.
#
# Usage:  bash scripts/deploy-web.sh
# Rollback: printed at the end (restore the timestamped backup).
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
WEB="$APP_DIR/build/web"
DST="${DEPLOY_WEB_DEST:-/var/www/new}"
BACKUP_ROOT="${DEPLOY_WEB_BACKUP_DIR:-/var/www/backups}"
BK="$BACKUP_ROOT/new-$(date +%Y%m%d-%H%M%S)"

export PATH="/opt/flutter/bin:$PATH"
cd "$APP_DIR"

echo "==> flutter build web --release"
flutter build web --release

echo "==> assert index.html reproduces the legal-corpus bridge"
grep -q 'ja_supabase_access_token_b64' "$WEB/index.html" \
  || { echo "FATAL: legal-corpus bridge missing from build index.html — aborting"; exit 1; }

echo "==> stamp main.dart.js with a content hash in flutter_bootstrap.js (CDN cache-bust)"
VER="$(md5sum "$WEB/main.dart.js" | cut -c1-8)"
sed -i "s|main\.dart\.js|main.dart.js?v=$VER|g" "$WEB/flutter_bootstrap.js"
grep -q "main.dart.js?v=$VER" "$WEB/flutter_bootstrap.js" \
  || { echo "FATAL: version stamp not applied to bootstrap — aborting"; exit 1; }
echo "    content version = $VER"

echo "==> backup current production → $BK"
sudo cp -a "$DST" "$BK"

echo "==> deploy (overwrite app files; preserve extras such as onlyoffice.html)"
cp -r "$WEB"/* "$DST"/

echo "==> smoke test (public, through Cloudflare)"
curl -sS -o /dev/null -w '    home:                 HTTP %{http_code}\n' https://justiciadministrativa.com/
curl -sS -o /dev/null -w "    main.dart.js?v=$VER:  HTTP %{http_code}  %{size_download}B\n" "https://justiciadministrativa.com/main.dart.js?v=$VER"
curl -sS -o /dev/null -w '    legal-corpus(no tok): HTTP %{http_code}  (expect 401)\n' https://justiciadministrativa.com/api/legal-corpus/me

echo "==> DONE."
echo "    Rollback: sudo rsync -a --delete '$BK/' '$DST/'"
