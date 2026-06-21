# Design — Complete & Harden `001-site` under DDD / OOP / Actor Architecture

- **Date:** 2026-05-28
- **Status:** Approved (design); pending implementation plan
- **Author:** Claude Code (with Emilio)
- **Target:** `001-apps/001-site` — `justicia_administrativa_site`, the Flutter web app deployed to `/var/www/new` and served at `justiciadministrativa.com`.
- **Branch:** `codex/prompt-01-2026-05-05-ddd-oop-actors`
- **Supersedes/extends:** `specs/2026-04-19-site-ddd-supabase-alignment-design.md` (this is the next execution arc).

---

## 1. Purpose

Complete the incomplete functionality of the **served** site (`001-site`) and eliminate its happy-path-only behavior, doing so under a **proper DDD + OOP + Actor** architecture, with every step proven by evidence (tests, analyzer, build, screenshots) and documented in an artifact, and with **UML/C4 diagrams recompiled after each change**.

This is a *continuation* of an in-flight, multi-session effort. The DDD groundwork (bounded contexts `blog` and `portal_calendar`, file splitting to ≤500 lines, `*Actor` coordinators, GetIt DI, per-prompt PlantUML) already exists **but is uncommitted**. The first job is to preserve it; the rest builds forward.

## 2. Scope

**In scope (functional):**
- Wire the **stub / dead** features: contact form, forgot-password, dashboard "Messages" dead-future, AI-assistant error handling.
- Systematically **harden every read** (the 11 `FutureBuilder`s) with real loading / empty / **error+retry** states — eliminate the "happy path."
- Fix the **brittle, non-reproducible deploy** (`index.html` drift) so production is reproducible from source.

**In scope (architectural, applied to everything touched):**
- Proper DDD directory distribution; proper OOP (sealed `Result`/`Failure`, value objects, encapsulation); `*Actor` coordinators; no god classes; no file > 500 lines after professional commenting; strangler pattern with RED→GREEN; per-step artifact; UML/C4 recompiled per step; no brittle code; no poor UX/UI.

**Out of scope (this arc):**
- Wiring the legal-corpus RAG bridge **into the Flutter UI** (the inline JS bridge in `index.html` is preserved, not extended).
- **Full** DDD extraction of non-stub portal contexts (billing, documents, matters, settings, blog-admin) — they are *hardened in place* this round, extracted in a later arc.
- `002-web`, `003-mobile`, `notarial-platform` (separate repo), and the ArgumentaLab/Laravel track.
- Refactoring the out-of-git RAG FastAPI app (`/mnt/rag-app`).

## 3. Authority & guardrails

- **Full autonomy incl. deploy** to `/var/www/new`, granted by the user.
- "Autonomy ≠ reckless on a live box": every deploy is preceded by a **timestamped backup** of `/var/www/new` and a documented rollback; every step shows evidence before claiming success.
- **Commit** to the feature branch is authorized. **Push to `origin` is on hold** until explicitly requested.
- Never commit secrets; never print `.env` contents or tokens.

## 4. Context — findings that shape the design (evidence)

### 4.1 Incomplete functionality (frontend)
| Feature | File | Problem |
|---|---|---|
| Contact form | `lib/app/components/contact/contact_form.dart:32-48` | Fake `Future.delayed(2s)` → always "success"; never writes to backend. |
| Forgot-password | `lib/app/views/login_view.dart:57-63` | Stub: toast *"Funcionalidad en desarrollo"*. |
| Dashboard "Messages" | `lib/app/components/portal/dashboard_view.dart` (`_MessagesList`) | **Dead future**: `getRecentMessages()` fetched, passed in, never rendered; shows hardcoded "Cargando mensajes…" forever. |
| AI assistant | `lib/app/components/ai_assistant/*` | Self-labeled "Versión Demo"; canned `'Error al procesar consulta.'` on failure. Backend `chat` edge function is real. |
| Gemini service | `lib/core/services/generative_service.dart` | Registered in DI but consumed nowhere; throws if called. |

### 4.2 The systemic "happy path" (reads)
- **11 `FutureBuilder`s, 0 `snapshot.hasError` checks.** Universal pattern: `waiting → shimmer, else snapshot.data ?? []`. A backend failure silently renders an **empty** state, indistinguishable from "no data" (dashboard stats, documents, billing, matters, calendar, …).
- Asymmetry: **write paths** already `try/catch` + toast errors; **read paths** do not. Other swallow points: `navbar.dart:78 catch (_)`, DI Hive-init catches that only log.

### 4.3 Backend status (live-verified)
- All tables/views/RPC/buckets `001-site` uses **exist** in live Supabase (`matters`, `documents`, `invoices`, `tasks`, `calendar_events`, `portal_messages`, `portal_messages_with_sender` view, `get_portal_stats` RPC, `blog_posts`, `conversations`, `messages`, `clients` + `chat-attachments` buckets).
- Drafted `20260505_ai_consultation_messages.sql` is **not applied** (tables absent live). `deno` and `supabase` CLIs are **not on PATH** (edge functions never type-checked; migrations never dry-run).

### 4.4 Environment gaps that block requirements
- **No PlantUML toolchain** (`plantuml`, `java`, `dot` absent) — req 4.1 needs it ⇒ Phase 0 installs it.
- **No error-handling idiom** (no `dartz`/`Either`/`Result`/`Failure`, no `lib/core/error/` or `lib/core/presentation/`) — clean slate for the OOP error model.
- 🚨 **`index.html` drift**: deployed (5,423 B) ≠ source (1,372 B, stock template). Deployed carries a ~140-line **legal-corpus auth-bridge** script, cache-clear script, real title/description, favicon — none in source. `cp -r build/web/* /var/www/new/` would **wipe the bridge and break production**. Must be reconciled (req 4.4, no brittle code).

### 4.5 Repository state (risk)
- The branch carries two historically-unreconciled tracks; the **entire DDD layer + docs are uncommitted** in a ~276-file dirty worktree. Preserve first (Phase 0).

## 5. Architecture & conventions (reaffirmed from the existing codebase)

| Concern | Decision |
|---|---|
| **DDD layout** | `lib/domains/<context>/{domain,application,infrastructure,actors}`. `domain/` = pure Dart (entities, value objects, repository **ports**, failures) with **zero** Flutter/Supabase/HTTP imports. `application/` = use cases / commands / queries. `infrastructure/` = Supabase adapters + mappers. `actors/` = coordinators. |
| **OOP error model** | New `lib/core/error/`: sealed `Result<T>` = `Ok<T>` \| `Err<T>`; sealed `Failure` = `NetworkFailure` \| `AuthFailure` \| `NotFoundFailure` \| `ValidationFailure` \| `ServerFailure` \| `UnexpectedFailure`, each carrying a user-facing message + optional cause. No raw exceptions reach the UI. (Deliberately avoids the mobile app's brittle `Either<String,T>`.) |
| **Actor model (req 4.3)** | Established interpretation: a plain-Dart **`*Actor` coordinator** that owns its state, processes intents/commands **sequentially**, and emits **immutable** state. Riverpod is a **thin adapter** over the actor. **Not** OS isolates — Flutter-web isolate support is weak and wrong for UI orchestration. |
| **DI** | GetIt composition root (`lib/core/di/dependency_injection.dart`) binds concrete repos → ports; Riverpod providers resolve `getIt<Port>()`. |
| **File size** | No non-generated Dart file > 500 lines **after professional commenting**. `*.g.dart` / `*.freezed.dart` exempt. |

## 6. Phased plan

### Phase 0 — Stabilize, tooling, deploy-hazard, commit baseline
1. **Safety snapshot** of the current WIP (tag/branch) before any change.
2. **Install diagram toolchain**: `plantuml graphviz default-jre-headless`; verify a `.puml → .svg` render.
3. **Reconcile `index.html`**: fold deployed customizations (legal-corpus bridge, cache-clear, title/description, favicon) into source `web/index.html` via proper Flutter templating (`$FLUTTER_BASE_HREF`) so `flutter build web` reproduces production.
4. **Verify green**: `flutter pub get && dart format && flutter analyze && flutter test && flutter build web`. Fix to green (documented). `analyze` siblings only enough to not commit broken WIP.
5. **Commit baseline** in logical commits (DDD code; docs/uml/architecture; siblings). DDD layer now version-controlled.

### Phase 1 — Foundation
- `lib/core/error/{result,failure}.dart` — the sealed types (pure Dart, fully unit-tested).
- `lib/core/presentation/` — one rendering core `AsyncStateLayout` (slots: loading→shimmer, empty→illustration+message, **error→message+Retry**, data→child) + two thin adapters: `FutureResultView<T>` (wraps a raw `Future`, catches→maps to `Failure`; for low-risk in-place hardening) and `AsyncValueWidget<T>` (wraps Riverpod `AsyncValue`; for actor-backed features). Shared atoms ⇒ uniform UX, no duplication.

### Phase 2 — Horizontal hardening (eliminate happy paths)
Route **all 11 reads** through `FutureResultView`. Each gets loading / empty / **error+retry**. Per read: widget test proving the **error** branch renders on failure (RED) → convert (GREEN) → screenshot evidence. In-place; no `PortalService` signature changes yet.

### Phase 3 — Vertical strangler slices (one per stub feature)
Each slice: RED test → grow `domains/<ctx>/` beside the legacy static service → rewire caller (strangler) → harden with Phase-1 widgets → update that context's `.puml` + recompile → artifact entry → commit → deploy at checkpoint.

| Slice | New/extended context | Fix | Locked decision |
|---|---|---|---|
| Contact form | `domains/contact` | Email/Phone/Message value objects + `SubmitContactInquiryUseCase` + `ContactFormActor`; remove fake delay. | **Persist to new Supabase `contact_inquiries` table** (RLS: anon insert, admin read). Email = later follow-up. |
| Forgot-password | extend `auth` | `RequestPasswordResetUseCase` (GoTrue `resetPasswordForEmail` + `redirectTo`); new `/reset-password` route handling `PASSWORD_RECOVERY`; `ResetPasswordUseCase`. Allow-list redirect URL in GoTrue. | Full in-app reset flow. |
| Portal messaging | `domains/portal_messaging` | Fix the dead future — `_MessagesList` renders via `AsyncValueWidget`; rewire `messages_view`. | — |
| AI assistant | extend `ai_consultation` | Replace canned error with typed `Failure` + retry; real streaming error/loading; verify `chat` edge function. | **Keep an honest banner**, reword only if verified production-ready. |

**Housekeeping:** the orphaned `GenerativeService` (Gemini summarize/sentiment, registered in DI but consumed nowhere, throws if called) is **removed as dead code** during this arc unless a consumer is planned — tracked in the change-log. This keeps DI honest and avoids a latent runtime throw.

### Phase 4 — Validation, deploy, rollback
Repo-wide `analyze`/`test`/`build` green → recompile **all** diagrams → **timestamped backup of `/var/www/new`** → `flutter build web --release` → deploy preserving reconciled `index.html` → curl/smoke-test routes → final report artifact. Documented rollback (restore backup).

## 7. Cross-cutting deliverables

- **C4 + UML (req 4.1):** maintain a C4 set (Context / Container / Component) in `docs/uml/` plus per-context component/class diagrams; **recompile affected `.puml` → SVG after every step** (possible after Phase 0.2).
- **Per-step artifact ("evidence per step"):** running strangler change-log at `001-apps/001-site/docs/refactor-runs/2026-05-28/change-log.md` — one entry per step: RED test name, GREEN commit hash, files touched + line counts (proving ≤500), diagram recompiled, evidence links (analyzer/test/build output, screenshots).
- **Evidence model:** each step records `flutter analyze` (target 0), `flutter test` (count + green), `flutter build web` (ok), screenshots of new error/empty states, recompiled diagram.

## 8. Testing & guardrails

- **TDD / RED→GREEN** for every behavior change. Behavior tested via public interfaces with **in-memory fakes** (not over-mocking) ⇒ **no brittle code** (req 4.4).
- 001-site has **4 tests** today; every new use case / actor / async-view ships with tests. Target a measurable test-count and coverage increase, reported per step.
- **≤500 lines** enforced via a line-count check recorded in the change-log; comments may push some files near the line ⇒ split proactively. **No god classes** — single-responsibility per class, verified each step.

## 9. Requirement compliance map

| Req | Where satisfied |
|---|---|
| 4.1 UML/C4 recompiled per step | §6 Phase 0.2, §7 |
| 4.2 proper DDD dirs | §5, §6 Phase 3 |
| 4.3 proper OOP | §5 (Result/Failure, value objects) |
| 4.3 actor model | §5, §6 Phase 3 (`*Actor`) |
| 4.4 ≤500 / strangler / RED-GREEN / artifact | §6 Phase 3, §7, §8 |
| 4.4 no brittle code | §6 Phase 0.3 (reproducible deploy), §8 (fakes, behavior tests) |
| 4.5 no happy paths | §6 Phase 1–2, §8 (error-state tests) |
| 4.6 no poor UX/UI | §6 Phase 1 (uniform loading/empty/error + retry) |
| 4.7 no god classes / monoliths | §6 Phase 3, §8 |

## 10. Acceptance criteria (definition of done)

1. Contact form writes a real `contact_inquiries` row and shows typed success/error states; no fake delay.
2. Forgot-password sends a real reset email and completes an in-app reset via `/reset-password`.
3. Dashboard "Messages" renders real data with loading/empty/error states; the dead future is gone.
4. AI assistant surfaces typed errors with retry; no canned string; banner is accurate.
5. **All reads** render explicit loading / empty / **error+retry** — zero `FutureBuilder` without an error branch remains.
6. `index.html` is reproducible from source; a fresh build + deploy preserves the legal-corpus bridge.
7. `flutter analyze` = 0 issues; `flutter test` green with a higher test count than the 4-test baseline; `flutter build web --release` succeeds.
8. No non-generated Dart file > 500 lines after commenting; no god classes introduced.
9. Every step has an artifact entry + recompiled diagram; production deployed and smoke-tested; rollback documented.

## 11. Risks & mitigations

| Risk | Mitigation |
|---|---|
| Losing uncommitted WIP | Phase 0.1 safety snapshot + early baseline commit. |
| Naive deploy breaks legal-corpus bridge | Phase 0.3 reconcile `index.html`; Phase 4 backup + smoke test. |
| `chat`/migration unverifiable (no deno/supabase CLI) | Install CLIs if feasible; otherwise validate against live Supabase and document any deferred dry-run. |
| Live production regression | Backup before each deploy; deploy at safe checkpoints; documented rollback. |
| Scope creep into 002-web / full portal extraction | Explicit out-of-scope (§2); non-stub reads hardened in place only. |

## 12. Open decisions (defaults chosen; override anytime)

- Contact delivery = **Supabase table** (email later).
- AI "Demo" banner = **kept honest / reworded** (not removed).
- Push to `origin` = **held** (local commits + deploy only) until requested.
