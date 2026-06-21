# 001-site Completion & Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the stub/dead features of the served `001-site` app and eliminate happy-path-only reads, under DDD/OOP/`*Actor` architecture, with per-step evidence + recompiled UML, and fix the non-reproducible `index.html` deploy.

**Architecture:** A shared OOP error backbone (sealed `Result`/`Failure`) + one reusable async-state UI core route every read through explicit loading/empty/**error+retry** states. Stub features become vertical DDD strangler slices (`domains/<ctx>/{domain,application,infrastructure,actors}`) grown beside the legacy static services, with Riverpod/state as a thin adapter over `*Actor` coordinators. Every step is RED→GREEN, ≤500 lines, committed, with the affected PlantUML recompiled and an artifact entry.

**Tech Stack:** Flutter 3.38.9 / Dart, Supabase Flutter SDK, GetIt (DI), Riverpod (state, to confirm), go_router, Dio; `flutter_test`; PlantUML + Graphviz (diagrams).

**Spec:** `001-apps/001-site/docs/superpowers/specs/2026-05-28-site-completion-hardening-design.md`

**Working dir for all `flutter`/`dart` commands:** `/mnt/monorepository/JusticiaAdmin/001-apps/001-site`
**Branch:** `codex/prompt-01-2026-05-05-ddd-oop-actors`

---

## Execution model

The arc runs in 5 phases. **Phases 0–1 are fully detailed below** (complete code). **Phases 2–4 are enumerated as concrete tasks** (exact files, contracts, evidence, step pattern + worked exemplars); each task's remaining per-step code is written at execution time against the real files using the Phase-1 API — TDD discipline, not placeholders. Every task ends green (analyzer 0, tests pass, build ok where relevant), committed, with diagram + change-log updated.

## File Structure

**Phase 0 (stabilize / tooling / deploy-fix):**
- Modify: `web/index.html` — fold in deployed customizations (legal-corpus bridge, cache-clear, meta, favicon) via Flutter templating.
- Create: `docs/refactor-runs/2026-05-28/change-log.md` — per-step artifact.
- Create: `docs/uml/c4-context.puml`, `docs/uml/c4-container.puml` — C4 baseline (monorepo-level `docs/uml/` already holds `component.puml`/`class.puml`).

**Phase 1 (foundation):**
- Create: `lib/core/error/result.dart`, `lib/core/error/failure.dart`, `lib/core/error/failure_mapper.dart`
- Create: `lib/core/presentation/states/app_loading_state.dart`, `app_empty_state.dart`, `app_error_state.dart`
- Create: `lib/core/presentation/future_result_view.dart`, `lib/core/presentation/async_value_widget.dart`
- Test: mirror under `test/core/error/` and `test/core/presentation/`

**Phase 2 (horizontal hardening):** Modify the 11 read sites (table in Task 2.x); Test: `test/app/.../*_error_state_test.dart`.

**Phase 3 (vertical slices):**
- `lib/domains/contact/{domain,application,infrastructure,actors}/...`
- `lib/domains/auth/...` (forgot-password) + `lib/app/views/reset_password_view.dart` + router entry
- `lib/domains/portal_messaging/...`
- `lib/domains/ai_consultation/...` (extend)
- Per-context diagrams under `docs/uml/`.

**Phase 4 (validate/deploy):** build + deploy `/var/www/new`; `docs/refactor-runs/2026-05-28/final-report.md`.

---

## PHASE 0 — Stabilize, tooling, deploy-hazard, baseline commit

### Task 0.1: Preserve the in-flight WIP as a committed, tagged baseline

**Files:** (whole worktree — no code edits)

- [ ] **Step 1: Inspect the dirty tree**

Run: `cd /mnt/monorepository/JusticiaAdmin && git status --short | wc -l && git status --short | head -40`
Expected: ~270+ entries (modified + untracked DDD/docs).

- [ ] **Step 2: Stage and commit everything as the baseline (preserve as-is, per the "commit WIP as baseline" decision)**

```bash
cd /mnt/monorepository/JusticiaAdmin
git add -A
git commit -q -m "$(cat <<'EOF'
chore(site): commit in-flight DDD/refactor WIP as verified baseline

Preserves the uncommitted work (blog + portal_calendar bounded
contexts, *Actor coordinators, file splits <=500, codex_runs docs,
docs/uml + docs/architecture) so it is version-controlled before the
completion+hardening arc builds forward. Green-verification follows in
Task 0.3.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
git tag wip-baseline-2026-05-28
```

- [ ] **Step 3: Verify clean tree + tag**

Run: `git status --short && git tag --list 'wip-baseline-2026-05-28' && git log --oneline -1`
Expected: empty status; tag listed; commit shown.

### Task 0.2: Install the PlantUML diagram toolchain (req 4.1 prerequisite)

**Files:** none (system)

- [ ] **Step 1: Install plantuml + graphviz + JRE**

Run: `sudo apt-get update -qq && sudo apt-get install -y plantuml graphviz default-jre-headless`
Expected: installs without error.

- [ ] **Step 2: Verify the toolchain renders**

Run: `cd /mnt/monorepository/JusticiaAdmin && plantuml -version && plantuml -tsvg docs/uml/component.puml && ls -la docs/uml/component.svg`
Expected: version prints; `component.svg` created.

- [ ] **Step 3: Commit the rendered SVG baseline**

```bash
cd /mnt/monorepository/JusticiaAdmin
git add docs/uml/*.svg
git commit -q -m "docs(site): render existing PlantUML to SVG (toolchain online)

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

### Task 0.3: Verify the baseline is green; fix forward if not

**Files:** as needed to reach green (separate commits, documented)

- [ ] **Step 1: Resolve deps**

Run: `cd 001-apps/001-site && flutter pub get`
Expected: "Got dependencies".

- [ ] **Step 2: Format + analyze**

Run: `dart format lib test && flutter analyze`
Expected: "No issues found!" (per prior runs). If issues: fix minimally, re-run until clean, commit `fix(site): restore analyzer-clean baseline`.

- [ ] **Step 3: Test + build**

Run: `flutter test && flutter build web`
Expected: all tests pass (~4 baseline); build succeeds. If red: fix forward, commit, re-run.

- [ ] **Step 4: Record baseline metrics in the change-log (created in Task 0.5 — if running 0.5 first, reorder)**

Capture: analyzer issue count, test count, largest-file line counts (`find lib -name '*.dart' -exec wc -l {} + | sort -rn | head`).

### Task 0.4: Make `index.html` reproducible from source (fix the deploy hazard, req 4.4)

**Files:** Modify `001-apps/001-site/web/index.html`

- [ ] **Step 1: Capture the deployed customizations**

Run: `cp /var/www/new/index.html /tmp/deployed-index.html && wc -l /tmp/deployed-index.html`
Read `/tmp/deployed-index.html` fully. Identify the 3 custom blocks to port: (a) the cache-clearing service-worker script, (b) the legal-corpus auth-bridge script (`ja_supabase_access_token_b64` cookie writer for `/api/legal-corpus/`), (c) the real `<title>`/`<meta description>`/favicon/iOS meta tags.

- [ ] **Step 2: Write `web/index.html` = stock Flutter template + the 3 ported blocks**

Keep Flutter's `<base href="$FLUTTER_BASE_HREF">`, the `flutter_bootstrap.js` loader, and `{{flutter_service_worker_version}}` handling. Insert block (c) into `<head>`; insert blocks (a) and (b) as `<script>` before the bootstrap loader. Result: a build reproduces production (modulo content hashes).

- [ ] **Step 3: Build and diff against deployed**

Run: `flutter build web && diff <(sed 's/[[:space:]]*$//' build/web/index.html) <(sed 's/[[:space:]]*$//' /var/www/new/index.html)`
Expected: only differences are Flutter-generated hashes/versions; the legal-corpus bridge + cache-clear + meta blocks are PRESENT in `build/web/index.html`.

- [ ] **Step 4: Commit**

```bash
cd /mnt/monorepository/JusticiaAdmin
git add 001-apps/001-site/web/index.html
git commit -q -m "fix(site): make index.html reproducible from source

Folds the hand-applied production customizations (legal-corpus auth
bridge, cache-clear SW script, title/description/favicon/iOS meta)
into web/index.html so 'flutter build web' regenerates production and
deploys no longer clobber the legal-corpus bridge.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

### Task 0.5: Create the per-step artifact + C4 baseline

**Files:** Create `docs/refactor-runs/2026-05-28/change-log.md`, `docs/uml/c4-context.puml`, `docs/uml/c4-container.puml`

- [ ] **Step 1: Create the change-log artifact** with a table header: `| Step | RED test | GREEN commit | Files (lines) | Diagram | Evidence |` and the Task 0.3 baseline metrics.

- [ ] **Step 2: Write C4 Context + Container `.puml`** (actors: Visitante, Cliente, Admin; systems: 001-site SPA, Supabase, RAG legal-corpus bridge, MiroTalk, OnlyOffice). Containers: Flutter web SPA, Kong/GoTrue/PostgREST/Storage, Postgres, RAG FastAPI.

- [ ] **Step 3: Render + commit**

```bash
cd /mnt/monorepository/JusticiaAdmin
plantuml -tsvg docs/uml/c4-context.puml docs/uml/c4-container.puml
git add docs/uml/c4-*.puml docs/uml/c4-*.svg docs/refactor-runs/2026-05-28/change-log.md
git commit -q -m "docs(site): add C4 context/container diagrams + step change-log

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

## PHASE 1 — Foundation (the "no happy paths" + OOP error backbone)

### Task 1.0: Confirm state/util deps

**Files:** read `001-apps/001-site/pubspec.yaml`

- [ ] **Step 1:** Run: `grep -E 'flutter_riverpod|riverpod|shimmer|equatable' 001-apps/001-site/pubspec.yaml || echo "MISSING"`
Note which exist. `FutureResultView` (Phase 2) needs none of these. `AsyncValueWidget` needs `flutter_riverpod`; if absent, actors expose `ValueListenable`/`ChangeNotifier` and `AsyncValueWidget` wraps that instead. Record the decision in the change-log.

### Task 1.1: `Result<T>` sealed type

**Files:** Create `lib/core/error/result.dart`; Test `test/core/error/result_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/core/error/result_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';

void main() {
  test('Ok folds to onOk and exposes value', () {
    const Result<int> r = Ok(42);
    expect(r.isOk, isTrue);
    expect(r.valueOrNull, 42);
    expect(r.fold((v) => 'ok:$v', (f) => 'err'), 'ok:42');
  });

  test('Err folds to onErr and hides value', () {
    const Result<int> r = Err(NetworkFailure());
    expect(r.isErr, isTrue);
    expect(r.valueOrNull, isNull);
    expect(r.fold((v) => 'ok', (f) => 'err:${f.runtimeType}'), 'err:NetworkFailure');
  });
}
```

- [ ] **Step 2: Run, expect fail.** Run: `flutter test test/core/error/result_test.dart` → FAIL ("uri doesn't exist" / undefined).

- [ ] **Step 3: Implement**

```dart
// lib/core/error/result.dart
import 'failure.dart';

/// Sealed result: a successful [Ok] value or an [Err] carrying a [Failure].
/// Forces callers to handle failure explicitly instead of relying on thrown
/// exceptions that the UI previously swallowed.
sealed class Result<T> {
  const Result();

  R fold<R>(R Function(T value) onOk, R Function(Failure failure) onErr) =>
      switch (this) {
        Ok<T>(:final value) => onOk(value),
        Err<T>(:final failure) => onErr(failure),
      };

  T? get valueOrNull => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>() => null,
      };

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}
```

- [ ] **Step 4: Run, expect pass.** Run: `flutter test test/core/error/result_test.dart` → PASS.

- [ ] **Step 5: Commit.** `git add lib/core/error/result.dart test/core/error/result_test.dart && git commit -m "feat(site): add sealed Result<T> error type"`

### Task 1.2: `Failure` sealed hierarchy

**Files:** Create `lib/core/error/failure.dart`; Test `test/core/error/failure_test.dart`

- [ ] **Step 1: Failing test**

```dart
// test/core/error/failure_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';

void main() {
  test('every Failure carries a non-empty Spanish message', () {
    final failures = <Failure>[
      const NetworkFailure(),
      const AuthFailure(),
      const NotFoundFailure(),
      const ValidationFailure('Correo inválido'),
      const ServerFailure(),
      const UnexpectedFailure(),
    ];
    for (final f in failures) {
      expect(f.message.trim(), isNotEmpty, reason: '${f.runtimeType} message');
    }
    expect(const ValidationFailure('x').message, 'x');
  });
}
```

- [ ] **Step 2: Run, expect fail.**

- [ ] **Step 3: Implement** (the sealed hierarchy: `Failure` base with `message`/`cause`; `NetworkFailure`, `AuthFailure`, `NotFoundFailure`, `ValidationFailure(String)`, `ServerFailure`, `UnexpectedFailure`, each with Spanish defaults — full code in spec §5; value identity via message+runtimeType).

- [ ] **Step 4: Run, expect pass.**

- [ ] **Step 5: Commit.** `feat(site): add sealed Failure hierarchy`

### Task 1.3: `failure_mapper.dart` (exceptions → Failure)

**Files:** Create `lib/core/error/failure_mapper.dart`; Test `test/core/error/failure_mapper_test.dart`

- [ ] **Step 1: Failing test** — assert `mapErrorToFailure(SocketException(''))` → `NetworkFailure`; a `PostgrestException(code:'PGRST116')` → `NotFoundFailure`; `code:'42501'` → `AuthFailure`; an unknown `Object` → `UnexpectedFailure`; a `Failure` passes through unchanged.
- [ ] **Step 2: Run, expect fail.**
- [ ] **Step 3: Implement** `mapErrorToFailure(Object, [StackTrace?])` handling `AuthException`, `PostgrestException` (codes), `StorageException`, `SocketException`/`TimeoutException`, pass-through `Failure`, else `UnexpectedFailure` (full code in spec §5 area).
- [ ] **Step 4: Run, expect pass.**
- [ ] **Step 5: Commit.** `feat(site): map driver exceptions to sealed Failure`

### Task 1.4: UI state atoms (loading / empty / error+retry)

**Files:** Create `lib/core/presentation/states/{app_loading_state,app_empty_state,app_error_state}.dart`; Test `test/core/presentation/state_atoms_test.dart`

- [ ] **Step 1: Failing widget test** — pump `AppErrorState(failure: NetworkFailure(), onRetry: () => tapped = true)`; assert the failure message text shows and a "Reintentar" button is present and invokes `onRetry`. Pump `AppEmptyState(message: 'Sin documentos')`; assert text shows. Pump `AppLoadingState()`; assert a progress indicator renders.
- [ ] **Step 2: Run, expect fail.**
- [ ] **Step 3: Implement** three small themed `StatelessWidget`s. `AppErrorState` shows an icon + `failure.message` + a "Reintentar" `OutlinedButton` (only if `onRetry != null`). `AppEmptyState` shows icon + message. `AppLoadingState` shows a centered indicator (dependency-light; swap to shimmer if confirmed in 1.0). Each ≤ ~80 lines.
- [ ] **Step 4: Run, expect pass.**
- [ ] **Step 5: Commit.** `feat(site): add loading/empty/error UI state atoms`

### Task 1.5: `FutureResultView<T>` (state-agnostic read wrapper)

**Files:** Create `lib/core/presentation/future_result_view.dart`; Test `test/core/presentation/future_result_view_test.dart`

- [ ] **Step 1: Failing widget test**

```dart
// asserts the THREE branches the app never handled before:
// 1) pending  -> AppLoadingState
// 2) throw    -> AppErrorState (mapped Failure) + Reintentar re-invokes loader
// 3) empty    -> AppEmptyState (via isEmpty predicate)
// 4) data     -> builder output
```
Concretely: pump `FutureResultView<List<int>>(loader: () async => throw const SocketException(''), isEmpty: (d) => d.isEmpty, builder: (d) => Text('n=${d.length}'))`; `await tester.pump()`; expect `find.text` of the network message + `find.text('Reintentar')`. Then a loader returning `[]` shows empty; returning `[1]` shows `n=1`.

- [ ] **Step 2: Run, expect fail.**
- [ ] **Step 3: Implement** a `StatefulWidget` holding `Future<T>? _future`; `initState`/`reload()` set `_future = widget.loader()`; `build` uses `FutureBuilder` mapping `snapshot.hasError` → `AppErrorState(mapErrorToFailure(snapshot.error!), onRetry: reload)`, waiting → `AppLoadingState`, data+`isEmpty` → `AppEmptyState`, else `builder(data)`. ≤ ~110 lines.
- [ ] **Step 4: Run, expect pass.**
- [ ] **Step 5: Commit.** `feat(site): add FutureResultView with loading/empty/error+retry`

### Task 1.6: `AsyncValueWidget<T>` (Riverpod adapter — only if 1.0 confirms riverpod)

**Files:** Create `lib/core/presentation/async_value_widget.dart`; Test `test/core/presentation/async_value_widget_test.dart`

- [ ] **Step 1: Failing test** — given an `AsyncValue<List<X>>` in loading/error/data/empty, assert the matching atom renders (error path maps via `mapErrorToFailure` and shows retry).
- [ ] **Step 2: Run, expect fail.**
- [ ] **Step 3: Implement** `.when(loading/error/data)` → atoms; `isEmpty` predicate → `AppEmptyState`; `onRetry` invalidates the provider. (If riverpod absent, implement an equivalent over `ValueListenable<AsyncSnapshot>` and note in change-log.)
- [ ] **Step 4: Run, expect pass.**
- [ ] **Step 5: Commit.** `feat(site): add AsyncValueWidget state adapter`

### Task 1.7: Phase-1 gate (evidence + diagram)

- [ ] Run `flutter analyze` (expect 0), `flutter test` (expect baseline+~15 new), record counts.
- [ ] Create/recompile `docs/uml/component-core-presentation.puml` (the foundation classes) → SVG.
- [ ] Append a change-log row; commit `docs(site): record Phase 1 foundation evidence + diagram`.

---

## PHASE 2 — Horizontal hardening (route every read through the foundation)

**Pattern per read (repeat for each row):** (1) write a widget test that makes the read's loader throw and asserts `AppErrorState` + "Reintentar" render (RED); (2) replace the bare `FutureBuilder` with `FutureResultView<T>` supplying `loader`, `isEmpty`, `builder` (GREEN); (3) `flutter analyze` + targeted test; (4) screenshot the error+empty states (`flutter test --update-goldens` for a golden, or manual capture); (5) commit `refactor(site): harden <read> with error/empty states`; (6) append change-log row.

### Task 2.1 (EXEMPLAR — full): Harden dashboard stats read

**Files:** Modify `lib/app/components/portal/dashboard_view.dart` (the `get_portal_stats` FutureBuilder, ~lines 50-60); Test `test/app/components/portal/dashboard_stats_error_test.dart`

- [ ] **Step 1: Failing test** — build the stats section with an injected loader that throws `PostgrestException`; `await tester.pump()`; expect server/network message + "Reintentar".
- [ ] **Step 2: Run, expect fail** (today it renders an empty grid, no error).
- [ ] **Step 3: Replace** `FutureBuilder<PortalStats>(future: _statsFuture, builder: waiting?shimmer:_StatsGrid(snapshot.data))` with `FutureResultView<PortalStats>(loader: () => PortalService.getPortalStats(userId), isEmpty: (s) => s.isEmpty, builder: (s) => _StatsGrid(stats: s))`.
- [ ] **Step 4: Run, expect pass.**
- [ ] **Step 5: Commit** + change-log row.

### Task 2.2–2.11 (enumerated reads — same pattern, exact sites):

| # | File | Read (type) | empty predicate |
|---|---|---|---|
| 2.2 | `lib/app/components/portal/documents_view.dart:~220` | documents `List<Document>` | `.isEmpty` |
| 2.3 | `lib/app/components/portal/billing_view.dart:~152` | invoices `List<Invoice>` | `.isEmpty` |
| 2.4 | `lib/app/components/portal/matters/matters_list.dart:~33` | matters `List<Matter>` | filtered `.isEmpty` |
| 2.5 | `lib/app/components/portal/calendar_view.dart:~221` | `PortalCalendarEntries` (DDD path) | `== empty` |
| 2.6 | `lib/app/components/portal/dashboard_view.dart` (other FutureBuilders) | recent items | `.isEmpty` |
| 2.7–2.11 | remaining `FutureBuilder`s found via `grep -rn 'FutureBuilder' lib` | per type | per type |

- [ ] For each: RED test → `FutureResultView<T>` swap → GREEN → analyze → screenshot → commit → change-log.
- [ ] **Phase-2 gate:** `grep -rn 'FutureBuilder' lib | wc -l` trending to 0 (or each remaining one justified); `flutter analyze` 0; recompile any affected component diagram; commit `docs(site): Phase 2 hardening evidence`.

---

## PHASE 3 — Vertical strangler slices (stub features → DDD)

**Per-slice task shape (applied to each of 3.A–3.D):**
1. RED domain test (entity/value-object rules) → implement `domain/` (pure Dart) → GREEN → commit.
2. RED use-case test (with in-memory fake repo) → implement port + `application/` use case → GREEN → commit.
3. RED actor test (intent → emitted state incl. error) → implement `actors/<X>Actor` → GREEN → commit.
4. Implement `infrastructure/` Supabase adapter (+ mapper) using `mapErrorToFailure`; wire into `core/di/dependency_injection.dart` → commit.
5. Rewire the legacy widget to the actor + foundation widgets (strangler); delete the stub/dead code → commit.
6. Recompile the context's `.puml` (+ class diagram) → SVG; append change-log; deploy checkpoint (Phase 4 sub-deploy optional).

### Slice 3.A (EXEMPLAR — contracts complete): Contact form

**New context `lib/domains/contact/`:**
- `domain/value_objects/email_address.dart` — `EmailAddress.parse(String) -> Result<EmailAddress>` (regex validate).
- `domain/value_objects/contact_message.dart` — non-empty, ≤2000 chars.
- `domain/entities/contact_inquiry.dart` — `{name, EmailAddress, phone?, ContactMessage, createdAt}`.
- `domain/repositories/contact_inquiry_repository.dart` — `abstract` port: `Future<Result<Unit>> submit(ContactInquiry)`.
- `application/submit_contact_inquiry_use_case.dart` — validates + calls port.
- `infrastructure/supabase_contact_inquiry_repository.dart` — `insert` into `contact_inquiries`; map errors.
- `actors/contact_form_actor.dart` — state: `idle | submitting | success | error(Failure)`; intent `submit(fields)`.

**Backend (authority granted):** create table via SQL applied to live Supabase (and tracked in `001-apps/001-site/supabase_migrations/20260528_create_contact_inquiries.sql`): `contact_inquiries(id uuid pk default gen_random_uuid(), name text, email text, phone text, message text, created_at timestamptz default now())`, RLS: `insert` for `anon`, `select` for admin (`auth.jwt()->'user_metadata'->>'role' = 'admin'`).

- [ ] Tasks per the per-slice shape; **acceptance:** submitting writes a row (verify `select count(*)`); UI shows typed success/error; fake-delay removed from `contact_form.dart`.

### Slice 3.B: Forgot-password (extend `auth`)
- `domain`: `AuthRepository` port gains `requestPasswordReset(EmailAddress, redirectTo)` + `updatePassword(newPassword)` → `Result<Unit>`.
- `application`: `RequestPasswordResetUseCase`, `ResetPasswordUseCase`.
- `actors`: `PasswordRecoveryActor` (states: idle/sending/sent/recovering/done/error).
- `infrastructure`: GoTrue `resetPasswordForEmail(email, redirectTo: '<site>/reset-password')` + `updateUser(password:)`.
- Presentation: replace `login_view.dart:57-63` stub with a real dialog/flow; add `lib/app/views/reset_password_view.dart` + router `/reset-password` handling `onAuthStateChange` `PASSWORD_RECOVERY`.
- Backend: add `<site>/reset-password` to GoTrue `additional_redirect_urls` (Supabase config; document the change).
- [ ] **Acceptance:** reset email sends; visiting the recovery link lands on `/reset-password`; new password persists; all states have error handling.

### Slice 3.C: Portal messaging (fix the dead future)
- New `domains/portal_messaging/`: `PortalMessage` entity; `PortalMessagingRepository` port (`recentMessages(userId)`, `thread(conversationId)`, `send(...)`, `markRead(...)`); use cases; `MessagingActor`.
- `infrastructure`: Supabase over `portal_messages` / `portal_messages_with_sender` view + `messages` table.
- Presentation: **fix `dashboard_view.dart` `_MessagesList`** to actually render via `AsyncValueWidget`/`FutureResultView` (remove the hardcoded "Cargando mensajes…" and the discarded future); rewire `messages_view.dart`.
- [ ] **Acceptance:** dashboard shows real recent messages with loading/empty/error; the dead future is gone (grep proves `_messagesFuture` is consumed).

### Slice 3.D: AI assistant (extend `ai_consultation`, harden)
- Extend with `AiConsultationRepository` port over the `chat` edge function + `conversations`/`messages`; `AiConsultationActor` managing send/stream/error/loading.
- Presentation: replace canned `'Error al procesar consulta.'` with typed `Failure` + retry; real loading/streaming states; reword the demo banner to be accurate (keep honest).
- Housekeeping: remove orphaned `lib/core/services/generative_service.dart` + its DI registration (dead code).
- Verify the `chat` function responds (live call with a test session); if it depends on the unapplied `ai_consultation_messages` migration, dry-run + apply (authority granted) and document.
- [ ] **Acceptance:** assistant surfaces real errors with retry; no canned string; banner accurate; DI has no orphan.

---

## PHASE 4 — Validation, deploy, rollback

### Task 4.1: Repo-wide validation
- [ ] `dart format lib test`; `flutter analyze` (expect 0); `flutter test` (expect ≫4, all green; record count + any coverage); `flutter build web --release`.
- [ ] `find lib -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart' -exec wc -l {} + | sort -rn | head` — confirm none >500. Split any offender (its own RED-GREEN commit) and recompile its diagram.

### Task 4.2: Recompile ALL diagrams
- [ ] `plantuml -tsvg docs/uml/*.puml 001-apps/001-site/docs/uml/*.puml`; commit `docs(site): recompile all UML/C4`.

### Task 4.3: Backup + deploy
- [ ] `sudo cp -a /var/www/new /var/www/backups/new-$(date +%Y%m%d-%H%M%S)` (timestamped rollback point).
- [ ] `sudo cp -r 001-apps/001-site/build/web/* /var/www/new/` (note: only touches the SPA root; the `/notarial-*` roots are separate and untouched).
- [ ] Verify deployed `index.html` still contains the legal-corpus bridge: `grep -c 'ja_supabase_access_token_b64' /var/www/new/index.html` → ≥1.

### Task 4.4: Smoke test + final report
- [ ] `curl -sS -o /dev/null -w '%{http_code}\n' https://justiciadministrativa.com/` → 200; fetch `main.dart.js` head; load `/asistente-ia`, `/login`, portal routes (manual/automated).
- [ ] Write `docs/refactor-runs/2026-05-28/final-report.md`: per-phase summary, before/after metrics (analyzer, tests, file sizes, FutureBuilder error-coverage), diagram index, deploy + rollback instructions, deferred items.
- [ ] Commit `docs(site): final report for completion+hardening arc`.

### Task 4.5: Rollback (documented, only if smoke test fails)
- [ ] `sudo rsync -a --delete /var/www/backups/new-<ts>/ /var/www/new/` then re-verify 200.

---

## Self-Review

**Spec coverage:** §6 Phase 0→Phase 0 tasks; Phase 1→Phase 1 tasks; Phase 2→Phase 2; Phase 3 slices→3.A–3.D; Phase 4→Phase 4. Reqs 4.1 (0.2,1.7,4.2), 4.2/4.3 (Phase 3 + foundation), 4.4 ≤500 (4.1) + no-brittle (0.4 + fakes), 4.5 (Phase 1–2), 4.6 (1.4), 4.7 (Phase 3 + 4.1) — all mapped. Acceptance criteria §10 → Phase 3 acceptances + 4.1/4.4.

**Placeholder scan:** Phases 0–1 have complete code/commands. Phases 2–3 use an explicit repeatable pattern + worked exemplar (2.1, 3.A contracts) + enumerated concrete sites/contracts — materialized at execution per the stated TDD methodology, not "TBD".

**Type consistency:** `Result<T>`/`Ok`/`Err`, `Failure` subclasses, `mapErrorToFailure`, `FutureResultView<T>`/`AsyncValueWidget<T>`, `AppLoadingState`/`AppEmptyState`/`AppErrorState`, `ContactInquiry`/`EmailAddress`/`ContactMessage`, `*Actor` names used consistently across tasks.
