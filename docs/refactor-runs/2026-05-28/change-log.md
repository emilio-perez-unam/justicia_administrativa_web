# Change Log — 001-site Completion & Hardening (2026-05-28)

Per-step evidence trail for the arc defined in
`docs/superpowers/specs/2026-05-28-site-completion-hardening-design.md` and
`docs/superpowers/plans/2026-05-28-site-completion-hardening.md`.

**Conventions:** every step is RED→GREEN, keeps non-generated files ≤500 lines,
and recompiles the affected PlantUML. Evidence = `flutter analyze` / `flutter
test` / `flutter build web` output + rendered diagrams + screenshots.

## Baseline (start of arc)

- **Branch:** `codex/prompt-01-2026-05-05-ddd-oop-actors`
- **`flutter analyze` (001-site):** 0 issues — "No issues found! (ran in 5.1s)"
- **`flutter test` (001-site):** 4 passed (navbar desktop, navbar mobile drawer, navbar mobile close, app layout mobile menu)
- **`flutter build web`:** ✓ Built build/web (~693 s; the "wasm dry run failure" line is benign — production uses the canvaskit/JS renderer)
- **Largest lib files (lines):** calendar_view 460, blog_feed 440, documents_view 417 — none >500
- **Diagram toolchain:** PlantUML 1.2026.5 + graphviz + JRE (installed this run)

## Phase 0 — Stabilize, tooling, deploy-hazard

| Step | Action | Evidence | Commit |
|---|---|---|---|
| 0.1 | Commit in-flight WIP as baseline; harden .gitignore (.env, /output/) | tree clean; secret/junk gate empty; 103 site files + siblings | `0bed978`, `500ca0e`, `0123ef6` |
| 0.2 | Install PlantUML+graphviz+JRE; render all existing diagrams | monorepo + 001-site diagrams render, 0 errors | `e2a69a5` |
| 0.2b | Convert class-in-component decls (prompt-04..08) to rectangle stereotypes | full diagram set: zero render errors | `e2a69a5` |
| 0.3 | Verify baseline green | analyze=0, test=4 pass, build ✓ | (no code change) |
| 0.4 | Reconcile `web/index.html` → reproducible build | fresh-build vs deployed diff = added comments + intentionally-dropped `?v=` param only; legal-corpus bridge present in build (grep=2) | (this Phase-0 commit) |
| 0.5 | Author C4 Context + Container diagrams; create this change-log | `c4-context.svg` / `c4-container.svg` render clean (8 rects/16 nodes; 13 rects/28 nodes) | (this Phase-0 commit) |

## Phase 1 — Foundation (Result/Failure + async-state)

| Step | Action | Evidence | Commit |
|---|---|---|---|
| 1.0 | Confirm deps | flutter_riverpod ✓, shimmer ✓, skeletonizer ✓, mocktail ✓ | — |
| 1.1–1.3 | Error backbone: sealed `Result<T>`, sealed `Failure` (6 subtypes, value-equal, Spanish), web-safe `mapErrorToFailure` (Supabase/Timeout/string-network → Failure; no dart:io) | analyze 0; 56 tests pass; files 49/74/96 lines | `288a729` |
| 1.4–1.6 | Async-state UI: `AppLoadingState`/`AppEmptyState`/`AppErrorState` atoms + `FutureResultView<T>` (Future) + `AsyncValueWidget<T>` (Riverpod). Every read → loading/empty/**error+retry** | analyze 0; +35 tests (95 total); theme-driven, web-safe; files 30–121 lines | `f050c17` |
| 1.7 | Foundation class diagram `docs/uml/component-core-foundation.puml` → SVG | renders clean | (this commit) |

## Phase 2 — Horizontal hardening (eliminate happy-path reads)

Of 10 happy-path `FutureBuilder` reads (the 11th is `FutureResultView` itself),
**7 hardened here**; the 3 under `portal/messages/` are deferred to Phase 3.C
(hardened with their DDD extraction to avoid double work). All 7 now render
loading / empty / **error + functional retry** via `FutureResultView`, each
with an injectable loader (a testability seam that also loosens the static
`PortalService` coupling ahead of future extraction).

| Read | File | Loader (retry re-fetches) |
|---|---|---|
| portal stats | `dashboard_view.dart` | `PortalService.getStats` |
| recent matters | `dashboard_view.dart` | `PortalService.getMatters` |
| documents | `documents_view.dart` | `PortalService.getDocuments` |
| invoices | `billing_view.dart` | `PortalService.getInvoices` |
| matters | `matters/matters_list.dart` + `matters_view.dart` | `_loadMatters` (fetch + fuzzy re-index) |
| calendar entries | `calendar_view.dart` | `_fetchDataForMonth(month)` |
| AI conversations | `sidebar/portal_sidebar_navigation.dart` | `ChatService.getConversations` |

- **Evidence:** `flutter analyze` = 0; full suite **115 tests pass** (95 → 114 from the batch + 1 from the matters retry-refetch fix). Commits `02c99f1`, `9019fb9`.
- **Untouched (by design):** `dashboard_view._MessagesList` dead-future and all `portal/messages/*` reads → owned by Phase 3.C.
- **Diagram:** covered by `docs/uml/component-core-foundation.svg` (reads now depend on `core/presentation/FutureResultView`) and the C4 container note.
- **File sizes:** all ≤500 (calendar_view 481 — watch during the Phase 4 commenting pass).

## Phase 3 — Vertical strangler slices (contact, forgot-password, messaging, AI)

### 3.A — Contact form (DONE)
Fixed two defects: the fake `Future.delayed` submission **and** the broken data
capture (the `_TextInput`s had no controllers, so nothing the user typed was read).

- **DDD slice** `lib/domains/contact/`: value objects `PersonName`/`EmailAddress`/`ContactMessage` (each `create()→Result`), `ContactInquiry` entity (+`toInsert()` snake_case), `ContactInquiryRepository` port, `SubmitContactInquiryUseCase`, `SupabaseContactInquiryRepository` (errors→`mapErrorToFailure`), `ContactFormActor` (`ChangeNotifier`: idle→submitting→success/error). DI registered.
- **Form rewired**: 5 controllers + office dropdown captured; submit validates value objects (Spanish `ValidationFailure` toast), dispatches to the actor; spinner from `actor.status`; fake delay removed.
- **Backend:** `supabase_migrations/20260528_create_contact_inquiries.sql` applied live (table + index + RLS: anon/auth INSERT, admin SELECT).
- **Live validation (evidence):** anon INSERT via REST `return=minimal` → **HTTP 201** (row landed, cleaned up); anon SELECT → `[]` (admin-only RLS enforced). Adapter inserts without `.select()` so the production path works.
- **Tests:** +53 → **168 total**, analyze 0. Commits `d66f202`, `4af1055`. Diagram `docs/uml/contact-ddd-slice.puml`.

### 3.B — Forgot-password (DONE)
Replaced the "Funcionalidad en desarrollo" stub with a real GoTrue recovery flow.

- **DDD slice** `lib/domains/auth/`: `Password` value object (≥8), `AuthRepository` port (`requestPasswordReset(email, redirectTo)` + `updatePassword`), `RequestPasswordResetUseCase`/`ResetPasswordUseCase`, `SupabaseAuthRepository` (GoTrue `resetPasswordForEmail` + `updateUser`, errors→`mapErrorToFailure`), `PasswordRecoveryActor` (`ChangeNotifier`: idle/sending/emailSent/updating/done/error). Added `core/error/unit.dart`. DI registered.
- **Presentation:** `login_view` "¿Olvidaste tu contraseña?" → email dialog → actor → toast; new `/reset-password` route + `ResetPasswordView` (listens for `passwordRecovery`, also checks `currentSession` on refresh; new-password form with match + VO validation; "invalid/expired link" screen for direct hits). Router allows `/reset-password` unauthenticated. `redirectTo` = `EnvConfig.passwordResetRedirect`.
- **Backend (authorized infra change):** GoTrue `ADDITIONAL_REDIRECT_URLS` in `/mnt/supabase/.env` extended to include `https://justiciadministrativa.com[/reset-password]` + www (was only the unrouted demo subdomain). Auth container recreated (`--wait`, healthy); backup `/mnt/supabase/.env.bak-resetpw-20260528`. Rollback: restore backup + `docker compose --project-directory /mnt/supabase up -d --wait auth`.
- **Live validation (evidence):** post-restart login endpoint → **400 invalid_credentials** (functional, not 5xx); all Supabase containers healthy; site 200. `/auth/v1/recover?redirect_to=<prod>` → **200**; `GOTRUE_URI_ALLOW_LIST` confirmed to include the prod URL; SMTP configured (`GOTRUE_SMTP_HOST`/`USER` set) so reset emails send.
- **Tests:** +37 → **205 total**, analyze 0. Commit `9f9bfd9`. Diagram `docs/uml/auth-password-recovery-slice.puml`.

### 3.C — Portal messaging + dashboard dead futures (DONE)
Fixed the headline dead-future bug **and a second one found during recon**.

- **Dead future #1** `dashboard_view._MessagesList`: fetched `getRecentMessages()` then rendered hardcoded "Cargando mensajes…". **Dead future #2** `_CalendarWidget`: same bug ("Próximas fechas"). Both now render real data via `FutureResultView` with **injectable, retryable loaders** (`messagesLoaderOverride`/`eventsLoaderOverride` defaulting to `PortalService.getRecentMessages`/`getUpcomingEvents`) — full loading/empty/error+retry. Dead text confirmed gone (`grep` empty).
- **DDD context** `lib/domains/portal_messaging/`: `PortalMessagingRepository` port, `LoadRecentMessagesUseCase`, `PortalServiceMessagingRepository` (delegates to `PortalService`, wraps in `Result`). DI registered. Reuses the existing `PortalMessage` model.
- **Deferred Phase-2 reads hardened:** the 3 `messages/*` `FutureBuilder`s (sidebar conversations, thread header, thread panel) → `FutureResultView` with loader functions (retry re-fetches); `messages_view` threads loaders not cached futures. No `FutureBuilder` remains under `messages/`.
- **Decomposition:** extracted `dashboard/dashboard_message_row.dart` + `dashboard_event_row.dart` to keep `dashboard_view.dart` at 473 lines (<500; watch in Phase 4 commenting pass).
- **Tests:** +16 → **221 total**, analyze 0. Commit `664143b`. Diagram `docs/uml/portal-messaging-slice.puml`.

### 3.D — AI assistant (DONE)
- **DDD context** `lib/domains/ai_consultation/`: `AiConsultationRepository` port (`sendMessage → Result<ChatResponse>`), `SendConsultationMessageUseCase` (non-empty validation), `SupabaseAiConsultationRepository` (delegates to `ChatService`; **auth guard**: returns `AuthFailure('Inicia sesión para usar el asistente de IA.')` if `currentUser == null`, before the edge fn 500s), `AiConsultationActor` (`ChangeNotifier`). DI registered.
- **chat_area**: routes send through the use case + `result.fold`; on failure **restores the typed text** and toasts `failure.message` — the canned `'Error al procesar consulta.'` is gone.
- **demo_banner**: reworded "Versión Demo / simulación de respuestas" → "Asistente de IA / Versión preliminar — inicia sesión para consultas completas." (the `chat` fn is real for authed users — verified deployed).
- **Housekeeping:** deleted orphaned `lib/core/services/generative_service.dart` + its DI registration.
- **Tests:** +25 → **246 total**, analyze 0. Commit `2fed3b3`. Diagram `docs/uml/ai-consultation-slice.puml`.

### Post-slice cleanup
- **contact_form.dart 511 → 455 lines** (the 3.A rewrite breached the 500 ceiling): extracted `_submit()` into `contact_form_submit.dart` (part-file extension; setState methods stay in the State class; button calls `() => _submit()` to avoid an extension tear-off). analyze 0, 246 tests. Commit `4c324d7`.
- **≤500-line gate (req 4.4): PASS** — no non-generated lib file exceeds 500. Largest now: calendar_view 481, dashboard_view 473, contact_form 455.
- **Happy-path gate (req 4.5): PASS** — exactly 1 `FutureBuilder` in lib (the `FutureResultView` core); every real read flows through loading/empty/error+retry.
- **DDD (req 4.2):** 6 bounded contexts — blog, portal_calendar, contact, auth, portal_messaging, ai_consultation.

## Phase 4 — Validate, recompile diagrams, deploy, report

### Intermediate deploy (Phase 0–2 checkpoint) — 2026-05-28
- **Built** `flutter build web --release` (✓, main.dart.js 5.99 MB; was 4.66 MB May-20 — reflects committed DDD/split work + foundation + hardening).
- **Backed up** production → `/var/www/backups/new-20260528-205914` (36M, May-20 build).
- **Deployed** `build/web/*` → `/var/www/new` (preserved `onlyoffice.html`; title + legal-corpus bridge intact, grep=2).
- **CDN cache-bust:** Cloudflare had `main.dart.js` cached (`cf-cache-status: HIT`, `max-age=14400`). Stamped `flutter_bootstrap.js` → `main.dart.js?v=0806b24e` (content hash); public now serves the new 5.99 MB build. Root-caused into a committed deploy script `scripts/deploy-web.sh` (`e4e2177`) so future deploys are cache-safe + reproducible.
- **Smoke test (public/CF):** home 200, versioned main.dart.js 200 (5.99 MB), legal-corpus 401 (auth gate OK). Origin (Caddy direct) also 200.
- **Rollback:** `sudo rsync -a --delete /var/www/backups/new-20260528-205914/ /var/www/new/`.
- _Note:_ this ships Phase 0–2 (reproducible build + hardened error states). The stub fixes (3.A–D) deploy in the final Phase 4 pass via `scripts/deploy-web.sh`.

### Final validation + deploy (DONE)
- **Gates:** `flutter analyze` = 0; `flutter test` = **246 pass**; no non-generated lib file >500 (contact_form split 511→455); 1 `FutureBuilder` remaining (the foundation core). All 16 UML/C4 diagrams recompiled clean.
- **Deploy** via `scripts/deploy-web.sh`: `flutter build web --release` ✓ (827s); content version `083d69c6`; backup `/var/www/backups/new-20260529-000113`; deployed to `/var/www/new` (onlyoffice.html preserved; legal-corpus bridge asserted present).
- **Smoke test (public / Cloudflare):** home **200**; `main.dart.js?v=083d69c6` **200, 6,021,247 B** (new build live, not a stale edge copy); `/api/legal-corpus/me` **401** (auth gate intact).
- **Rollback:** `sudo rsync -a --delete /var/www/backups/new-20260529-000113/ /var/www/new/`.
- **Final report:** `final-report.md`. **Arc complete.**

## Phase 5 — Deferred items (follow-up, requested 2026-05-29)

### 5.7 — deno + supabase CLI dry-runs (DONE)
Long-standing gap (CLIs were never on PATH). Installed **deno 2.8.1** + **supabase 2.102.0**.
- **`deno check`** on all edge functions (`process-ai-message`, `generate-title`, `_shared/ai_consultation/{domain,ports,application,infrastructure,actor}`) → **clean, 0 type errors**.
- **Migration dry-run** (`BEGIN…ROLLBACK` against live DB): `20260505_ai_consultation_messages.sql` fails standalone (`ai_consultation_sessions`/`users` absent) but the **full 003-mobile chain `admin_schema → dashboard_schema → ai_consultation_messages` dry-runs clean in order (exit 0)**. Conclusion: it's a 003-mobile schema migration, correct but not for the 001-site DB — validated, not a blocker.

### 5.1–5.3 — DDD extraction: billing / documents / matters (DONE)
Strangler extraction of 3 portal contexts; Supabase adapters **delegate to the untouched `PortalService`**, return `Result<T>`; views load via `getIt<…UseCase>()`.
- `domains/billing` (`LoadInvoicesUseCase`), `domains/documents` (`LoadDocumentsUseCase` + `UploadDocumentUseCase`; port uses `PlatformFile` to mirror `uploadDocument` losslessly), `domains/matters` (`LoadMattersUseCase`; `matters_view._loadMatters` folds Result → re-index fuzzy / throw for retry).
- +14 use-case tests → **260 total**, analyze 0. Commits `fc09fdb`, `4d4652d`, `b1de9d2`. Diagram `docs/uml/portal-domains.puml`. **Bounded contexts: 6 → 9.**

### 5.4 — settings (DONE)
`domains/portal_settings`: `PortalSettingsRepository` port, `UpdateProfileUseCase` + `ChangePasswordUseCase`, `SupabasePortalSettingsRepository` (wraps `auth.updateUser({data:{full_name,phone}})` and `auth.updateUser({password})`). `settings_view` now folds Result via the use cases (0 direct `auth.updateUser` left). +8 tests. Commit `31cfea5`. _(Deviation: settings used Supabase auth directly, not `PortalService` — adapter wraps auth.)_

### 5.5 — blog-admin (DONE)
Extended `domains/blog` with the write side: `BlogAdminRepository` + 6 use cases (load-all/create/update/delete/set-published/set-featured), `SupabaseBlogAdminRepository` delegating to `BlogService.*`. `blog_admin_view` folds Result (0 direct `BlogService` mutation calls left). +15 tests. Commit `9754ca8`.

### 5.6 — legal-corpus frontend (DONE)
`domains/legal_corpus`: `LegalCorpusGateway` (isAvailable = active session; dashboardUrl resolved against current origin) + `SupabaseLegalCorpusGateway`. New `LegalCorpusLauncher` in the **sidebar footer** opens the authenticated `/api/legal-corpus` dashboard in a new tab, shown only when a session exists. **`web/index.html` trimmed**: removed the JS-injected floating link (`shouldShowCorpusLink`/`syncCorpusLink`), **kept** the session→cookie mirroring the bridge requires. +3 tests. Commit `9aa28a8`. Diagram `docs/uml/phase5-slices.puml`.

### Phase 5 gates
- **10 bounded contexts** (added billing, documents, matters, portal_settings, legal_corpus; extended blog). `flutter analyze` 0; **286 tests** pass; no non-generated file >500. CLIs: `deno check` clean, migration chain dry-run validated.
- **Final Phase 5 deploy (DONE):** `scripts/deploy-web.sh` → build ✓; content version `b7321b0f`; backup `/var/www/backups/new-20260529-045257`. Smoke (public/CF): home **200**, `main.dart.js?v=b7321b0f` **200 / 6,034,083 B** (new build live), legal-corpus **401** (bridge cookie survived the index.html trim). Rollback: `sudo rsync -a --delete /var/www/backups/new-20260529-045257/ /var/www/new/`. **Phase 5 complete.**
