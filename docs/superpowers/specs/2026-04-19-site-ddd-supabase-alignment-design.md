# Design: DDD scaffold for `001-site` aligned with Supabase backend

**Date:** 2026-04-19
**Status:** Draft — pending implementation plan
**Owner:** Emilio (decision-maker), Claude Code (drafter)
**Target codebase:** `/mnt/monorepository/JusticiaAdmin/001-apps/001-site/`
**Companion plan:** `/home/emilio/.claude/plans/elp-me-get-all-cozy-chipmunk.md` is unrelated (DNS); this is the source spec for the upcoming implementation plan.

---

## 1. Context

`001-site` (`justicia_administrativa_site`) is the public Flutter web app deployed to `/var/www/new` and served at `https://justiciadministrativa.com` / `www` / `new` / `demo`. It already declares `supabase_flutter: ^2.8.2`, `flutter_riverpod: ^2.6.1`, `go_router: ^16.1.0`, `get_it: ^8.0.0`, `freezed: ^2.5.7` and calls `Supabase.initialize()` in `main.dart`. **It does not yet use those tools in a Domain-Driven Design (DDD) shape.** Today's structure is a light-layered `lib/app/{components,views,router}` + `lib/core/{config,di,models,services,theme,utils}` arrangement. There are 9 routes, three of which are auth-gated (`portal`, `login`, `asistente-ia`), so the site is more than a brochure — there is a latent client portal that the current organization cannot cleanly support.

In parallel, the Supabase backend at `/mnt/supabase/` is rich:
- 16 tables in `public` (10 domain-relevant + 3 RAG embedding tables (system) + 2 auxiliary + 1 unused)
- 3 client-callable RPC functions: `match_documents`, `match_session_documents`, `get_portal_stats`
- 5 storage buckets (`clients` public; `chat-attachments`, `bjv-unam`, `scjn`, `segob` private)
- 6 Edge Functions (`chat`, `hyde-chat`, `agentic-chunker`, `cron-process-files`, `main`, `hello`)
- RLS enabled on 11 tables with owner/matter/admin scoping

The third Flutter app, `003-mobile` ("LexisRAG AI Platform"), already uses canonical clean-architecture / DDD layers (`core` / `domain` / `data` / `application` / `presentation`). It is the **template**, but it has known flaws (`Either<String, T>` instead of typed `Failure`, mock data in repository impls, GetIt+Riverpod coexisting redundantly, dual auth implementations) that this spec deliberately avoids inheriting.

## 2. Motivation

Two outcomes:

1. **Make `001-site`'s code organization match the data richness of the backend it talks to.** Today's flat `core/models/` and `core/services/` will not scale as portal pages (matters, documents, invoices, calendar, portal messages) come online. A proper DDD layout makes per-feature work isolated, testable, and reviewable.
2. **Establish the canonical Flutter DDD pattern in the monorepo.** `003-mobile` was the first attempt; this spec uses a fresh scaffold to fix the template's flaws so the *next* DDD work (including any mobile refactor) trends toward this improved shape.

This is **not** a UI rewrite. The presentation layer (`lib/app/`) stays untouched. The scaffold lands as new layers underneath; current screens keep using current services. Vertical-slice migrations are out of scope and will be planned separately, one screen at a time, after this scaffold is approved.

## 3. Scope

### In scope

- Add three new layer directories under `lib/`: `domain/`, `data/`, `application/`.
- Extend `lib/core/` with two new sub-folders: `core/errors/` (typed `Failure` hierarchy + `Result<T>`) and `core/supabase/` (typed `SupabaseClient` access + exception→`Failure` mapper).
- Define **10 table-backed domain entities** + **1 RPC return-type entity** (`PortalStats`) = **11 entities total** under `domain/entities/`.
- Define **11 abstract repository interfaces** in `domain/repositories/` — 10 for the entity tables plus a separate `AuthRepository` (auth uses `SupabaseClient.auth`, not a public-schema table, so it warrants its own interface).
- Define **use cases** in `domain/use_cases/`, grouped by bounded context (auth/portal/matters/chat/messages/blog), wrapping repository operations and the 3 RPC functions.
- Implement **11 concrete repositories** in `data/repositories/` that call Supabase via thin `data_sources/supabase/` wrappers and translate exceptions into `Failure`s.
- Define **11 `*_model.dart`** classes in `data/models/` (10 table-derived + `portal_stats_model.dart` for the RPC return) that extend their entities and add `fromJson`/`toJson`.
- Wire **Riverpod providers** in `application/providers/` (one file per bounded context) so that future presentation work has a typed, testable surface to consume.
- Mirror tests under `test/{domain,data,application}/` for every new file.
- Add a single dependency: `equatable: ^2.0.7` for entity value-equality.

### Out of scope (explicitly)

- Modifying any file under `lib/app/` (presentation).
- Rewriting any current screen or route to consume new providers.
- Adding any new pubspec dependency beyond `equatable`. Specifically: **no `dartz`, no `injectable`** — sealed classes and Riverpod cover those needs.
- Migrating `003-mobile` to this improved pattern (separate concern; this spec only sets the template).
- Touching the Supabase schema, edge functions, RLS policies, or storage buckets.
- Modeling tables that the site does not need: `tasks` (team-internal), the 3 RAG embedding tables (system-only), `file_processing_log` (system), `antidigital_djf` (unused — also flagged for cleanup but separately).
- Performance optimization, caching layer, offline support, optimistic updates — all left to future feature plans.
- Auth UI changes — current `login` screen keeps working as-is via existing `core/services/`.

## 4. Decisions made

| # | Decision | Rationale |
|---|---|---|
| D1 | Target = `001-site` only (not `002-web`, not unification) | User confirmed; `001-site` is the deployed public site |
| D2 | Scope = **architecture-only scaffold**; presentation untouched | User confirmed; lowest risk, sets foundation for future feature slices |
| D3 | Entity coverage = **10 site-relevant tables** + 3 RPCs | User confirmed; excludes `tasks` and system-only tables |
| D4 | Pattern = **Approach B — Improved DDD** (mirror mobile layers, fix template flaws) | User confirmed |
| D5 | Errors: typed `sealed class Failure` hierarchy + `sealed class Result<T>` (Success/Err) with a `fold()` extension | Modern Dart; no Dartz dependency. Records (`(Failure?, T?)`) considered and rejected — sealed classes give pattern-match exhaustiveness checks at compile time |
| D6 | DI: **Riverpod only**. Do not add new GetIt registrations. Existing `lib/core/di/` stays frozen | Single source of truth; mobile's GetIt+Riverpod overlap is the template flaw being fixed |
| D7 | Equatable for entity equality | One small dep (~3 KB), idiomatic, avoids `==`/`hashCode` boilerplate |
| D8 | Use cases grouped by bounded context (auth/portal/matters/chat/messages/blog), not per-entity | Reads like the user-facing surface; collocates related ops |
| D9 | No shared `value_objects/` folder yet (e.g. `Money`, `LocalizedText`) | YAGNI; introduce when first concrete need appears |
| D10 | No separate `infrastructure/` layer | `core/supabase/` covers SupabaseClient setup; introducing another layer adds ceremony with no payoff at this scale |
| D11 | Bounded-context use-case grouping uses Spanish-aware feature names where appropriate (e.g. `portal/`, `asuntos/` if preferred over `matters/`) | TBD with user before implementation; defaulting to English for now to match mobile-app naming |

## 5. Architecture

```
lib/
├── main.dart                          UPDATE: ProviderScope wraps app; Supabase.initialize stays
├── app/                               UNCHANGED — presentation; future migration target
│   ├── components/  views/  router.dart
├── core/                              KEEP + EXTEND
│   ├── config/  theme/  utils/        unchanged
│   ├── models/  services/             LEGACY — keep, do not modify; presentation depends on them
│   ├── di/                            LEGACY (GetIt) — frozen; new code uses Riverpod
│   ├── errors/                        NEW
│   │   ├── failure.dart               sealed class Failure { ServerFailure, AuthFailure,
│   │   │                                NetworkFailure, ValidationFailure(message,errors),
│   │   │                                NotFoundFailure, PermissionFailure, UnknownFailure }
│   │   └── result.dart                sealed Result<T> { Success<T>(value), Err<T>(failure) }
│   │                                  + extension Result<T>.fold<U>(onSuccess, onError)
│   └── supabase/                      NEW
│       ├── supabase_client_provider.dart
│       │                              Riverpod Provider<SupabaseClient> reading from
│       │                              already-initialized Supabase.instance
│       └── error_mapper.dart          mapException(Object e) -> Failure: catches
│                                      PostgrestException, AuthException, StorageException,
│                                      SocketException, TimeoutException
├── domain/                            NEW — pure Dart; no Supabase, no Flutter
│   ├── entities/
│   │   ├── profile.dart               Profile (id, fullName, company, phone, avatarUrl, ...)
│   │   ├── lawyer.dart                Lawyer (id, fullName, title, email, phone,
│   │   │                                avatarUrl, specialty, isActive)
│   │   ├── matter.dart                Matter (id, clientId, lawyerId, referenceCode, title,
│   │   │                                subtitle, MatterType, MatterStatus, lastUpdate, ...)
│   │   │                              + sealed enums MatterType, MatterStatus
│   │   ├── document.dart              Document (id, matterId, clientId, name, fileUrl,
│   │   │                                fileSize, mimeType, DocumentCategory, uploadedBy)
│   │   ├── invoice.dart               Invoice (id, clientId, matterId, invoiceNumber, amount,
│   │   │                                currency, InvoiceStatus, dueDate, paidAt, fileUrl)
│   │   ├── calendar_event.dart        CalendarEvent (id, clientId, matterId, title,
│   │   │                                description, EventType, eventDate, location)
│   │   ├── conversation.dart          Conversation (id, userId, title, createdAt, updatedAt)
│   │   ├── message.dart               Message (id, conversationId, MessageRole, content,
│   │   │                                metadata, createdAt)
│   │   ├── portal_message.dart        PortalMessage (id, matterId, senderId, SenderType,
│   │   │                                content, attachmentUrl, attachmentName, isRead)
│   │   ├── blog_post.dart             BlogPost (id, title, slug, excerpt, content, category,
│   │   │                                tags, imageUrl, authorName, authorRole, authorBio,
│   │   │                                readMinutes, viewsCount, isFeatured, isPublished,
│   │   │                                publishedAt, ...)
│   │   └── portal_stats.dart          PortalStats (activeMatters, totalDocuments,
│   │                                    upcomingEvents, pendingInvoices) — RPC return type
│   ├── repositories/                  abstract interfaces; signatures return Result<T>
│   │   ├── profiles_repository.dart   getCurrent(), update(Profile)
│   │   ├── lawyers_repository.dart    list(), getById(id)
│   │   ├── matters_repository.dart    listForCurrentUser(), getById(id),
│   │   │                                listByStatus(MatterStatus)
│   │   ├── documents_repository.dart  listForMatter(matterId), getById(id),
│   │   │                                upload(matterId, file, category)
│   │   ├── invoices_repository.dart   listForCurrentUser(), listForMatter(matterId)
│   │   ├── calendar_repository.dart   listUpcomingForCurrentUser(),
│   │   │                                listForMatter(matterId, range)
│   │   ├── conversations_repository.dart  listForCurrentUser(), getById(id),
│   │   │                                    create(title), delete(id)
│   │   ├── messages_repository.dart   listForConversation(conversationId),
│   │   │                                send(conversationId, role, content, metadata)
│   │   ├── portal_messages_repository.dart  listForMatter(matterId), markRead(id),
│   │   │                                      send(matterId, content, attachment)
│   │   ├── blog_repository.dart       listPublished({featured?}), getBySlug(slug)
│   │   └── auth_repository.dart       currentUser(), watchAuthState() Stream<Profile?>,
│   │                                    signInWithPassword(email, pwd), signOut()
│   └── use_cases/
│       ├── auth/                      SignIn, SignOut, WatchAuthState
│       ├── portal/                    GetPortalStats (calls RPC), ListMyMatters
│       ├── matters/                   GetMatter, ListMatterDocuments,
│       │                                ListMatterInvoices, ListMatterEvents,
│       │                                ListMatterPortalMessages
│       ├── chat/                      ListConversations, OpenConversation, SendMessage,
│       │                                MatchDocuments (RPC), MatchSessionDocuments (RPC)
│       ├── messages/                  MarkPortalMessageRead, SendPortalMessage
│       └── blog/                      ListBlogPosts, GetBlogPostBySlug
├── data/                              NEW — depends on domain + Supabase
│   ├── models/                        each extends entity, adds fromJson/toJson;
│   │                                  handles snake_case ↔ camelCase
│   │   profile_model.dart  lawyer_model.dart  matter_model.dart  document_model.dart
│   │   invoice_model.dart  calendar_event_model.dart  conversation_model.dart
│   │   message_model.dart  portal_message_model.dart  blog_post_model.dart
│   │   portal_stats_model.dart
│   ├── data_sources/supabase/         thin SupabaseClient wrappers; pure
│   │                                  thrown-exception API (no Result handling here)
│   │   profiles_data_source.dart  lawyers_data_source.dart  matters_data_source.dart
│   │   documents_data_source.dart  invoices_data_source.dart  calendar_data_source.dart
│   │   conversations_data_source.dart  messages_data_source.dart
│   │   portal_messages_data_source.dart  blog_data_source.dart   (10 table sources)
│   │   auth_data_source.dart          wraps SupabaseClient.auth (signIn, signOut,
│   │                                    onAuthStateChange) — NOT a public-schema table
│   │   rpc_data_source.dart           wraps the 3 RPC calls
│   │   storage_data_source.dart       wraps storage.from('clients'/'chat-attachments') ops
│   │                                  (13 data-source classes total)
│   └── repositories/                  *_repository_impl.dart for each domain interface;
│                                      each catches data-source exceptions, calls
│                                      core/supabase/error_mapper.dart, returns Result<T>
└── application/                       NEW — Riverpod providers (DI + state)
    └── providers/
        ├── auth_provider.dart         AsyncNotifier<Profile?> + sign-in/out methods
        ├── portal_provider.dart       FutureProvider<PortalStats>, AsyncNotifier matters list
        ├── matters_provider.dart      FamilyProvider for individual matter detail + child
        │                                lists (documents, invoices, events, portal messages)
        ├── chat_provider.dart         AsyncNotifier conversations, messages-per-conv,
        │                                RAG search providers
        ├── messages_provider.dart     portal messages per matter
        └── blog_provider.dart         blog list (published, featured) + getBySlug Family
```

### Architectural rules (verifiable later via lint or import audits)

1. `domain/` imports nothing app-specific — no `package:supabase_flutter`, no `dart:html`, no Flutter widgets, no `package:dio`.
2. `data/` imports `domain/` (interfaces + entities) and Supabase. Never imports `application/` or `app/`.
3. `application/` imports `domain/` only. Repository **implementations** are wired in via Riverpod overrides at app startup (`ProviderScope(overrides: [...])` in `main.dart`).
4. `core/errors/` and `core/supabase/` import nothing app-specific (pure plumbing).
5. `app/` (presentation) keeps importing today's `core/services/` until a future vertical slice migrates it. New code must not import `core/models/` or `core/services/`.
6. Tests under `test/{domain,data,application}/` mirror `lib/`. Do not modify existing tests under `test/main_test.dart` or anywhere already in use.

## 6. Components — entity/repository/use-case inventory

For each of the 10 entities + 1 RPC return type, the scaffold creates the same set of files. The pattern is identical; the table below shows the per-entity inputs, not new design decisions.

| # | Entity | Source table | Repository ops | Bounded context |
|---|---|---|---|---|
| 1 | `Profile` | `profiles` (1:1 with `auth.users`) | `getCurrent`, `update` | auth |
| 2 | `Lawyer` | `lawyers` | `list`, `getById` | matters |
| 3 | `Matter` | `matters` | `listForCurrentUser`, `getById`, `listByStatus` | portal, matters |
| 4 | `Document` | `documents` | `listForMatter`, `getById`, `upload` | matters |
| 5 | `Invoice` | `invoices` | `listForCurrentUser`, `listForMatter` | portal, matters |
| 6 | `CalendarEvent` | `calendar_events` | `listUpcomingForCurrentUser`, `listForMatter` | portal, matters |
| 7 | `Conversation` | `conversations` | `listForCurrentUser`, `getById`, `create`, `delete` | chat |
| 8 | `Message` | `messages` | `listForConversation`, `send` | chat |
| 9 | `PortalMessage` | `portal_messages` | `listForMatter`, `markRead`, `send` | messages |
| 10 | `BlogPost` | `blog_posts` | `listPublished`, `getBySlug` | blog |
| RPC | `PortalStats` | `get_portal_stats(user_id)` | (use case only — no repository) | portal |
| RPC | (chat hits) | `match_documents` | (use case only) | chat |
| RPC | (chat hits) | `match_session_documents` | (use case only) | chat |

Repository implementations call into per-table data sources (`data/data_sources/supabase/*_data_source.dart`), which in turn call `SupabaseClient.from('table').select()/insert()/update()/delete()` or `.rpc('function_name', params: ...)`. The data-source layer **throws** Supabase exceptions; the repository layer **catches and maps** them via `core/supabase/error_mapper.dart` → typed `Failure` → returns `Result<T>`.

## 7. Data flow (illustrative trace)

End-to-end for "client opens portal dashboard, sees stats and matters" (a hypothetical future screen — the *trace* is the design contract; the *screen* is out of scope):

```
presentation (future)        ref.watch(portalStatsProvider)
                                   │
application/providers        portalStatsProvider = FutureProvider<PortalStats> {
                                ref.read(getPortalStatsUseCaseProvider).call()
                             }
                                   │
domain/use_cases/portal      class GetPortalStatsUseCase {
                                final PortalRepository repo;
                                Future<Result<PortalStats>> call() => repo.getStats();
                             }
                                   │  (interface dependency)
domain/repositories          abstract class PortalRepository {
                                Future<Result<PortalStats>> getStats();
                             }
                                   │  (Riverpod override binds impl at app start)
data/repositories            class PortalRepositoryImpl implements PortalRepository {
                                final RpcDataSource rpc;
                                Future<Result<PortalStats>> getStats() async {
                                  try {
                                    final json = await rpc.getPortalStats();
                                    return Success(PortalStatsModel.fromJson(json));
                                  } catch (e) { return Err(mapException(e)); }
                                }
                             }
                                   │
data/data_sources/supabase   class RpcDataSource {
                                final SupabaseClient client;
                                Future<Map<String,dynamic>> getPortalStats() =>
                                  client.rpc('get_portal_stats',
                                             params: {'user_id': client.auth.currentUser!.id});
                             }
                                   │
Supabase                     execution against PostgreSQL via PostgREST
```

The same shape applies to every other operation. Errors short-circuit at the repository boundary (no exceptions cross into `application/` or `domain/`).

## 8. Error handling

`core/errors/failure.dart`:

```dart
sealed class Failure {
  final String message;
  final String? code;
  const Failure(this.message, {this.code});
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}
final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}
final class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;
  const ValidationFailure(super.message, {this.fieldErrors = const {}});
}
final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}
final class PermissionFailure extends Failure {  // RLS denial, missing role, etc.
  const PermissionFailure(super.message, {super.code});
}
final class UnknownFailure extends Failure {
  final Object? cause;
  const UnknownFailure(super.message, {this.cause});
}
```

`core/errors/result.dart`:

```dart
sealed class Result<T> {
  const Result();
  R fold<R>(R Function(T) onSuccess, R Function(Failure) onError);
}
final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
  @override R fold<R>(R Function(T) onSuccess, R Function(Failure) _) => onSuccess(value);
}
final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
  @override R fold<R>(R Function(T) _, R Function(Failure) onError) => onError(failure);
}
```

`core/supabase/error_mapper.dart`:

```dart
Failure mapException(Object e, [StackTrace? st]) {
  if (e is AuthException)       return AuthFailure(e.message, code: e.statusCode);
  if (e is PostgrestException) {
    if (e.code == 'PGRST116')   return NotFoundFailure(e.message);
    if (e.code?.startsWith('42501') ?? false)
                                return PermissionFailure(e.message, code: e.code);
    return ServerFailure(e.message, code: e.code);
  }
  if (e is StorageException)    return ServerFailure(e.message, code: e.statusCode);
  if (e is SocketException)     return NetworkFailure(e.message);
  if (e is TimeoutException)    return NetworkFailure('Request timed out');
  return UnknownFailure(e.toString(), cause: e);
}
```

This contract is what makes the `Result<T>` type pay off: `application/` providers can switch on the `Failure` subtype to render different UI (toast vs banner vs redirect-to-login) without parsing strings.

## 9. Dependency changes (`pubspec.yaml`)

Add **one line** under `dependencies:`:

```yaml
  equatable: ^2.0.7
```

Do **not** add `dartz`, `injectable`, or `injectable_generator`. The existing `freezed`, `json_serializable`, `build_runner`, `riverpod_generator`, `flutter_riverpod`, `supabase_flutter`, `dio`, and `get_it` already cover everything needed (note: `get_it` stays in pubspec for the legacy `core/di/`, but no new code touches it).

`flutter pub get` after the bump. `dart run build_runner build --delete-conflicting-outputs` if any model uses `freezed` or `json_serializable` (proposed: yes, for models with non-trivial JSON like `BlogPost.tags` or `Matter.matterType`).

## 10. Testing strategy

Mirror `test/` to `lib/` for the new layers. Concretely:

- **`test/domain/entities/*_test.dart`** — for each entity: equality, copyWith, props ordering. ~5 lines per test, one test per entity. Trivial but catches accidental field omissions.
- **`test/domain/use_cases/<bounded_context>/*_test.dart`** — instantiate a fake `Repository` (just an inline class in the test file), assert that the use case forwards arguments and returns the right `Result<T>` shape. ~15 lines per use case.
- **`test/data/models/*_test.dart`** — round-trip JSON: `fromJson(toJson(model)) == model`. One per model.
- **`test/data/repositories/*_test.dart`** — instantiate the repository with a fake `DataSource`, assert exception-mapping (e.g. throwing a `PostgrestException` with code `42501` produces `Err(PermissionFailure(...))`). One per repository, ~20 lines.
- **`test/application/providers/*_test.dart`** — use Riverpod's `ProviderContainer` with overrides to inject a fake repository, drive the provider through a happy-path and a failure-path, assert state transitions. One per provider, ~30 lines.
- **`test/data/supabase/error_mapper_test.dart`** — table-driven test mapping each known exception type → expected `Failure` subtype. ~50 lines.
- **`test/architecture/import_hygiene_test.dart`** *(optional)* — uses `dart:io` to walk source files and assert that no file under `domain/` imports `package:supabase_flutter` or Flutter. Cheap, catches drift over time.

CI gating: all new tests run under `flutter test`. The existing `test/main_test.dart` (or whatever the site has today) is unmodified. Coverage gate is *not* introduced in this scaffold (no policy change).

## 11. Coexistence policy (legacy ↔ new)

- `lib/core/models/` and `lib/core/services/` stay in place for the lifetime of this scaffold. They are consumed by `lib/app/` (presentation) and removing them would break the build.
- Any future vertical slice that migrates a screen MUST: (a) replace usage of legacy `core/services/` with the new providers, (b) delete the now-orphaned legacy file in the same PR.
- New code under `domain/`, `data/`, `application/` MUST NOT import legacy `core/models/` or `core/services/`. This is the cleanest enforcement of the boundary; the optional `import_hygiene_test.dart` makes it automatic.
- `lib/core/di/` (the existing GetIt registry) is frozen — no new registrations. Its current users in legacy services keep working.

## 12. Open questions for implementation phase

1. **Naming language**: should bounded-context folders use English (`portal/`, `matters/`, `chat/`) or Spanish-aligned (`portal/`, `asuntos/`, `chat/`, `mensajes/`)? Default: English to match `003-mobile`. Decide before generating code.
2. **`Matter` enums (`MatterType`, `MatterStatus`)** are currently database-level enums in PostgreSQL. The implementation plan must specify whether to mirror them as Dart enums (keeping in sync requires manual diligence) or model them as `String` with private constants (lower fidelity, no compile-time exhaustiveness). Recommendation: mirror as Dart enums; add a CI check that diffs against `\dT public.*` output.
3. **`message.metadata` is `jsonb`**. The implementation plan must decide between (a) `Map<String, dynamic>` (flexible, untyped), (b) a sealed class hierarchy of known metadata shapes (typed, brittle), or (c) `freezed` union (typed + extensible). Recommendation: (a) for now, since this is scaffold-only and downstream consumers don't exist yet.
4. **Auth token / session refresh**: `supabase_flutter` handles this internally, but the `auth_provider.dart` design must expose `Stream<AuthState>` so the eventual auth-gating in `presentation` can react to `signedOut` events (e.g. forced redirect to `/login`). Confirm the Stream is part of the scaffold (it is in this design) before implementation.
5. **Storage uploads**: `documents.upload(...)` and `portal_messages.send(..., attachment)` need to coordinate `storage.from('clients').upload()` with `documents` / `portal_messages` row insertion. Decide transaction semantics (best-effort: insert row first with `file_url=null`, upload, patch URL — vs. upload-then-insert). Recommendation: upload first; if insert fails, leave the orphan in storage and log a warning. Alternatives can be debated in the implementation plan.

6. **`match_documents` / `match_session_documents` return type**: these RPCs return rows from `document_embeddings` / `session_embeddings` (chunk_text + metadata + similarity score), not from the `documents` table. Where should this shape live? Options: (a) a `DocumentChunk` value object inside `domain/use_cases/chat/` (keeps entity count at 11; chunk is a chat-bounded-context concern); (b) a 12th entity in `domain/entities/document_chunk.dart` (parallel to `portal_stats.dart`); (c) return raw `List<Map<String,dynamic>>` from the use cases for now and let the future chat-screen vertical slice define the type. **Recommendation: (a)** — the chunk only exists to be rendered as a chat citation, so collocating it with the chat use cases keeps `domain/entities/` as the canonical-table-shape directory.

## 13. Acceptance criteria

The scaffold is "done" when **all** of the following hold:

- [ ] `flutter analyze` passes with zero new warnings.
- [ ] `flutter test` passes including all new tests under `test/{domain,data,application}/` and `test/data/supabase/error_mapper_test.dart`.
- [ ] `flutter build web --release` produces an output identical (modulo timestamps) to today's build — i.e. no UI change. A byte-diff of `build/web/` against the current production deploy should differ only in compiled-Dart artifacts that include the new layers as dead code, not in any rendered output.
- [ ] All 11 entities (10 table-derived + `PortalStats`) exist under `domain/entities/`, all 11 abstract repositories (10 table + `auth_repository`) under `domain/repositories/`, all use cases under `domain/use_cases/<bounded_context>/`, all 11 model classes (10 table + `portal_stats_model`) under `data/models/`, all 13 data-source classes (10 table + `auth_data_source`, `rpc_data_source`, `storage_data_source`) under `data/data_sources/supabase/`, all 11 repository impls under `data/repositories/`, all 6 provider files under `application/providers/`.
- [ ] `core/errors/{failure.dart,result.dart}` and `core/supabase/{supabase_client_provider.dart,error_mapper.dart}` exist.
- [ ] Import-hygiene check (manual or via the optional test) confirms `domain/` has no Supabase/Flutter imports, `data/` does not import `application/` or `app/`, and no new file imports legacy `core/{models,services}/`.
- [ ] `pubspec.yaml` adds **only** `equatable`. No other dependency changes.
- [ ] No file under `lib/app/`, `lib/core/{config,theme,utils,models,services,di}` is modified by the scaffold PR (only additions).

## 14. Hand-off

After this spec is approved by the user, the **writing-plans** skill produces the step-by-step implementation plan that takes this design and turns it into ordered, reviewable PR tasks. No other implementation skill is invoked between brainstorming and writing-plans.
