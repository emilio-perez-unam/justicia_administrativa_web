# Prompt 001 Rollback

## Canonical Repository Rollback

Baseline bundle:

```text
/home/emilio/ja-consolidation-001/justicia_administrativa_web-baseline-6861a2c.bundle
```

SHA256:

```text
0bcd8c237d27f43dcd60061a3f3c3189be89bcc794ed952fe6cb49a07fb7bec4
```

Restore into a new directory:

```bash
git clone /home/emilio/ja-consolidation-001/justicia_administrativa_web-baseline-6861a2c.bundle restored-canonical
cd restored-canonical
git checkout 6861a2c44de784b5f906915e77f1b1043ea23f56
```

## Production Rollback

Deployments back up the previous production tree under `/var/www/backups/new-YYYYMMDD-HHMMSS`.

Rollback:

```bash
sudo rsync -a --delete /var/www/backups/new-YYYYMMDD-HHMMSS/ /var/www/new/
```

Smoke-test:

```bash
curl -I -L https://www.justiciadministrativa.com/
curl -I -L https://www.justiciadministrativa.com/flutter_bootstrap.js
curl -sS -o /dev/null -w '%{http_code}\n' https://www.justiciadministrativa.com/api/legal-corpus/me
```

Expected unauthenticated legal-corpus result: `401`.

Last locally verified consolidation artifact:

```text
SHA256(build/web tar stream): 8ccfbcff306a2220de08c9fc9f4e5cffd62da98b32033767c8e248cef42b7743
main.dart.js stamp: 602fedb0
size: 37M
```

## Obsolete Repository Recovery

Last observed obsolete repository commit:

```text
28620706446fe90efb64c85b4018eb404b28aaea
```

The obsolete repository was not cloned by the local GitHub CLI account. Recovery requires repository owner access or the GitHub App connector.
