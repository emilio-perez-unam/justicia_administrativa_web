# Prompt 001 Comparison Matrix

| Area | Canonical source version | Deployed/artifact version | Best behavior | Evidence | Required action | Verification |
|------|--------------------------|---------------------------|---------------|----------|-----------------|--------------|
| Source of truth | Standalone Flutter source, incomplete docs, no workflow | Obsolete repo is generated web artifact | Current production `001-site` source | Production HTML matches `001-site/web/index.html`; obsolete repo has generated files only | Replace canonical source with production `001-site` source | Git diff and build/test |
| Deployment | No workflow | Generated artifact repo, not active Pages | CI builds source and deploys to server | Pages API 404; production is Cloudflare/server | Add `.github/workflows/deploy-production.yml` | Workflow file review |
| Metadata | Stock Flutter title/description | Stock Flutter artifact metadata | Product metadata from production `001-site` | Production HTML title and description | Retain `001-site/web/index.html` | Build grep for title/bridge |
| Legal corpus bridge | Absent | Absent | Present in production source | Production HTML and `001-site/web/index.html` contain bridge | Retain bridge in canonical `web/index.html` | `grep ja_supabase_access_token_b64 build/web/index.html` |
| Contact form | TODO marker in old canonical | Not recoverable from generated artifact | Production domain implementation | `001-site` has contact domain tests and Supabase repository | Retain `001-site` implementation | `flutter test` |
| Portal | Mostly absent in old canonical | Not recoverable from generated artifact | Production portal source | `001-site` has portal views and tests | Retain `001-site` implementation | `flutter test` |
| Blog | Static/incomplete old canonical | Not recoverable from generated artifact | Production blog domain and admin source | `001-site` has blog domain tests | Retain `001-site` implementation | `flutter test` |
| Assets | Some team/hero assets | Artifact had `alfredo.jpg` and `hero_background.png` | `001-site` asset set includes retained asset names plus additional production assets | Asset inventories | Retain `001-site` assets | `flutter build web` |
| Generated files | None committed except old source files | Entire repo is generated Flutter output | Generated only in CI | Service-worker resource map | Do not copy obsolete generated files | Git status excludes `build/web` |
| Security | Tracked `.env.php` secret | No source secrets observed in fetched files | Remove secret file and document rotation | grep found `.env.php` secret before transplant | Remove from working tree; rotate externally | grep after transplant |

Decision weighting favored reproducibility, functional completeness, deployment reliability, UX/accessibility, maintainability, automated verification, and security. The production `001-site` source wins over both listed repository states because it is maintainable source and matches current production behavior.
