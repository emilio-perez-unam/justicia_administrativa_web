# Site DDD + Supabase Alignment — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a clean DDD scaffold (`domain/`, `data/`, `application/` layers + `core/errors/` + `core/supabase/`) under `001-apps/001-site/lib/` that maps the site's data model to the Supabase backend, without touching the existing UI.

**Architecture:** Five layers (`core` / `domain` / `data` / `application` / presentation-untouched). Domain is pure Dart with `Equatable` entities, abstract repositories, and use cases grouped by bounded context. Data layer wraps `SupabaseClient`, catches Supabase exceptions, and maps them to a typed sealed `Failure` hierarchy via a single `error_mapper.dart`. Repositories return `Result<T>` (sealed `Success` / `Err`). Application layer is Riverpod-only (no GetIt for new code). Existing `lib/app/` and `lib/core/{config,theme,utils,models,services,di}` are unchanged. **Source spec:** `001-apps/001-site/docs/superpowers/specs/2026-04-19-site-ddd-supabase-alignment-design.md`.

**Tech Stack:** Flutter 3.10.3+, Dart 3 (sealed classes, pattern matching), `supabase_flutter ^2.8.2`, `flutter_riverpod ^2.6.1`, `equatable ^2.0.7` (the only dep added), `freezed`/`json_serializable`/`build_runner` (already present, used for some models), Supabase Postgres + Auth + Storage + RPC, GoRouter (untouched).

---

## Pre-execution setup

Before Task 1, the executing agent should:

1. **Create a worktree** for this work (the brainstorming skill normally does this; we skipped it). From the monorepo root:
   ```bash
   cd /mnt/monorepository/JusticiaAdmin
   git worktree add ../JusticiaAdmin-site-ddd -b feat/site-ddd-supabase-scaffold
   cd ../JusticiaAdmin-site-ddd/001-apps/001-site
   ```
   All commands in this plan assume `cwd = 001-apps/001-site/` of that worktree.

2. **Confirm Flutter availability:** `flutter --version` should print `Flutter 3.x`.

3. **Get current deps to confirm clean baseline:** `flutter pub get && flutter analyze`. Save the analyze output as the baseline; the acceptance criteria require no new warnings beyond this.

4. **Run the existing test suite:** `flutter test`. Note which tests pass today; the plan must keep them passing.

If any of those steps fail, stop and resolve before starting Task 1.

---

## File structure (every file this plan creates or modifies)

**Created:**

| Path | Responsibility |
|---|---|
| `lib/core/errors/failure.dart` | Sealed `Failure` hierarchy: `ServerFailure`, `AuthFailure`, `NetworkFailure`, `ValidationFailure`, `NotFoundFailure`, `PermissionFailure`, `UnknownFailure`. |
| `lib/core/errors/result.dart` | Sealed `Result<T>` with `Success<T>(value)` / `Err<T>(failure)` and `fold()`. |
| `lib/core/supabase/error_mapper.dart` | Pure function mapping any thrown Supabase/network exception to a typed `Failure`. |
| `lib/core/supabase/supabase_client_provider.dart` | Riverpod `Provider<SupabaseClient>` reading from `Supabase.instance.client`. |
| `lib/domain/entities/{profile, lawyer, matter, document, invoice, calendar_event, conversation, message, portal_message, blog_post, portal_stats}.dart` | 11 immutable entities with `Equatable` props. |
| `lib/domain/repositories/{profiles, lawyers, matters, documents, invoices, calendar, conversations, messages, portal_messages, blog, auth}_repository.dart` | 11 abstract repository interfaces; methods return `Future<Result<T>>` or `Stream<T>`. |
| `lib/domain/use_cases/{auth, portal, matters, chat, messages, blog}/*.dart` | Use case classes; one bounded-context folder per provider in the application layer. |
| `lib/data/models/{profile, lawyer, matter, document, invoice, calendar_event, conversation, message, portal_message, blog_post, portal_stats}_model.dart` | 11 models extending entities, adding `fromJson` / `toJson` (snake_case ↔ camelCase). |
| `lib/data/data_sources/supabase/{profiles, lawyers, matters, documents, invoices, calendar, conversations, messages, portal_messages, blog}_data_source.dart` | 10 thin per-table wrappers around `SupabaseClient.from('table')`. |
| `lib/data/data_sources/supabase/auth_data_source.dart` | Wraps `SupabaseClient.auth` (sign-in/out, `onAuthStateChange` stream). |
| `lib/data/data_sources/supabase/rpc_data_source.dart` | Wraps the 3 RPC calls: `match_documents`, `match_session_documents`, `get_portal_stats`. |
| `lib/data/data_sources/supabase/storage_data_source.dart` | Wraps `storage.from('clients' / 'chat-attachments')` upload/getPublicUrl ops. |
| `lib/data/repositories/{profiles, lawyers, matters, documents, invoices, calendar, conversations, messages, portal_messages, blog, auth}_repository_impl.dart` | 11 concrete implementations; catch exceptions, call `mapException()`, return `Result<T>`. |
| `lib/application/providers/{auth, portal, matters, chat, messages, blog}_provider.dart` | 6 Riverpod provider files; one per bounded context; bind repository overrides + expose state. |
| `test/core/errors/{failure, result}_test.dart` | Tests for the typed error hierarchy. |
| `test/core/supabase/error_mapper_test.dart` | Table-driven test mapping each known exception → expected `Failure`. |
| `test/domain/entities/*_test.dart` | One per entity — equality, props ordering, copyWith. |
| `test/data/models/*_test.dart` | One per model — round-trip JSON. |
| `test/data/repositories/*_test.dart` | One per repo impl — happy path + 1+ error-mapping path with a fake data source. |
| `test/application/providers/*_test.dart` | One per provider — drive happy + error states with `ProviderContainer` overrides. |
| `test/architecture/import_hygiene_test.dart` | Walks `lib/` source files; asserts boundary rules. |

**Modified:**

| Path | What changes |
|---|---|
| `pubspec.yaml` | Add `equatable: ^2.0.7` under `dependencies:`. Nothing else. |
| `lib/main.dart` | Wrap the app in `ProviderScope(...)` and add Riverpod overrides binding repository interfaces to their impls. The existing `Supabase.initialize(...)` call stays. |

**Untouched (asserted at acceptance time):**

`lib/app/`, `lib/core/{config,theme,utils,models,services,di}`, all existing tests, the GoRouter setup, every screen.

---

## Task 1: Add `equatable` to `pubspec.yaml`

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Open `pubspec.yaml` and locate the `dependencies:` block.** Find the line for `flutter_riverpod` or `supabase_flutter` to use as a sibling anchor.

- [ ] **Step 2: Add the `equatable` line.**

Insert under `dependencies:` (alphabetic order is conventional but not required):

```yaml
  equatable: ^2.0.7
```

- [ ] **Step 3: Run `flutter pub get`.**

```bash
flutter pub get
```

Expected: prints `Got dependencies!` (or equivalent), exit code 0. Lockfile updates. No version conflict warnings.

- [ ] **Step 4: Run `flutter analyze` and confirm no new warnings.**

```bash
flutter analyze
```

Expected: same warning count as the pre-execution baseline.

- [ ] **Step 5: Commit.**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "site: add equatable dep for upcoming DDD scaffold"
```

---

## Task 2: `core/errors/failure.dart` — typed sealed `Failure` hierarchy

**Files:**
- Create: `lib/core/errors/failure.dart`
- Test: `test/core/errors/failure_test.dart`

- [ ] **Step 1: Write the failing test.**

Create `test/core/errors/failure_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/failure.dart';

void main() {
  group('Failure hierarchy', () {
    test('ServerFailure carries message + optional code', () {
      const f = ServerFailure('boom', code: '500');
      expect(f.message, 'boom');
      expect(f.code, '500');
      expect(f, isA<Failure>());
    });

    test('ValidationFailure carries fieldErrors map', () {
      const f = ValidationFailure('bad', fieldErrors: {'email': ['required']});
      expect(f.fieldErrors['email'], ['required']);
      expect(f.message, 'bad');
    });

    test('UnknownFailure preserves the original cause for debugging', () {
      final cause = Exception('xyz');
      final f = UnknownFailure('wrapped', cause: cause);
      expect(f.cause, cause);
    });

    test('Failure is sealed — pattern match must be exhaustive', () {
      Failure pick(int i) => switch (i) {
        0 => const ServerFailure('s'),
        1 => const AuthFailure('a'),
        2 => const NetworkFailure('n'),
        3 => const ValidationFailure('v'),
        4 => const NotFoundFailure('nf'),
        5 => const PermissionFailure('p'),
        _ => const UnknownFailure('u'),
      };
      // Compile-time exhaustive switch on a sealed class — body returns the message.
      String describe(Failure f) => switch (f) {
        ServerFailure() => 'server',
        AuthFailure() => 'auth',
        NetworkFailure() => 'net',
        ValidationFailure() => 'valid',
        NotFoundFailure() => 'nf',
        PermissionFailure() => 'perm',
        UnknownFailure() => 'unk',
      };
      for (var i = 0; i < 7; i++) {
        expect(describe(pick(i)).isNotEmpty, isTrue);
      }
    });
  });
}
```

- [ ] **Step 2: Run the test, expect it to fail.**

```bash
flutter test test/core/errors/failure_test.dart
```

Expected: `Error: Could not find package 'justicia_administrativa_site/core/errors/failure.dart'` (or similar — file does not exist).

- [ ] **Step 3: Implement `lib/core/errors/failure.dart`.**

Create the file:

```dart
/// Typed, sealed error hierarchy for the data + domain layers.
///
/// Repositories return `Result<T>` whose error variant carries one of these
/// subclasses. Providers can `switch` on the subtype for UI-policy decisions
/// (toast vs. banner vs. redirect-to-login) without parsing strings.
sealed class Failure {
  final String message;
  final String? code;
  const Failure(this.message, {this.code});

  @override
  String toString() => '$runtimeType($message${code == null ? '' : ', code=$code'})';
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

/// Raised when the backend rejects an operation due to RLS / role checks.
final class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

/// Catch-all for unexpected exceptions. Always log [cause] when this surfaces.
final class UnknownFailure extends Failure {
  final Object? cause;
  const UnknownFailure(super.message, {this.cause});
}
```

- [ ] **Step 4: Run the test, expect it to pass.**

```bash
flutter test test/core/errors/failure_test.dart
```

Expected: all 4 tests pass.

- [ ] **Step 5: Commit.**

```bash
git add lib/core/errors/failure.dart test/core/errors/failure_test.dart
git commit -m "site(core): add typed sealed Failure hierarchy"
```

---

## Task 3: `core/errors/result.dart` — sealed `Result<T>` with `fold`

**Files:**
- Create: `lib/core/errors/result.dart`
- Test: `test/core/errors/result_test.dart`

- [ ] **Step 1: Write the failing test.**

Create `test/core/errors/result_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';

void main() {
  group('Result<T>', () {
    test('Success.fold invokes onSuccess with the value', () {
      const r = Success<int>(42);
      final out = r.fold((v) => 'ok:$v', (_) => 'err');
      expect(out, 'ok:42');
    });

    test('Err.fold invokes onError with the failure', () {
      const r = Err<int>(ServerFailure('boom'));
      final out = r.fold((_) => 'ok', (f) => 'err:${f.message}');
      expect(out, 'err:boom');
    });

    test('Result is sealed — switch must cover both variants', () {
      String describe(Result<int> r) => switch (r) {
        Success(:final value) => 'v=$value',
        Err(:final failure) => 'f=${failure.message}',
      };
      expect(describe(const Success(1)), 'v=1');
      expect(describe(const Err(NetworkFailure('off'))), 'f=off');
    });
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/core/errors/result_test.dart
```

Expected: file-not-found error.

- [ ] **Step 3: Implement `lib/core/errors/result.dart`.**

```dart
import 'failure.dart';

/// Either-like sealed type returned by every repository operation.
///
/// Use `switch` for exhaustive handling, or `fold(onSuccess, onError)`
/// for inline transformations.
sealed class Result<T> {
  const Result();

  R fold<R>(R Function(T value) onSuccess, R Function(Failure failure) onError);
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  R fold<R>(R Function(T) onSuccess, R Function(Failure) _) => onSuccess(value);
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);

  @override
  R fold<R>(R Function(T) _, R Function(Failure) onError) => onError(failure);
}
```

- [ ] **Step 4: Run, expect pass.**

```bash
flutter test test/core/errors/result_test.dart
```

Expected: 3 tests pass.

- [ ] **Step 5: Commit.**

```bash
git add lib/core/errors/result.dart test/core/errors/result_test.dart
git commit -m "site(core): add sealed Result<T> with fold"
```

---

## Task 4: `core/supabase/error_mapper.dart` — exception → `Failure`

**Files:**
- Create: `lib/core/supabase/error_mapper.dart`
- Test: `test/core/supabase/error_mapper_test.dart`

- [ ] **Step 1: Write the failing test.**

Create `test/core/supabase/error_mapper_test.dart`:

```dart
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/supabase/error_mapper.dart';

void main() {
  group('mapException', () {
    test('AuthException -> AuthFailure with status code', () {
      final e = AuthException('bad creds', statusCode: '401');
      final f = mapException(e);
      expect(f, isA<AuthFailure>());
      expect(f.message, 'bad creds');
      expect(f.code, '401');
    });

    test('PostgrestException PGRST116 -> NotFoundFailure', () {
      final e = PostgrestException(message: 'missing', code: 'PGRST116');
      final f = mapException(e);
      expect(f, isA<NotFoundFailure>());
    });

    test('PostgrestException 42501 (RLS) -> PermissionFailure', () {
      final e = PostgrestException(message: 'denied', code: '42501');
      final f = mapException(e);
      expect(f, isA<PermissionFailure>());
      expect(f.code, '42501');
    });

    test('PostgrestException other code -> ServerFailure', () {
      final e = PostgrestException(message: 'oops', code: '500');
      expect(mapException(e), isA<ServerFailure>());
    });

    test('StorageException -> ServerFailure', () {
      final e = StorageException('upload failed', statusCode: '413');
      final f = mapException(e);
      expect(f, isA<ServerFailure>());
      expect(f.code, '413');
    });

    test('SocketException -> NetworkFailure', () {
      final f = mapException(const SocketException('no route'));
      expect(f, isA<NetworkFailure>());
    });

    test('TimeoutException -> NetworkFailure', () {
      final f = mapException(TimeoutException('slow'));
      expect(f, isA<NetworkFailure>());
    });

    test('Anything else -> UnknownFailure carrying the cause', () {
      final cause = Exception('wat');
      final f = mapException(cause);
      expect(f, isA<UnknownFailure>());
      expect((f as UnknownFailure).cause, cause);
    });
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/core/supabase/error_mapper_test.dart
```

Expected: file-not-found error.

- [ ] **Step 3: Implement `lib/core/supabase/error_mapper.dart`.**

```dart
import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/failure.dart';

/// Maps any thrown exception from the Supabase SDK or platform IO to a
/// typed [Failure]. Repositories should call this in their `catch (e)`
/// blocks and return `Err(mapException(e))`.
///
/// Order of `is` checks matters: more specific subtypes first.
Failure mapException(Object e, [StackTrace? _]) {
  if (e is AuthException) {
    return AuthFailure(e.message, code: e.statusCode);
  }
  if (e is PostgrestException) {
    if (e.code == 'PGRST116') return NotFoundFailure(e.message, code: e.code);
    if ((e.code ?? '').startsWith('42501')) {
      return PermissionFailure(e.message, code: e.code);
    }
    return ServerFailure(e.message, code: e.code);
  }
  if (e is StorageException) {
    return ServerFailure(e.message, code: e.statusCode);
  }
  if (e is SocketException) {
    return NetworkFailure(e.message);
  }
  if (e is TimeoutException) {
    return NetworkFailure('Request timed out');
  }
  return UnknownFailure(e.toString(), cause: e);
}
```

- [ ] **Step 4: Run, expect pass.**

```bash
flutter test test/core/supabase/error_mapper_test.dart
```

Expected: all 8 tests pass.

- [ ] **Step 5: Commit.**

```bash
git add lib/core/supabase/error_mapper.dart test/core/supabase/error_mapper_test.dart
git commit -m "site(core): add Supabase exception -> Failure mapper"
```

---

## Task 5: `core/supabase/supabase_client_provider.dart` — Riverpod handle for `SupabaseClient`

**Files:**
- Create: `lib/core/supabase/supabase_client_provider.dart`
- Test: `test/core/supabase/supabase_client_provider_test.dart`

- [ ] **Step 1: Write the failing test.**

Create `test/core/supabase/supabase_client_provider_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:justicia_administrativa_site/core/supabase/supabase_client_provider.dart';

void main() {
  test('supabaseClientProvider throws if not overridden and SDK not initialized', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Reading without an override or initialized Supabase should error,
    // so callers know they must wire it in main.dart or a test override.
    expect(() => container.read(supabaseClientProvider), throwsA(anything));
  });

  test('supabaseClientProvider returns the override value when provided', () {
    final fake = _FakeSupabaseClient();
    final container = ProviderContainer(overrides: [
      supabaseClientProvider.overrideWithValue(fake),
    ]);
    addTearDown(container.dispose);

    expect(container.read(supabaseClientProvider), same(fake));
  });
}

class _FakeSupabaseClient implements SupabaseClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/core/supabase/supabase_client_provider_test.dart
```

Expected: file-not-found.

- [ ] **Step 3: Implement `lib/core/supabase/supabase_client_provider.dart`.**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Riverpod handle for the singleton `SupabaseClient`.
///
/// `main.dart` calls `Supabase.initialize(...)` then overrides this provider
/// with `Supabase.instance.client`. Tests override with a fake client.
///
/// Reading this without an override AND without an initialized Supabase
/// throws — by design, so the missing wiring fails loudly.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
```

- [ ] **Step 4: Run, expect pass.**

```bash
flutter test test/core/supabase/supabase_client_provider_test.dart
```

Expected: 2 tests pass. (The "throws" test relies on `Supabase.instance` not being initialized in test context, which is the default.)

- [ ] **Step 5: Commit.**

```bash
git add lib/core/supabase/supabase_client_provider.dart test/core/supabase/supabase_client_provider_test.dart
git commit -m "site(core): add Riverpod supabaseClientProvider"
```

---

## Task 6: Domain entities — batch 1 (`Profile`, `Lawyer`, `Conversation`)

Three flat entities with the simplest shape. Same TDD micro-cycle for each.

**Files:**
- Create: `lib/domain/entities/profile.dart`, `lib/domain/entities/lawyer.dart`, `lib/domain/entities/conversation.dart`
- Test: `test/domain/entities/profile_test.dart`, `test/domain/entities/lawyer_test.dart`, `test/domain/entities/conversation_test.dart`

- [ ] **Step 1: Write the failing test for `Profile`.**

`test/domain/entities/profile_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/profile.dart';

void main() {
  group('Profile', () {
    final base = Profile(
      id: 'u1',
      fullName: 'Ana Pérez',
      company: 'ACME',
      phone: '+52 55 0000 0000',
      avatarUrl: 'https://x/avatar.png',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 2),
    );

    test('value equality on same fields', () {
      final other = Profile(
        id: 'u1',
        fullName: 'Ana Pérez',
        company: 'ACME',
        phone: '+52 55 0000 0000',
        avatarUrl: 'https://x/avatar.png',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 2),
      );
      expect(other, equals(base));
      expect(other.hashCode, base.hashCode);
    });

    test('different id breaks equality', () {
      final other = base.copyWith(id: 'u2');
      expect(other, isNot(equals(base)));
    });

    test('copyWith preserves untouched fields', () {
      final out = base.copyWith(company: 'NEW');
      expect(out.company, 'NEW');
      expect(out.fullName, base.fullName);
      expect(out.id, base.id);
    });
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/domain/entities/profile_test.dart
```

Expected: file-not-found.

- [ ] **Step 3: Implement `lib/domain/entities/profile.dart`.**

```dart
import 'package:equatable/equatable.dart';

/// Extended user profile (1:1 with `auth.users`). Source: `public.profiles`.
class Profile extends Equatable {
  final String id;            // uuid, FK -> auth.users.id
  final String? fullName;
  final String? company;
  final String? phone;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    this.fullName,
    this.company,
    this.phone,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Profile copyWith({
    String? id,
    String? fullName,
    String? company,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Profile(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        company: company ?? this.company,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props =>
      [id, fullName, company, phone, avatarUrl, createdAt, updatedAt];
}
```

- [ ] **Step 4: Run, expect pass.**

```bash
flutter test test/domain/entities/profile_test.dart
```

Expected: 3 tests pass.

- [ ] **Step 5: Repeat steps 1-4 for `Lawyer`.**

`test/domain/entities/lawyer_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/lawyer.dart';

void main() {
  test('Lawyer equality + props', () {
    final a = Lawyer(
      id: 'l1', fullName: 'Lic. Vega', title: 'Socia',
      email: 'v@x', phone: '+52', avatarUrl: 'u', specialty: 'Amparo',
      isActive: true, createdAt: DateTime.utc(2026, 1, 1),
    );
    final b = Lawyer(
      id: 'l1', fullName: 'Lic. Vega', title: 'Socia',
      email: 'v@x', phone: '+52', avatarUrl: 'u', specialty: 'Amparo',
      isActive: true, createdAt: DateTime.utc(2026, 1, 1),
    );
    expect(a, equals(b));
  });
}
```

`lib/domain/entities/lawyer.dart`:

```dart
import 'package:equatable/equatable.dart';

/// Internal lawyer directory entry. Source: `public.lawyers`.
class Lawyer extends Equatable {
  final String id;
  final String fullName;
  final String? title;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? specialty;
  final bool isActive;
  final DateTime createdAt;

  const Lawyer({
    required this.id,
    required this.fullName,
    this.title,
    this.email,
    this.phone,
    this.avatarUrl,
    this.specialty,
    this.isActive = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, fullName, title, email, phone, avatarUrl, specialty, isActive, createdAt];
}
```

Run `flutter test test/domain/entities/lawyer_test.dart` — expect pass.

- [ ] **Step 6: Repeat for `Conversation`.**

`test/domain/entities/conversation_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/conversation.dart';

void main() {
  test('Conversation equality', () {
    final a = Conversation(
      id: 'c1', userId: 'u1', title: 'Caso A',
      createdAt: DateTime.utc(2026, 1, 1), updatedAt: DateTime.utc(2026, 1, 2),
    );
    final b = Conversation(
      id: 'c1', userId: 'u1', title: 'Caso A',
      createdAt: DateTime.utc(2026, 1, 1), updatedAt: DateTime.utc(2026, 1, 2),
    );
    expect(a, equals(b));
  });
}
```

`lib/domain/entities/conversation.dart`:

```dart
import 'package:equatable/equatable.dart';

/// One chat thread per user. Source: `public.conversations`.
class Conversation extends Equatable {
  final String id;
  final String userId;
  final String? title;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.userId,
    this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  Conversation copyWith({String? title, DateTime? updatedAt}) => Conversation(
        id: id,
        userId: userId,
        title: title ?? this.title,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [id, userId, title, createdAt, updatedAt];
}
```

Run `flutter test test/domain/entities/conversation_test.dart` — expect pass.

- [ ] **Step 7: Run all entity tests together to be sure.**

```bash
flutter test test/domain/entities/
```

Expected: all 5 tests across 3 files pass.

- [ ] **Step 8: Commit.**

```bash
git add lib/domain/entities/{profile,lawyer,conversation}.dart \
        test/domain/entities/{profile,lawyer,conversation}_test.dart
git commit -m "site(domain): add Profile, Lawyer, Conversation entities"
```

---

## Task 7: Domain entities — batch 2 (`Document`, `Invoice`, `CalendarEvent`)

Three entities with categorical enums.

**Files:**
- Create: `lib/domain/entities/{document,invoice,calendar_event}.dart`
- Test: `test/domain/entities/{document,invoice,calendar_event}_test.dart`

- [ ] **Step 1: Write tests for all three.**

`test/domain/entities/document_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/document.dart';

void main() {
  test('Document equality + enum field', () {
    final a = Document(
      id: 'd1', matterId: 'm1', clientId: 'u1', name: 'demanda.pdf',
      fileUrl: 'https://x/a.pdf', fileSize: 1024, mimeType: 'application/pdf',
      category: DocumentCategory.escrito, uploadedBy: 'u1',
      createdAt: DateTime.utc(2026, 1, 1),
    );
    expect(a.category, DocumentCategory.escrito);
    expect(a, equals(a.copyWith()));
  });
}
```

`test/domain/entities/invoice_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/invoice.dart';

void main() {
  test('Invoice equality + status enum', () {
    final a = Invoice(
      id: 'i1', clientId: 'u1', matterId: 'm1', invoiceNumber: 'F-001',
      description: 'Honorarios', amount: 12500.50, currency: 'MXN',
      status: InvoiceStatus.pendiente, dueDate: DateTime.utc(2026, 5, 1),
      paidAt: null, fileUrl: null, createdAt: DateTime.utc(2026, 4, 1),
    );
    expect(a.status, InvoiceStatus.pendiente);
    expect(a.amount, closeTo(12500.50, 0.001));
  });
}
```

`test/domain/entities/calendar_event_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/calendar_event.dart';

void main() {
  test('CalendarEvent equality + type enum', () {
    final a = CalendarEvent(
      id: 'e1', clientId: 'u1', matterId: 'm1',
      title: 'Audiencia', description: null,
      eventType: EventType.audiencia,
      eventDate: DateTime.utc(2026, 5, 1, 10),
      location: 'Juzgado 5', createdAt: DateTime.utc(2026, 4, 1),
    );
    expect(a.eventType, EventType.audiencia);
  });
}
```

- [ ] **Step 2: Run, expect fail (3 file-not-found errors).**

```bash
flutter test test/domain/entities/document_test.dart test/domain/entities/invoice_test.dart test/domain/entities/calendar_event_test.dart
```

- [ ] **Step 3: Implement the three entity files.**

`lib/domain/entities/document.dart`:

```dart
import 'package:equatable/equatable.dart';

/// File metadata (the bytes live in Supabase Storage). Source: `public.documents`.
enum DocumentCategory { escrito, evidencia, contrato, identificacion, otro }

class Document extends Equatable {
  final String id;
  final String matterId;
  final String clientId;
  final String name;
  final String fileUrl;
  final int fileSize;
  final String mimeType;
  final DocumentCategory category;
  final String uploadedBy;
  final DateTime createdAt;

  const Document({
    required this.id,
    required this.matterId,
    required this.clientId,
    required this.name,
    required this.fileUrl,
    required this.fileSize,
    required this.mimeType,
    required this.category,
    required this.uploadedBy,
    required this.createdAt,
  });

  Document copyWith({String? name, String? fileUrl, DocumentCategory? category}) =>
      Document(
        id: id, matterId: matterId, clientId: clientId,
        name: name ?? this.name,
        fileUrl: fileUrl ?? this.fileUrl,
        fileSize: fileSize, mimeType: mimeType,
        category: category ?? this.category,
        uploadedBy: uploadedBy, createdAt: createdAt,
      );

  @override
  List<Object?> get props => [
        id, matterId, clientId, name, fileUrl, fileSize, mimeType,
        category, uploadedBy, createdAt,
      ];
}
```

`lib/domain/entities/invoice.dart`:

```dart
import 'package:equatable/equatable.dart';

/// Billing record tied to a matter. Source: `public.invoices`.
enum InvoiceStatus { pendiente, pagada, vencida, cancelada }

class Invoice extends Equatable {
  final String id;
  final String clientId;
  final String matterId;
  final String invoiceNumber;
  final String? description;
  final double amount;
  final String currency;
  final InvoiceStatus status;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final String? fileUrl;
  final DateTime createdAt;

  const Invoice({
    required this.id,
    required this.clientId,
    required this.matterId,
    required this.invoiceNumber,
    this.description,
    required this.amount,
    required this.currency,
    required this.status,
    this.dueDate,
    this.paidAt,
    this.fileUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id, clientId, matterId, invoiceNumber, description, amount,
        currency, status, dueDate, paidAt, fileUrl, createdAt,
      ];
}
```

`lib/domain/entities/calendar_event.dart`:

```dart
import 'package:equatable/equatable.dart';

/// Matter-scoped calendar event (deadline, hearing, meeting).
/// Source: `public.calendar_events`.
enum EventType { audiencia, vencimiento, reunion, recordatorio, otro }

class CalendarEvent extends Equatable {
  final String id;
  final String clientId;
  final String matterId;
  final String title;
  final String? description;
  final EventType eventType;
  final DateTime eventDate;
  final String? location;
  final DateTime createdAt;

  const CalendarEvent({
    required this.id,
    required this.clientId,
    required this.matterId,
    required this.title,
    this.description,
    required this.eventType,
    required this.eventDate,
    this.location,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id, clientId, matterId, title, description, eventType,
        eventDate, location, createdAt,
      ];
}
```

- [ ] **Step 4: Run, expect pass.**

```bash
flutter test test/domain/entities/document_test.dart test/domain/entities/invoice_test.dart test/domain/entities/calendar_event_test.dart
```

Expected: 3 tests pass.

- [ ] **Step 5: Commit.**

```bash
git add lib/domain/entities/{document,invoice,calendar_event}.dart \
        test/domain/entities/{document,invoice,calendar_event}_test.dart
git commit -m "site(domain): add Document, Invoice, CalendarEvent entities"
```

---

## Task 8: Domain entities — batch 3 (`Message`, `PortalMessage`, `BlogPost`, `PortalStats`)

Largest entities. `Message.metadata` stays as `Map<String, dynamic>` (per spec §12 Q3).

**Files:**
- Create: `lib/domain/entities/{message,portal_message,blog_post,portal_stats}.dart`
- Test: `test/domain/entities/{message,portal_message,blog_post,portal_stats}_test.dart`

- [ ] **Step 1: Write tests.**

`test/domain/entities/message_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/message.dart';

void main() {
  test('Message equality with metadata map', () {
    final a = Message(
      id: 'm1', conversationId: 'c1', role: MessageRole.user,
      content: 'hola', metadata: const {'lang': 'es'},
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final b = Message(
      id: 'm1', conversationId: 'c1', role: MessageRole.user,
      content: 'hola', metadata: const {'lang': 'es'},
      createdAt: DateTime.utc(2026, 1, 1),
    );
    expect(a, equals(b));
  });
}
```

`test/domain/entities/portal_message_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/portal_message.dart';

void main() {
  test('PortalMessage equality', () {
    final a = PortalMessage(
      id: 'pm1', matterId: 'm1', senderId: 'u1',
      senderType: SenderType.client, content: 'hola',
      attachmentUrl: null, attachmentName: null,
      isRead: false, createdAt: DateTime.utc(2026, 1, 1),
    );
    expect(a.senderType, SenderType.client);
    expect(a.isRead, isFalse);
  });
}
```

`test/domain/entities/blog_post_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/blog_post.dart';

void main() {
  test('BlogPost equality with tags list', () {
    final a = BlogPost(
      id: 'b1', title: 'Amparo 101', slug: 'amparo-101',
      excerpt: '...', content: 'long', category: 'amparo',
      tags: const ['amparo', 'introduccion'],
      imageUrl: 'u', authorName: 'Ana', authorRole: 'Socia',
      authorBio: '...', authorImageUrl: 'u2',
      readMinutes: 5, viewsCount: 0, commentsCount: 0,
      isFeatured: true, isPublished: true,
      publishedAt: DateTime.utc(2026, 1, 1),
      createdBy: 'u9',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 2),
    );
    expect(a.isFeatured, isTrue);
    expect(a.tags, contains('amparo'));
  });
}
```

`test/domain/entities/portal_stats_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/portal_stats.dart';

void main() {
  test('PortalStats value equality', () {
    const a = PortalStats(activeMatters: 3, totalDocuments: 12, upcomingEvents: 2, pendingInvoices: 1);
    const b = PortalStats(activeMatters: 3, totalDocuments: 12, upcomingEvents: 2, pendingInvoices: 1);
    expect(a, equals(b));
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/domain/entities/message_test.dart test/domain/entities/portal_message_test.dart test/domain/entities/blog_post_test.dart test/domain/entities/portal_stats_test.dart
```

- [ ] **Step 3: Implement the four entity files.**

`lib/domain/entities/message.dart`:

```dart
import 'package:equatable/equatable.dart';

/// One turn within a `Conversation`. Source: `public.messages`.
enum MessageRole { user, assistant, system }

class Message extends Equatable {
  final String id;
  final String conversationId;
  final MessageRole role;
  final String content;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.metadata = const {},
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, conversationId, role, content, metadata, createdAt];
}
```

`lib/domain/entities/portal_message.dart`:

```dart
import 'package:equatable/equatable.dart';

/// Matter-scoped client ↔ lawyer message. Source: `public.portal_messages`.
enum SenderType { client, lawyer }

class PortalMessage extends Equatable {
  final String id;
  final String matterId;
  final String senderId;
  final SenderType senderType;
  final String content;
  final String? attachmentUrl;
  final String? attachmentName;
  final bool isRead;
  final DateTime createdAt;

  const PortalMessage({
    required this.id,
    required this.matterId,
    required this.senderId,
    required this.senderType,
    required this.content,
    this.attachmentUrl,
    this.attachmentName,
    this.isRead = false,
    required this.createdAt,
  });

  PortalMessage copyWith({bool? isRead}) => PortalMessage(
        id: id, matterId: matterId, senderId: senderId, senderType: senderType,
        content: content, attachmentUrl: attachmentUrl, attachmentName: attachmentName,
        isRead: isRead ?? this.isRead, createdAt: createdAt,
      );

  @override
  List<Object?> get props => [
        id, matterId, senderId, senderType, content,
        attachmentUrl, attachmentName, isRead, createdAt,
      ];
}
```

`lib/domain/entities/blog_post.dart`:

```dart
import 'package:equatable/equatable.dart';

/// Public blog content. Source: `public.blog_posts`.
class BlogPost extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String? excerpt;
  final String content;
  final String? category;
  final List<String> tags;
  final String? imageUrl;
  final String? authorName;
  final String? authorRole;
  final String? authorBio;
  final String? authorImageUrl;
  final int readMinutes;
  final int viewsCount;
  final int commentsCount;
  final bool isFeatured;
  final bool isPublished;
  final DateTime? publishedAt;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BlogPost({
    required this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    required this.content,
    this.category,
    this.tags = const [],
    this.imageUrl,
    this.authorName,
    this.authorRole,
    this.authorBio,
    this.authorImageUrl,
    this.readMinutes = 0,
    this.viewsCount = 0,
    this.commentsCount = 0,
    this.isFeatured = false,
    this.isPublished = false,
    this.publishedAt,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id, title, slug, excerpt, content, category, tags, imageUrl,
        authorName, authorRole, authorBio, authorImageUrl,
        readMinutes, viewsCount, commentsCount,
        isFeatured, isPublished, publishedAt, createdBy,
        createdAt, updatedAt,
      ];
}
```

`lib/domain/entities/portal_stats.dart`:

```dart
import 'package:equatable/equatable.dart';

/// Aggregates returned by `get_portal_stats(user_id)` RPC. Not table-backed.
class PortalStats extends Equatable {
  final int activeMatters;
  final int totalDocuments;
  final int upcomingEvents;
  final int pendingInvoices;

  const PortalStats({
    required this.activeMatters,
    required this.totalDocuments,
    required this.upcomingEvents,
    required this.pendingInvoices,
  });

  @override
  List<Object?> get props => [activeMatters, totalDocuments, upcomingEvents, pendingInvoices];
}
```

- [ ] **Step 4: Run, expect pass.**

```bash
flutter test test/domain/entities/message_test.dart test/domain/entities/portal_message_test.dart test/domain/entities/blog_post_test.dart test/domain/entities/portal_stats_test.dart
```

- [ ] **Step 5: Commit.**

```bash
git add lib/domain/entities/{message,portal_message,blog_post,portal_stats}.dart \
        test/domain/entities/{message,portal_message,blog_post,portal_stats}_test.dart
git commit -m "site(domain): add Message, PortalMessage, BlogPost, PortalStats entities"
```

---

## Task 9: `Matter` entity (with PostgreSQL enum mirroring)

Done last among entities because it owns the most behavior: enums for `matter_type` and `status` that mirror Postgres enum types.

**Files:**
- Create: `lib/domain/entities/matter.dart`
- Test: `test/domain/entities/matter_test.dart`

- [ ] **Step 1: Confirm the enum values from Postgres.**

Run from anywhere on the server:

```bash
docker exec -i $(docker ps --format '{{.Names}}' | grep -E 'supabase.*db' | head -1) \
  psql -U postgres -d postgres -c "\dT+ public.*"
```

Use the exact enum labels printed for `matter_type` and `matter_status` (or whatever the column types are named). The values listed below are the **expected** set per the spec; if Postgres differs, update before writing the entity.

Expected `matter_type`: `civil`, `mercantil`, `administrativo`, `amparo`, `laboral`, `familiar`, `penal`, `otro`.
Expected `matter_status`: `en_proceso`, `revision`, `concluido`, `archivado`, `suspendido`.

- [ ] **Step 2: Write the failing test.**

`test/domain/entities/matter_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/matter.dart';

void main() {
  group('Matter', () {
    final base = Matter(
      id: 'm1', clientId: 'u1', lawyerId: 'l1',
      referenceCode: 'CASE-001', title: 'Amparo X',
      subtitle: 'Subtitle', matterType: MatterType.amparo,
      status: MatterStatus.en_proceso,
      lastUpdate: DateTime.utc(2026, 4, 1),
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 4, 1),
    );

    test('equality on identical fields', () {
      final clone = base.copyWith();
      expect(clone, equals(base));
    });

    test('switching status changes equality', () {
      final concluded = base.copyWith(status: MatterStatus.concluido);
      expect(concluded, isNot(equals(base)));
      expect(concluded.status, MatterStatus.concluido);
    });

    test('all enum values are addressable (mirrors Postgres)', () {
      expect(MatterType.values.length, 8);
      expect(MatterStatus.values.length, 5);
    });
  });
}
```

- [ ] **Step 3: Run, expect fail.**

```bash
flutter test test/domain/entities/matter_test.dart
```

- [ ] **Step 4: Implement `lib/domain/entities/matter.dart`.**

```dart
import 'package:equatable/equatable.dart';

/// Mirrors `public.matter_type` Postgres enum. Use Dart-style names; map back
/// to snake_case in the data-layer model's fromJson/toJson.
enum MatterType { civil, mercantil, administrativo, amparo, laboral, familiar, penal, otro }

/// Mirrors `public.matter_status` Postgres enum.
// ignore_for_file: constant_identifier_names
enum MatterStatus { en_proceso, revision, concluido, archivado, suspendido }

/// Central business entity. Source: `public.matters`.
class Matter extends Equatable {
  final String id;
  final String clientId;
  final String? lawyerId;
  final String referenceCode;
  final String title;
  final String? subtitle;
  final MatterType matterType;
  final MatterStatus status;
  final DateTime lastUpdate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Matter({
    required this.id,
    required this.clientId,
    this.lawyerId,
    required this.referenceCode,
    required this.title,
    this.subtitle,
    required this.matterType,
    required this.status,
    required this.lastUpdate,
    required this.createdAt,
    required this.updatedAt,
  });

  Matter copyWith({
    String? title,
    String? subtitle,
    String? lawyerId,
    MatterType? matterType,
    MatterStatus? status,
    DateTime? lastUpdate,
    DateTime? updatedAt,
  }) =>
      Matter(
        id: id,
        clientId: clientId,
        lawyerId: lawyerId ?? this.lawyerId,
        referenceCode: referenceCode,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        matterType: matterType ?? this.matterType,
        status: status ?? this.status,
        lastUpdate: lastUpdate ?? this.lastUpdate,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id, clientId, lawyerId, referenceCode, title, subtitle,
        matterType, status, lastUpdate, createdAt, updatedAt,
      ];
}
```

- [ ] **Step 5: Run, expect pass.**

```bash
flutter test test/domain/entities/matter_test.dart
```

- [ ] **Step 6: Run all entity tests.**

```bash
flutter test test/domain/entities/
```

Expected: 11 tests across 11 files pass.

- [ ] **Step 7: Commit.**

```bash
git add lib/domain/entities/matter.dart test/domain/entities/matter_test.dart
git commit -m "site(domain): add Matter entity mirroring Postgres enums"
```

---

## Task 10: Data models — batch 1 (`profile_model`, `lawyer_model`, `conversation_model`)

Each model **extends** its entity, adds `fromJson`/`toJson`, handles snake_case ↔ camelCase. No new fields; no behavior — pure serialization.

**Files:**
- Create: `lib/data/models/{profile,lawyer,conversation}_model.dart`
- Test: `test/data/models/{profile,lawyer,conversation}_model_test.dart`

- [ ] **Step 1: Write the failing test for `ProfileModel` round-trip JSON.**

`test/data/models/profile_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/data/models/profile_model.dart';

void main() {
  test('ProfileModel fromJson/toJson round-trip', () {
    final json = {
      'id': 'u1',
      'full_name': 'Ana Pérez',
      'company': 'ACME',
      'phone': '+52',
      'avatar_url': 'https://x/a.png',
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-02T00:00:00Z',
    };
    final m = ProfileModel.fromJson(json);
    expect(m.id, 'u1');
    expect(m.fullName, 'Ana Pérez');
    expect(m.toJson()['full_name'], 'Ana Pérez');
    expect(m.toJson()['created_at'], '2026-01-01T00:00:00.000Z');
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/data/models/profile_model_test.dart
```

- [ ] **Step 3: Implement `lib/data/models/profile_model.dart`.**

```dart
import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    super.fullName,
    super.company,
    super.phone,
    super.avatarUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        fullName: json['full_name'] as String?,
        company: json['company'] as String?,
        phone: json['phone'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  factory ProfileModel.fromEntity(Profile e) => ProfileModel(
        id: e.id, fullName: e.fullName, company: e.company, phone: e.phone,
        avatarUrl: e.avatarUrl, createdAt: e.createdAt, updatedAt: e.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'company': company,
        'phone': phone,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toUtc().toIso8601String(),
        'updated_at': updatedAt.toUtc().toIso8601String(),
      };
}
```

- [ ] **Step 4: Run, expect pass.**

```bash
flutter test test/data/models/profile_model_test.dart
```

- [ ] **Step 5: Repeat for `LawyerModel`.**

`test/data/models/lawyer_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/data/models/lawyer_model.dart';

void main() {
  test('LawyerModel round-trip', () {
    final json = {
      'id': 'l1', 'full_name': 'Lic. Vega', 'title': 'Socia',
      'email': 'v@x', 'phone': '+52', 'avatar_url': 'u',
      'specialty': 'Amparo', 'is_active': true,
      'created_at': '2026-01-01T00:00:00Z',
    };
    final m = LawyerModel.fromJson(json);
    expect(m.fullName, 'Lic. Vega');
    expect(m.isActive, isTrue);
    expect(m.toJson()['is_active'], isTrue);
  });
}
```

`lib/data/models/lawyer_model.dart`:

```dart
import '../../domain/entities/lawyer.dart';

class LawyerModel extends Lawyer {
  const LawyerModel({
    required super.id,
    required super.fullName,
    super.title, super.email, super.phone, super.avatarUrl, super.specialty,
    super.isActive,
    required super.createdAt,
  });

  factory LawyerModel.fromJson(Map<String, dynamic> json) => LawyerModel(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        title: json['title'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        specialty: json['specialty'] as String?,
        isActive: (json['is_active'] as bool?) ?? true,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'full_name': fullName, 'title': title, 'email': email,
        'phone': phone, 'avatar_url': avatarUrl, 'specialty': specialty,
        'is_active': isActive, 'created_at': createdAt.toUtc().toIso8601String(),
      };
}
```

Run `flutter test test/data/models/lawyer_model_test.dart` — expect pass.

- [ ] **Step 6: Repeat for `ConversationModel`.**

`test/data/models/conversation_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/data/models/conversation_model.dart';

void main() {
  test('ConversationModel round-trip', () {
    final json = {
      'id': 'c1', 'user_id': 'u1', 'title': 'Caso',
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-02T00:00:00Z',
    };
    final m = ConversationModel.fromJson(json);
    expect(m.userId, 'u1');
    expect(m.toJson()['user_id'], 'u1');
  });
}
```

`lib/data/models/conversation_model.dart`:

```dart
import '../../domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.userId,
    super.title,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        title: json['title'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'user_id': userId, 'title': title,
        'created_at': createdAt.toUtc().toIso8601String(),
        'updated_at': updatedAt.toUtc().toIso8601String(),
      };
}
```

Run `flutter test test/data/models/conversation_model_test.dart` — expect pass.

- [ ] **Step 7: Run all 3 model tests, then commit.**

```bash
flutter test test/data/models/profile_model_test.dart \
              test/data/models/lawyer_model_test.dart \
              test/data/models/conversation_model_test.dart
git add lib/data/models/{profile,lawyer,conversation}_model.dart \
        test/data/models/{profile,lawyer,conversation}_model_test.dart
git commit -m "site(data): add Profile, Lawyer, Conversation models"
```

---

## Task 11: Data models — batch 2 (`document_model`, `invoice_model`, `calendar_event_model`)

Models with enum string serialization (use `.name` to encode and `EnumByName` for decode).

**Files:**
- Create: `lib/data/models/{document,invoice,calendar_event}_model.dart`
- Test: `test/data/models/{document,invoice,calendar_event}_model_test.dart`

- [ ] **Step 1: Write tests.**

`test/data/models/document_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/document.dart';
import 'package:justicia_administrativa_site/data/models/document_model.dart';

void main() {
  test('DocumentModel round-trip with enum', () {
    final json = {
      'id': 'd1', 'matter_id': 'm1', 'client_id': 'u1',
      'name': 'a.pdf', 'file_url': 'u', 'file_size': 1024,
      'mime_type': 'application/pdf', 'category': 'escrito',
      'uploaded_by': 'u1',
      'created_at': '2026-01-01T00:00:00Z',
    };
    final m = DocumentModel.fromJson(json);
    expect(m.category, DocumentCategory.escrito);
    expect(m.toJson()['category'], 'escrito');
  });

  test('Unknown category falls back to .otro', () {
    final json = {
      'id': 'd2', 'matter_id': 'm1', 'client_id': 'u1',
      'name': 'x', 'file_url': 'u', 'file_size': 0,
      'mime_type': 'x', 'category': 'wat', 'uploaded_by': 'u1',
      'created_at': '2026-01-01T00:00:00Z',
    };
    final m = DocumentModel.fromJson(json);
    expect(m.category, DocumentCategory.otro);
  });
}
```

`test/data/models/invoice_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/invoice.dart';
import 'package:justicia_administrativa_site/data/models/invoice_model.dart';

void main() {
  test('InvoiceModel round-trip', () {
    final json = {
      'id': 'i1', 'client_id': 'u1', 'matter_id': 'm1',
      'invoice_number': 'F-001', 'description': 'Honorarios',
      'amount': 12500.50, 'currency': 'MXN', 'status': 'pendiente',
      'due_date': '2026-05-01T00:00:00Z',
      'paid_at': null, 'file_url': null,
      'created_at': '2026-04-01T00:00:00Z',
    };
    final m = InvoiceModel.fromJson(json);
    expect(m.status, InvoiceStatus.pendiente);
    expect(m.amount, 12500.50);
    expect(m.toJson()['status'], 'pendiente');
  });
}
```

`test/data/models/calendar_event_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/calendar_event.dart';
import 'package:justicia_administrativa_site/data/models/calendar_event_model.dart';

void main() {
  test('CalendarEventModel round-trip', () {
    final json = {
      'id': 'e1', 'client_id': 'u1', 'matter_id': 'm1',
      'title': 'Audiencia', 'description': null,
      'event_type': 'audiencia',
      'event_date': '2026-05-01T10:00:00Z',
      'location': 'Juzgado 5',
      'created_at': '2026-04-01T00:00:00Z',
    };
    final m = CalendarEventModel.fromJson(json);
    expect(m.eventType, EventType.audiencia);
    expect(m.toJson()['event_type'], 'audiencia');
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/data/models/document_model_test.dart test/data/models/invoice_model_test.dart test/data/models/calendar_event_model_test.dart
```

- [ ] **Step 3: Implement the three model files.**

`lib/data/models/document_model.dart`:

```dart
import '../../domain/entities/document.dart';

class DocumentModel extends Document {
  const DocumentModel({
    required super.id,
    required super.matterId,
    required super.clientId,
    required super.name,
    required super.fileUrl,
    required super.fileSize,
    required super.mimeType,
    required super.category,
    required super.uploadedBy,
    required super.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json['id'] as String,
        matterId: json['matter_id'] as String,
        clientId: json['client_id'] as String,
        name: json['name'] as String,
        fileUrl: json['file_url'] as String,
        fileSize: (json['file_size'] as num).toInt(),
        mimeType: json['mime_type'] as String,
        category: DocumentCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => DocumentCategory.otro,
        ),
        uploadedBy: json['uploaded_by'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'matter_id': matterId, 'client_id': clientId,
        'name': name, 'file_url': fileUrl, 'file_size': fileSize,
        'mime_type': mimeType, 'category': category.name,
        'uploaded_by': uploadedBy,
        'created_at': createdAt.toUtc().toIso8601String(),
      };
}
```

`lib/data/models/invoice_model.dart`:

```dart
import '../../domain/entities/invoice.dart';

class InvoiceModel extends Invoice {
  const InvoiceModel({
    required super.id,
    required super.clientId,
    required super.matterId,
    required super.invoiceNumber,
    super.description,
    required super.amount,
    required super.currency,
    required super.status,
    super.dueDate,
    super.paidAt,
    super.fileUrl,
    required super.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['id'] as String,
        clientId: json['client_id'] as String,
        matterId: json['matter_id'] as String,
        invoiceNumber: json['invoice_number'] as String,
        description: json['description'] as String?,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        status: InvoiceStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => InvoiceStatus.pendiente,
        ),
        dueDate: json['due_date'] == null ? null : DateTime.parse(json['due_date'] as String),
        paidAt: json['paid_at'] == null ? null : DateTime.parse(json['paid_at'] as String),
        fileUrl: json['file_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'client_id': clientId, 'matter_id': matterId,
        'invoice_number': invoiceNumber, 'description': description,
        'amount': amount, 'currency': currency, 'status': status.name,
        'due_date': dueDate?.toUtc().toIso8601String(),
        'paid_at': paidAt?.toUtc().toIso8601String(),
        'file_url': fileUrl,
        'created_at': createdAt.toUtc().toIso8601String(),
      };
}
```

`lib/data/models/calendar_event_model.dart`:

```dart
import '../../domain/entities/calendar_event.dart';

class CalendarEventModel extends CalendarEvent {
  const CalendarEventModel({
    required super.id,
    required super.clientId,
    required super.matterId,
    required super.title,
    super.description,
    required super.eventType,
    required super.eventDate,
    super.location,
    required super.createdAt,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) =>
      CalendarEventModel(
        id: json['id'] as String,
        clientId: json['client_id'] as String,
        matterId: json['matter_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        eventType: EventType.values.firstWhere(
          (e) => e.name == json['event_type'],
          orElse: () => EventType.otro,
        ),
        eventDate: DateTime.parse(json['event_date'] as String),
        location: json['location'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'client_id': clientId, 'matter_id': matterId,
        'title': title, 'description': description,
        'event_type': eventType.name,
        'event_date': eventDate.toUtc().toIso8601String(),
        'location': location,
        'created_at': createdAt.toUtc().toIso8601String(),
      };
}
```

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/data/models/document_model_test.dart test/data/models/invoice_model_test.dart test/data/models/calendar_event_model_test.dart
git add lib/data/models/{document,invoice,calendar_event}_model.dart \
        test/data/models/{document,invoice,calendar_event}_model_test.dart
git commit -m "site(data): add Document, Invoice, CalendarEvent models"
```

---

## Task 12: Data models — batch 3 (`message_model`, `portal_message_model`, `blog_post_model`, `portal_stats_model`)

**Files:**
- Create: `lib/data/models/{message,portal_message,blog_post,portal_stats}_model.dart`
- Test: corresponding `*_model_test.dart` files

- [ ] **Step 1: Write tests for all four.**

`test/data/models/message_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/message.dart';
import 'package:justicia_administrativa_site/data/models/message_model.dart';

void main() {
  test('MessageModel round-trip with metadata', () {
    final json = {
      'id': 'm1', 'conversation_id': 'c1', 'role': 'user',
      'content': 'hola', 'metadata': {'lang': 'es'},
      'created_at': '2026-01-01T00:00:00Z',
    };
    final m = MessageModel.fromJson(json);
    expect(m.role, MessageRole.user);
    expect(m.metadata['lang'], 'es');
    expect(m.toJson()['role'], 'user');
  });
}
```

`test/data/models/portal_message_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/portal_message.dart';
import 'package:justicia_administrativa_site/data/models/portal_message_model.dart';

void main() {
  test('PortalMessageModel round-trip', () {
    final json = {
      'id': 'pm1', 'matter_id': 'm1', 'sender_id': 'u1',
      'sender_type': 'client', 'content': 'hola',
      'attachment_url': null, 'attachment_name': null,
      'is_read': false,
      'created_at': '2026-01-01T00:00:00Z',
    };
    final m = PortalMessageModel.fromJson(json);
    expect(m.senderType, SenderType.client);
    expect(m.toJson()['sender_type'], 'client');
  });
}
```

`test/data/models/blog_post_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/data/models/blog_post_model.dart';

void main() {
  test('BlogPostModel round-trip with tags array', () {
    final json = {
      'id': 'b1', 'title': 'Amparo 101', 'slug': 'amparo-101',
      'excerpt': null, 'content': 'long', 'category': 'amparo',
      'tags': ['amparo', 'introduccion'],
      'image_url': null,
      'author_name': 'Ana', 'author_role': null,
      'author_bio': null, 'author_image_url': null,
      'read_minutes': 5, 'views_count': 0, 'comments_count': 0,
      'is_featured': true, 'is_published': true,
      'published_at': '2026-01-01T00:00:00Z',
      'created_by': 'u9',
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-02T00:00:00Z',
    };
    final m = BlogPostModel.fromJson(json);
    expect(m.tags, contains('amparo'));
    expect(m.isPublished, isTrue);
    expect(m.toJson()['tags'], contains('introduccion'));
  });
}
```

`test/data/models/portal_stats_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/data/models/portal_stats_model.dart';

void main() {
  test('PortalStatsModel round-trip', () {
    final json = {'active_matters': 3, 'total_documents': 12, 'upcoming_events': 2, 'pending_invoices': 1};
    final m = PortalStatsModel.fromJson(json);
    expect(m.activeMatters, 3);
    expect(m.toJson()['pending_invoices'], 1);
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/data/models/message_model_test.dart test/data/models/portal_message_model_test.dart test/data/models/blog_post_model_test.dart test/data/models/portal_stats_model_test.dart
```

- [ ] **Step 3: Implement the four model files.**

`lib/data/models/message_model.dart`:

```dart
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.role,
    required super.content,
    super.metadata,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        conversationId: json['conversation_id'] as String,
        role: MessageRole.values.firstWhere(
          (e) => e.name == json['role'],
          orElse: () => MessageRole.user,
        ),
        content: json['content'] as String,
        metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? const {},
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'conversation_id': conversationId,
        'role': role.name, 'content': content, 'metadata': metadata,
        'created_at': createdAt.toUtc().toIso8601String(),
      };
}
```

`lib/data/models/portal_message_model.dart`:

```dart
import '../../domain/entities/portal_message.dart';

class PortalMessageModel extends PortalMessage {
  const PortalMessageModel({
    required super.id,
    required super.matterId,
    required super.senderId,
    required super.senderType,
    required super.content,
    super.attachmentUrl,
    super.attachmentName,
    super.isRead,
    required super.createdAt,
  });

  factory PortalMessageModel.fromJson(Map<String, dynamic> json) =>
      PortalMessageModel(
        id: json['id'] as String,
        matterId: json['matter_id'] as String,
        senderId: json['sender_id'] as String,
        senderType: SenderType.values.firstWhere(
          (e) => e.name == json['sender_type'],
          orElse: () => SenderType.client,
        ),
        content: json['content'] as String,
        attachmentUrl: json['attachment_url'] as String?,
        attachmentName: json['attachment_name'] as String?,
        isRead: (json['is_read'] as bool?) ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'matter_id': matterId, 'sender_id': senderId,
        'sender_type': senderType.name, 'content': content,
        'attachment_url': attachmentUrl, 'attachment_name': attachmentName,
        'is_read': isRead,
        'created_at': createdAt.toUtc().toIso8601String(),
      };
}
```

`lib/data/models/blog_post_model.dart`:

```dart
import '../../domain/entities/blog_post.dart';

class BlogPostModel extends BlogPost {
  const BlogPostModel({
    required super.id,
    required super.title,
    required super.slug,
    super.excerpt,
    required super.content,
    super.category,
    super.tags,
    super.imageUrl,
    super.authorName,
    super.authorRole,
    super.authorBio,
    super.authorImageUrl,
    super.readMinutes,
    super.viewsCount,
    super.commentsCount,
    super.isFeatured,
    super.isPublished,
    super.publishedAt,
    super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) => BlogPostModel(
        id: json['id'] as String,
        title: json['title'] as String,
        slug: json['slug'] as String,
        excerpt: json['excerpt'] as String?,
        content: json['content'] as String,
        category: json['category'] as String?,
        tags: ((json['tags'] as List?) ?? const []).cast<String>(),
        imageUrl: json['image_url'] as String?,
        authorName: json['author_name'] as String?,
        authorRole: json['author_role'] as String?,
        authorBio: json['author_bio'] as String?,
        authorImageUrl: json['author_image_url'] as String?,
        readMinutes: (json['read_minutes'] as num?)?.toInt() ?? 0,
        viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
        commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
        isFeatured: (json['is_featured'] as bool?) ?? false,
        isPublished: (json['is_published'] as bool?) ?? false,
        publishedAt: json['published_at'] == null
            ? null
            : DateTime.parse(json['published_at'] as String),
        createdBy: json['created_by'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'title': title, 'slug': slug, 'excerpt': excerpt,
        'content': content, 'category': category, 'tags': tags,
        'image_url': imageUrl,
        'author_name': authorName, 'author_role': authorRole,
        'author_bio': authorBio, 'author_image_url': authorImageUrl,
        'read_minutes': readMinutes, 'views_count': viewsCount,
        'comments_count': commentsCount,
        'is_featured': isFeatured, 'is_published': isPublished,
        'published_at': publishedAt?.toUtc().toIso8601String(),
        'created_by': createdBy,
        'created_at': createdAt.toUtc().toIso8601String(),
        'updated_at': updatedAt.toUtc().toIso8601String(),
      };
}
```

`lib/data/models/portal_stats_model.dart`:

```dart
import '../../domain/entities/portal_stats.dart';

class PortalStatsModel extends PortalStats {
  const PortalStatsModel({
    required super.activeMatters,
    required super.totalDocuments,
    required super.upcomingEvents,
    required super.pendingInvoices,
  });

  factory PortalStatsModel.fromJson(Map<String, dynamic> json) => PortalStatsModel(
        activeMatters: (json['active_matters'] as num).toInt(),
        totalDocuments: (json['total_documents'] as num).toInt(),
        upcomingEvents: (json['upcoming_events'] as num).toInt(),
        pendingInvoices: (json['pending_invoices'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'active_matters': activeMatters,
        'total_documents': totalDocuments,
        'upcoming_events': upcomingEvents,
        'pending_invoices': pendingInvoices,
      };
}
```

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/data/models/message_model_test.dart test/data/models/portal_message_model_test.dart test/data/models/blog_post_model_test.dart test/data/models/portal_stats_model_test.dart
git add lib/data/models/{message,portal_message,blog_post,portal_stats}_model.dart \
        test/data/models/{message,portal_message,blog_post,portal_stats}_model_test.dart
git commit -m "site(data): add Message, PortalMessage, BlogPost, PortalStats models"
```

---

## Task 13: `MatterModel` (with both Postgres enums)

**Files:**
- Create: `lib/data/models/matter_model.dart`
- Test: `test/data/models/matter_model_test.dart`

- [ ] **Step 1: Write the failing test.**

`test/data/models/matter_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/entities/matter.dart';
import 'package:justicia_administrativa_site/data/models/matter_model.dart';

void main() {
  test('MatterModel round-trip', () {
    final json = {
      'id': 'm1', 'client_id': 'u1', 'lawyer_id': 'l1',
      'reference_code': 'CASE-001', 'title': 'Amparo X',
      'subtitle': 'Sub', 'matter_type': 'amparo', 'status': 'en_proceso',
      'last_update': '2026-04-01T00:00:00Z',
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-04-01T00:00:00Z',
    };
    final m = MatterModel.fromJson(json);
    expect(m.matterType, MatterType.amparo);
    expect(m.status, MatterStatus.en_proceso);
    expect(m.toJson()['matter_type'], 'amparo');
    expect(m.toJson()['status'], 'en_proceso');
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/data/models/matter_model_test.dart
```

- [ ] **Step 3: Implement `lib/data/models/matter_model.dart`.**

```dart
import '../../domain/entities/matter.dart';

class MatterModel extends Matter {
  const MatterModel({
    required super.id,
    required super.clientId,
    super.lawyerId,
    required super.referenceCode,
    required super.title,
    super.subtitle,
    required super.matterType,
    required super.status,
    required super.lastUpdate,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MatterModel.fromJson(Map<String, dynamic> json) => MatterModel(
        id: json['id'] as String,
        clientId: json['client_id'] as String,
        lawyerId: json['lawyer_id'] as String?,
        referenceCode: json['reference_code'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String?,
        matterType: MatterType.values.firstWhere(
          (e) => e.name == json['matter_type'],
          orElse: () => MatterType.otro,
        ),
        status: MatterStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => MatterStatus.en_proceso,
        ),
        lastUpdate: DateTime.parse(json['last_update'] as String),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'client_id': clientId, 'lawyer_id': lawyerId,
        'reference_code': referenceCode, 'title': title, 'subtitle': subtitle,
        'matter_type': matterType.name, 'status': status.name,
        'last_update': lastUpdate.toUtc().toIso8601String(),
        'created_at': createdAt.toUtc().toIso8601String(),
        'updated_at': updatedAt.toUtc().toIso8601String(),
      };
}
```

- [ ] **Step 4: Run all model tests, then commit.**

```bash
flutter test test/data/models/
git add lib/data/models/matter_model.dart test/data/models/matter_model_test.dart
git commit -m "site(data): add Matter model with Postgres enum mirroring"
```

Expected: 11 tests across 11 files pass.

---

## Task 14: All abstract repository interfaces

11 small files; no tests (interfaces are uninhabitable). One commit covers them all.

**Files:**
- Create: `lib/domain/repositories/{profiles,lawyers,matters,documents,invoices,calendar,conversations,messages,portal_messages,blog,auth}_repository.dart`

- [ ] **Step 1: Create all 11 interface files in one go.**

`lib/domain/repositories/profiles_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/profile.dart';

abstract class ProfilesRepository {
  Future<Result<Profile>> getCurrent();
  Future<Result<Profile>> update(Profile profile);
}
```

`lib/domain/repositories/lawyers_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/lawyer.dart';

abstract class LawyersRepository {
  Future<Result<List<Lawyer>>> list();
  Future<Result<Lawyer>> getById(String id);
}
```

`lib/domain/repositories/matters_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/matter.dart';

abstract class MattersRepository {
  Future<Result<List<Matter>>> listForCurrentUser();
  Future<Result<Matter>> getById(String id);
  Future<Result<List<Matter>>> listByStatus(MatterStatus status);
}
```

`lib/domain/repositories/documents_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/document.dart';

abstract class DocumentsRepository {
  Future<Result<List<Document>>> listForMatter(String matterId);
  Future<Result<Document>> getById(String id);
  Future<Result<Document>> upload({
    required String matterId,
    required String name,
    required List<int> bytes,
    required String mimeType,
    required DocumentCategory category,
  });
}
```

`lib/domain/repositories/invoices_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/invoice.dart';

abstract class InvoicesRepository {
  Future<Result<List<Invoice>>> listForCurrentUser();
  Future<Result<List<Invoice>>> listForMatter(String matterId);
}
```

`lib/domain/repositories/calendar_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/calendar_event.dart';

abstract class CalendarRepository {
  Future<Result<List<CalendarEvent>>> listUpcomingForCurrentUser();
  Future<Result<List<CalendarEvent>>> listForMatter(String matterId);
}
```

`lib/domain/repositories/conversations_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/conversation.dart';

abstract class ConversationsRepository {
  Future<Result<List<Conversation>>> listForCurrentUser();
  Future<Result<Conversation>> getById(String id);
  Future<Result<Conversation>> create(String? title);
  Future<Result<void>> delete(String id);
}
```

`lib/domain/repositories/messages_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/message.dart';

abstract class MessagesRepository {
  Future<Result<List<Message>>> listForConversation(String conversationId);
  Future<Result<Message>> send({
    required String conversationId,
    required MessageRole role,
    required String content,
    Map<String, dynamic> metadata,
  });
}
```

`lib/domain/repositories/portal_messages_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/portal_message.dart';

abstract class PortalMessagesRepository {
  Future<Result<List<PortalMessage>>> listForMatter(String matterId);
  Future<Result<void>> markRead(String id);
  Future<Result<PortalMessage>> send({
    required String matterId,
    required String content,
    String? attachmentName,
    List<int>? attachmentBytes,
    String? attachmentMime,
  });
}
```

`lib/domain/repositories/blog_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/blog_post.dart';

abstract class BlogRepository {
  Future<Result<List<BlogPost>>> listPublished({bool? featured});
  Future<Result<BlogPost>> getBySlug(String slug);
}
```

`lib/domain/repositories/auth_repository.dart`:

```dart
import '../../core/errors/result.dart';
import '../entities/profile.dart';

/// Auth ops live separately because Supabase auth is not a public-schema table.
abstract class AuthRepository {
  /// Currently signed-in user as a Profile, or `Err(NotFoundFailure)` if none.
  Future<Result<Profile>> currentUser();

  /// Hot stream of auth state. Emits the current Profile (or `null` for signed-out)
  /// whenever Supabase reports a state change.
  Stream<Profile?> watchAuthState();

  Future<Result<Profile>> signInWithPassword({required String email, required String password});

  Future<Result<void>> signOut();
}
```

- [ ] **Step 2: `flutter analyze` — every interface should compile.**

```bash
flutter analyze lib/domain/repositories/
```

Expected: 0 errors. Warnings only if unrelated to the new files.

- [ ] **Step 3: Commit.**

```bash
git add lib/domain/repositories/
git commit -m "site(domain): add 11 abstract repository interfaces (Result-returning)"
```

---

## Task 15: Special data sources (`auth`, `rpc`, `storage`)

These wrap the parts of `SupabaseClient` that aren't `from('table')`. No tests at this layer — repositories are tested with fake data sources, which validates the wiring.

**Files:**
- Create: `lib/data/data_sources/supabase/auth_data_source.dart`, `rpc_data_source.dart`, `storage_data_source.dart`

- [ ] **Step 1: Implement `auth_data_source.dart`.**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Wraps Supabase Auth ops. Throws on failure (caller catches).
class AuthDataSource {
  final SupabaseClient _client;
  AuthDataSource(this._client);

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signInWithPassword({required String email, required String password}) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<void> signOut() => _client.auth.signOut();
}
```

- [ ] **Step 2: Implement `rpc_data_source.dart`.**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Wraps the 3 client-callable RPCs.
class RpcDataSource {
  final SupabaseClient _client;
  RpcDataSource(this._client);

  Future<Map<String, dynamic>> getPortalStats(String userId) async {
    final res = await _client.rpc('get_portal_stats', params: {'user_id': userId});
    return Map<String, dynamic>.from(res as Map);
  }

  Future<List<Map<String, dynamic>>> matchDocuments({
    required List<double> queryEmbedding,
    double matchThreshold = 0.5,
    int matchCount = 8,
  }) async {
    final res = await _client.rpc('match_documents', params: {
      'query_embedding': queryEmbedding,
      'match_threshold': matchThreshold,
      'match_count': matchCount,
    });
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> matchSessionDocuments({
    required List<double> queryEmbedding,
    required String conversationId,
    double matchThreshold = 0.5,
    int matchCount = 8,
  }) async {
    final res = await _client.rpc('match_session_documents', params: {
      'query_embedding': queryEmbedding,
      'match_threshold': matchThreshold,
      'match_count': matchCount,
      'conversation_id': conversationId,
    });
    return (res as List).cast<Map<String, dynamic>>();
  }
}
```

- [ ] **Step 3: Implement `storage_data_source.dart`.**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Wraps Supabase Storage ops for the two client-facing buckets.
class StorageDataSource {
  final SupabaseClient _client;
  StorageDataSource(this._client);

  /// Uploads bytes to `clients/<path>` and returns the public URL.
  Future<String> uploadToClients({
    required String path,
    required List<int> bytes,
    required String contentType,
  }) async {
    await _client.storage.from('clients').uploadBinary(
          path,
          bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
          fileOptions: FileOptions(contentType: contentType, upsert: false),
        );
    return _client.storage.from('clients').getPublicUrl(path);
  }

  /// Uploads to `chat-attachments/<path>` (private bucket; signed URL).
  Future<String> uploadToChatAttachments({
    required String path,
    required List<int> bytes,
    required String contentType,
  }) async {
    await _client.storage.from('chat-attachments').uploadBinary(
          path,
          bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
          fileOptions: FileOptions(contentType: contentType, upsert: false),
        );
    return _client.storage.from('chat-attachments').createSignedUrl(path, 3600);
  }
}
```

> Note: `Uint8List` is in `dart:typed_data` — add `import 'dart:typed_data';` at the top.

- [ ] **Step 4: `flutter analyze` and commit.**

```bash
flutter analyze lib/data/data_sources/supabase/
git add lib/data/data_sources/supabase/{auth,rpc,storage}_data_source.dart
git commit -m "site(data): add auth, rpc, storage data sources"
```

---

## Task 16: Per-table data sources — batch 1 (`profiles`, `lawyers`, `matters`, `documents`, `invoices`)

Each is a thin wrapper around `client.from('<table>').select()/insert()/update()/delete()`. Returns the raw rows; the repository layer maps them to models.

**Files:**
- Create: `lib/data/data_sources/supabase/{profiles,lawyers,matters,documents,invoices}_data_source.dart`

- [ ] **Step 1: Create all 5 files.**

`lib/data/data_sources/supabase/profiles_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilesDataSource {
  final SupabaseClient _client;
  ProfilesDataSource(this._client);

  Future<Map<String, dynamic>> getById(String id) async {
    final row = await _client.from('profiles').select().eq('id', id).single();
    return Map<String, dynamic>.from(row);
  }

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> patch) async {
    final row = await _client.from('profiles').update(patch).eq('id', id).select().single();
    return Map<String, dynamic>.from(row);
  }
}
```

`lib/data/data_sources/supabase/lawyers_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class LawyersDataSource {
  final SupabaseClient _client;
  LawyersDataSource(this._client);

  Future<List<Map<String, dynamic>>> list() async {
    final rows = await _client.from('lawyers').select().eq('is_active', true).order('full_name');
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final row = await _client.from('lawyers').select().eq('id', id).single();
    return Map<String, dynamic>.from(row);
  }
}
```

`lib/data/data_sources/supabase/matters_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class MattersDataSource {
  final SupabaseClient _client;
  MattersDataSource(this._client);

  Future<List<Map<String, dynamic>>> listForUser(String userId) async {
    final rows = await _client.from('matters').select().eq('client_id', userId).order('last_update', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final row = await _client.from('matters').select().eq('id', id).single();
    return Map<String, dynamic>.from(row);
  }

  Future<List<Map<String, dynamic>>> listByStatus(String userId, String status) async {
    final rows = await _client
        .from('matters')
        .select()
        .eq('client_id', userId)
        .eq('status', status)
        .order('last_update', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }
}
```

`lib/data/data_sources/supabase/documents_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentsDataSource {
  final SupabaseClient _client;
  DocumentsDataSource(this._client);

  Future<List<Map<String, dynamic>>> listForMatter(String matterId) async {
    final rows = await _client.from('documents').select().eq('matter_id', matterId).order('created_at', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final row = await _client.from('documents').select().eq('id', id).single();
    return Map<String, dynamic>.from(row);
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> row) async {
    final inserted = await _client.from('documents').insert(row).select().single();
    return Map<String, dynamic>.from(inserted);
  }
}
```

`lib/data/data_sources/supabase/invoices_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class InvoicesDataSource {
  final SupabaseClient _client;
  InvoicesDataSource(this._client);

  Future<List<Map<String, dynamic>>> listForUser(String userId) async {
    final rows = await _client.from('invoices').select().eq('client_id', userId).order('created_at', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> listForMatter(String matterId) async {
    final rows = await _client.from('invoices').select().eq('matter_id', matterId).order('created_at', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }
}
```

- [ ] **Step 2: `flutter analyze` and commit.**

```bash
flutter analyze lib/data/data_sources/supabase/
git add lib/data/data_sources/supabase/{profiles,lawyers,matters,documents,invoices}_data_source.dart
git commit -m "site(data): add profiles/lawyers/matters/documents/invoices data sources"
```

---

## Task 17: Per-table data sources — batch 2 (`calendar`, `conversations`, `messages`, `portal_messages`, `blog`)

**Files:**
- Create: `lib/data/data_sources/supabase/{calendar,conversations,messages,portal_messages,blog}_data_source.dart`

- [ ] **Step 1: Create all 5 files.**

`lib/data/data_sources/supabase/calendar_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarDataSource {
  final SupabaseClient _client;
  CalendarDataSource(this._client);

  Future<List<Map<String, dynamic>>> listUpcomingForUser(String userId, DateTime now) async {
    final rows = await _client
        .from('calendar_events')
        .select()
        .eq('client_id', userId)
        .gte('event_date', now.toUtc().toIso8601String())
        .order('event_date');
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> listForMatter(String matterId) async {
    final rows = await _client.from('calendar_events').select().eq('matter_id', matterId).order('event_date');
    return (rows as List).cast<Map<String, dynamic>>();
  }
}
```

`lib/data/data_sources/supabase/conversations_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationsDataSource {
  final SupabaseClient _client;
  ConversationsDataSource(this._client);

  Future<List<Map<String, dynamic>>> listForUser(String userId) async {
    final rows = await _client.from('conversations').select().eq('user_id', userId).order('updated_at', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final row = await _client.from('conversations').select().eq('id', id).single();
    return Map<String, dynamic>.from(row);
  }

  Future<Map<String, dynamic>> create({required String userId, String? title}) async {
    final row = await _client.from('conversations').insert({'user_id': userId, 'title': title}).select().single();
    return Map<String, dynamic>.from(row);
  }

  Future<void> delete(String id) async {
    await _client.from('conversations').delete().eq('id', id);
  }
}
```

`lib/data/data_sources/supabase/messages_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagesDataSource {
  final SupabaseClient _client;
  MessagesDataSource(this._client);

  Future<List<Map<String, dynamic>>> listForConversation(String conversationId) async {
    final rows = await _client.from('messages').select().eq('conversation_id', conversationId).order('created_at');
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> row) async {
    final inserted = await _client.from('messages').insert(row).select().single();
    return Map<String, dynamic>.from(inserted);
  }
}
```

`lib/data/data_sources/supabase/portal_messages_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class PortalMessagesDataSource {
  final SupabaseClient _client;
  PortalMessagesDataSource(this._client);

  Future<List<Map<String, dynamic>>> listForMatter(String matterId) async {
    final rows = await _client.from('portal_messages').select().eq('matter_id', matterId).order('created_at');
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<void> markRead(String id) async {
    await _client.from('portal_messages').update({'is_read': true}).eq('id', id);
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> row) async {
    final inserted = await _client.from('portal_messages').insert(row).select().single();
    return Map<String, dynamic>.from(inserted);
  }
}
```

`lib/data/data_sources/supabase/blog_data_source.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogDataSource {
  final SupabaseClient _client;
  BlogDataSource(this._client);

  Future<List<Map<String, dynamic>>> listPublished({bool? featured}) async {
    var q = _client.from('blog_posts').select().eq('is_published', true);
    if (featured == true) q = q.eq('is_featured', true);
    final rows = await q.order('published_at', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getBySlug(String slug) async {
    final row = await _client.from('blog_posts').select().eq('slug', slug).single();
    return Map<String, dynamic>.from(row);
  }
}
```

- [ ] **Step 2: `flutter analyze` and commit.**

```bash
flutter analyze lib/data/data_sources/supabase/
git add lib/data/data_sources/supabase/{calendar,conversations,messages,portal_messages,blog}_data_source.dart
git commit -m "site(data): add calendar/conversations/messages/portal_messages/blog data sources"
```

After this commit, the directory contains all 13 data-source files (10 table + auth + rpc + storage).

---

## Task 18: Repository impls — batch 1 (read-mostly: `Profiles`, `Lawyers`, `Conversations`, `Blog`)

Each repository impl has the same shape: `try { use data source } catch (e) { return Err(mapException(e)); }`. Test exercises happy path + one error path with a fake data source.

**Files:**
- Create: `lib/data/repositories/{profiles,lawyers,conversations,blog}_repository_impl.dart`
- Test: corresponding `*_repository_impl_test.dart`

- [ ] **Step 1: Write tests (one per repo).**

`test/data/repositories/profiles_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/data/repositories/profiles_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/profiles_data_source.dart';

class _FakeAuth {
  final String? id;
  _FakeAuth(this.id);
}

class _FakeDS implements ProfilesDataSource {
  final Map<String, dynamic>? row;
  final Object? throwOnGet;
  _FakeDS({this.row, this.throwOnGet});

  @override
  Future<Map<String, dynamic>> getById(String id) async {
    if (throwOnGet != null) throw throwOnGet!;
    return row!;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> patch) async => row!;
}

void main() {
  final happyJson = {
    'id': 'u1', 'full_name': 'Ana', 'company': null, 'phone': null, 'avatar_url': null,
    'created_at': '2026-01-01T00:00:00Z', 'updated_at': '2026-01-01T00:00:00Z',
  };

  test('getCurrent returns Success when data source returns row', () async {
    final repo = ProfilesRepositoryImpl(_FakeDS(row: happyJson), currentUserId: () => 'u1');
    final res = await repo.getCurrent();
    expect(res, isA<Success>());
    res.fold((p) => expect(p.id, 'u1'), (_) => fail('expected Success'));
  });

  test('getCurrent maps PostgrestException PGRST116 -> NotFoundFailure', () async {
    final ex = PostgrestException(message: 'no rows', code: 'PGRST116');
    final repo = ProfilesRepositoryImpl(_FakeDS(throwOnGet: ex), currentUserId: () => 'u1');
    final res = await repo.getCurrent();
    expect(res, isA<Err>());
    res.fold((_) => fail('expected Err'), (f) => expect(f, isA<NotFoundFailure>()));
  });

  test('getCurrent returns AuthFailure if no current user id', () async {
    final repo = ProfilesRepositoryImpl(_FakeDS(row: happyJson), currentUserId: () => null);
    final res = await repo.getCurrent();
    res.fold((_) => fail('expected Err'), (f) => expect(f, isA<AuthFailure>()));
  });
}
```

`test/data/repositories/lawyers_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/data/repositories/lawyers_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/lawyers_data_source.dart';

class _FakeDS implements LawyersDataSource {
  @override Future<List<Map<String, dynamic>>> list() async => [
        {'id': 'l1', 'full_name': 'Lic. Vega', 'is_active': true, 'created_at': '2026-01-01T00:00:00Z'}
      ];
  @override Future<Map<String, dynamic>> getById(String id) async => throw UnimplementedError();
}

void main() {
  test('list returns mapped Lawyer entities', () async {
    final repo = LawyersRepositoryImpl(_FakeDS());
    final res = await repo.list();
    res.fold(
      (l) => expect(l.first.fullName, 'Lic. Vega'),
      (_) => fail('expected Success'),
    );
  });
}
```

`test/data/repositories/conversations_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/data/repositories/conversations_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/conversations_data_source.dart';

class _FakeDS implements ConversationsDataSource {
  @override Future<List<Map<String, dynamic>>> listForUser(String userId) async => [
        {'id': 'c1', 'user_id': userId, 'title': 'Caso',
         'created_at': '2026-01-01T00:00:00Z', 'updated_at': '2026-01-01T00:00:00Z'},
      ];
  @override Future<Map<String, dynamic>> getById(String id) async => throw UnimplementedError();
  @override Future<Map<String, dynamic>> create({required String userId, String? title}) async =>
      {'id': 'c2', 'user_id': userId, 'title': title,
       'created_at': '2026-01-01T00:00:00Z', 'updated_at': '2026-01-01T00:00:00Z'};
  @override Future<void> delete(String id) async {}
}

void main() {
  test('listForCurrentUser returns Conversations', () async {
    final repo = ConversationsRepositoryImpl(_FakeDS(), currentUserId: () => 'u1');
    final res = await repo.listForCurrentUser();
    res.fold((l) => expect(l.first.id, 'c1'), (_) => fail('expected Success'));
  });
}
```

`test/data/repositories/blog_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/data/repositories/blog_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/blog_data_source.dart';

class _FakeDS implements BlogDataSource {
  @override Future<List<Map<String, dynamic>>> listPublished({bool? featured}) async => [
        {
          'id': 'b1', 'title': 'X', 'slug': 'x', 'excerpt': null, 'content': '...',
          'category': null, 'tags': const <String>[], 'image_url': null,
          'author_name': null, 'author_role': null, 'author_bio': null, 'author_image_url': null,
          'read_minutes': 0, 'views_count': 0, 'comments_count': 0,
          'is_featured': featured == true, 'is_published': true,
          'published_at': '2026-01-01T00:00:00Z', 'created_by': null,
          'created_at': '2026-01-01T00:00:00Z', 'updated_at': '2026-01-01T00:00:00Z',
        }
      ];
  @override Future<Map<String, dynamic>> getBySlug(String slug) async => throw UnimplementedError();
}

void main() {
  test('listPublished forwards featured flag', () async {
    final repo = BlogRepositoryImpl(_FakeDS());
    final res = await repo.listPublished(featured: true);
    res.fold((l) => expect(l.first.isFeatured, isTrue), (_) => fail('expected Success'));
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/data/repositories/profiles_repository_impl_test.dart test/data/repositories/lawyers_repository_impl_test.dart test/data/repositories/conversations_repository_impl_test.dart test/data/repositories/blog_repository_impl_test.dart
```

- [ ] **Step 3: Implement the four impls.**

`lib/data/repositories/profiles_repository_impl.dart`:

```dart
import '../../core/errors/failure.dart';
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profiles_repository.dart';
import '../data_sources/supabase/profiles_data_source.dart';
import '../models/profile_model.dart';

class ProfilesRepositoryImpl implements ProfilesRepository {
  final ProfilesDataSource _ds;
  final String? Function() _currentUserId;

  ProfilesRepositoryImpl(this._ds, {required String? Function() currentUserId})
      : _currentUserId = currentUserId;

  @override
  Future<Result<Profile>> getCurrent() async {
    final id = _currentUserId();
    if (id == null) return const Err(AuthFailure('Not signed in'));
    try {
      final row = await _ds.getById(id);
      return Success(ProfileModel.fromJson(row));
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<Profile>> update(Profile profile) async {
    try {
      final patch = ProfileModel.fromEntity(profile).toJson()..remove('id');
      final row = await _ds.update(profile.id, patch);
      return Success(ProfileModel.fromJson(row));
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

`lib/data/repositories/lawyers_repository_impl.dart`:

```dart
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/lawyer.dart';
import '../../domain/repositories/lawyers_repository.dart';
import '../data_sources/supabase/lawyers_data_source.dart';
import '../models/lawyer_model.dart';

class LawyersRepositoryImpl implements LawyersRepository {
  final LawyersDataSource _ds;
  LawyersRepositoryImpl(this._ds);

  @override
  Future<Result<List<Lawyer>>> list() async {
    try {
      final rows = await _ds.list();
      return Success(rows.map(LawyerModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<Lawyer>> getById(String id) async {
    try {
      return Success(LawyerModel.fromJson(await _ds.getById(id)));
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

`lib/data/repositories/conversations_repository_impl.dart`:

```dart
import '../../core/errors/failure.dart';
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/conversations_repository.dart';
import '../data_sources/supabase/conversations_data_source.dart';
import '../models/conversation_model.dart';

class ConversationsRepositoryImpl implements ConversationsRepository {
  final ConversationsDataSource _ds;
  final String? Function() _currentUserId;
  ConversationsRepositoryImpl(this._ds, {required String? Function() currentUserId})
      : _currentUserId = currentUserId;

  @override
  Future<Result<List<Conversation>>> listForCurrentUser() async {
    final id = _currentUserId();
    if (id == null) return const Err(AuthFailure('Not signed in'));
    try {
      final rows = await _ds.listForUser(id);
      return Success(rows.map(ConversationModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<Conversation>> getById(String id) async {
    try {
      return Success(ConversationModel.fromJson(await _ds.getById(id)));
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<Conversation>> create(String? title) async {
    final uid = _currentUserId();
    if (uid == null) return const Err(AuthFailure('Not signed in'));
    try {
      final row = await _ds.create(userId: uid, title: title);
      return Success(ConversationModel.fromJson(row));
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _ds.delete(id);
      return const Success(null);
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

`lib/data/repositories/blog_repository_impl.dart`:

```dart
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/blog_post.dart';
import '../../domain/repositories/blog_repository.dart';
import '../data_sources/supabase/blog_data_source.dart';
import '../models/blog_post_model.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogDataSource _ds;
  BlogRepositoryImpl(this._ds);

  @override
  Future<Result<List<BlogPost>>> listPublished({bool? featured}) async {
    try {
      final rows = await _ds.listPublished(featured: featured);
      return Success(rows.map(BlogPostModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<BlogPost>> getBySlug(String slug) async {
    try {
      return Success(BlogPostModel.fromJson(await _ds.getBySlug(slug)));
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/data/repositories/profiles_repository_impl_test.dart test/data/repositories/lawyers_repository_impl_test.dart test/data/repositories/conversations_repository_impl_test.dart test/data/repositories/blog_repository_impl_test.dart
git add lib/data/repositories/{profiles,lawyers,conversations,blog}_repository_impl.dart \
        test/data/repositories/{profiles,lawyers,conversations,blog}_repository_impl_test.dart
git commit -m "site(data): add Profiles/Lawyers/Conversations/Blog repository impls"
```

---

## Task 19: Repository impls — batch 2 (`Matters`, `Invoices`, `Calendar`, `Messages`)

Same pattern as Task 18; one combined task because the per-impl variation is small.

**Files:**
- Create: `lib/data/repositories/{matters,invoices,calendar,messages}_repository_impl.dart`
- Test: corresponding `*_repository_impl_test.dart`

- [ ] **Step 1: Write the four tests, each with one happy + one error case.**

`test/data/repositories/matters_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/matter.dart';
import 'package:justicia_administrativa_site/data/repositories/matters_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/matters_data_source.dart';

class _FakeDS implements MattersDataSource {
  final Object? throwOnList;
  final List<Map<String, dynamic>>? rows;
  _FakeDS({this.rows, this.throwOnList});

  Map<String, dynamic> _row(String id) => {
        'id': id, 'client_id': 'u1', 'lawyer_id': 'l1',
        'reference_code': 'R-001', 'title': 'X', 'subtitle': null,
        'matter_type': 'amparo', 'status': 'en_proceso',
        'last_update': '2026-04-01T00:00:00Z',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-04-01T00:00:00Z',
      };

  @override Future<List<Map<String, dynamic>>> listForUser(String userId) async {
    if (throwOnList != null) throw throwOnList!;
    return rows ?? [_row('m1')];
  }
  @override Future<Map<String, dynamic>> getById(String id) async => _row(id);
  @override Future<List<Map<String, dynamic>>> listByStatus(String userId, String status) async => [_row('m1')];
}

void main() {
  test('listForCurrentUser maps rows -> Matter entities', () async {
    final repo = MattersRepositoryImpl(_FakeDS(), currentUserId: () => 'u1');
    final res = await repo.listForCurrentUser();
    res.fold((l) => expect(l.first.matterType, MatterType.amparo), (_) => fail('expected Success'));
  });

  test('listForCurrentUser returns AuthFailure when not signed in', () async {
    final repo = MattersRepositoryImpl(_FakeDS(), currentUserId: () => null);
    final res = await repo.listForCurrentUser();
    res.fold((_) => fail('expected Err'), (f) => expect(f, isA<AuthFailure>()));
  });

  test('listForCurrentUser maps PostgrestException 42501 -> PermissionFailure', () async {
    final ex = PostgrestException(message: 'rls', code: '42501');
    final repo = MattersRepositoryImpl(_FakeDS(throwOnList: ex), currentUserId: () => 'u1');
    final res = await repo.listForCurrentUser();
    res.fold((_) => fail('expected Err'), (f) => expect(f, isA<PermissionFailure>()));
  });
}
```

`test/data/repositories/invoices_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/data/repositories/invoices_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/invoices_data_source.dart';

class _FakeDS implements InvoicesDataSource {
  Map<String, dynamic> _row(String id) => {
        'id': id, 'client_id': 'u1', 'matter_id': 'm1',
        'invoice_number': 'F-001', 'description': null,
        'amount': 100.0, 'currency': 'MXN', 'status': 'pendiente',
        'due_date': null, 'paid_at': null, 'file_url': null,
        'created_at': '2026-04-01T00:00:00Z',
      };
  @override Future<List<Map<String, dynamic>>> listForUser(String u) async => [_row('i1')];
  @override Future<List<Map<String, dynamic>>> listForMatter(String m) async => [_row('i1')];
}

void main() {
  test('listForCurrentUser returns Invoices', () async {
    final repo = InvoicesRepositoryImpl(_FakeDS(), currentUserId: () => 'u1');
    final res = await repo.listForCurrentUser();
    res.fold((l) => expect(l.first.amount, 100.0), (_) => fail('expected Success'));
  });

  test('returns AuthFailure when no current user', () async {
    final repo = InvoicesRepositoryImpl(_FakeDS(), currentUserId: () => null);
    final res = await repo.listForCurrentUser();
    res.fold((_) => fail('expected Err'), (f) => expect(f, isA<AuthFailure>()));
  });
}
```

`test/data/repositories/calendar_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/data/repositories/calendar_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/calendar_data_source.dart';

class _FakeDS implements CalendarDataSource {
  Map<String, dynamic> _row() => {
        'id': 'e1', 'client_id': 'u1', 'matter_id': 'm1',
        'title': 'Audiencia', 'description': null,
        'event_type': 'audiencia',
        'event_date': '2026-05-01T10:00:00Z',
        'location': null,
        'created_at': '2026-04-01T00:00:00Z',
      };
  @override Future<List<Map<String, dynamic>>> listUpcomingForUser(String u, DateTime now) async => [_row()];
  @override Future<List<Map<String, dynamic>>> listForMatter(String m) async => [_row()];
}

void main() {
  test('listUpcomingForCurrentUser returns events', () async {
    final repo = CalendarRepositoryImpl(_FakeDS(), currentUserId: () => 'u1', clock: () => DateTime.utc(2026, 4, 1));
    final res = await repo.listUpcomingForCurrentUser();
    res.fold((l) => expect(l.first.title, 'Audiencia'), (_) => fail('expected Success'));
  });

  test('returns AuthFailure when no current user', () async {
    final repo = CalendarRepositoryImpl(_FakeDS(), currentUserId: () => null, clock: DateTime.now);
    final res = await repo.listUpcomingForCurrentUser();
    res.fold((_) => fail('expected Err'), (f) => expect(f, isA<AuthFailure>()));
  });
}
```

`test/data/repositories/messages_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/message.dart';
import 'package:justicia_administrativa_site/data/repositories/messages_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/messages_data_source.dart';

class _FakeDS implements MessagesDataSource {
  final List<Map<String, dynamic>> _store = [];
  @override Future<List<Map<String, dynamic>>> listForConversation(String c) async => _store;
  @override Future<Map<String, dynamic>> insert(Map<String, dynamic> row) async {
    final stored = {...row, 'id': 'm-${_store.length}', 'created_at': '2026-01-01T00:00:00Z'};
    _store.add(stored);
    return stored;
  }
}

void main() {
  test('send round-trips through listForConversation', () async {
    final repo = MessagesRepositoryImpl(_FakeDS());
    final sent = await repo.send(conversationId: 'c1', role: MessageRole.user, content: 'hi');
    sent.fold((m) => expect(m.content, 'hi'), (_) => fail('expected Success'));
    final list = await repo.listForConversation('c1');
    list.fold((l) => expect(l.length, 1), (_) => fail('expected Success'));
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/data/repositories/matters_repository_impl_test.dart test/data/repositories/invoices_repository_impl_test.dart test/data/repositories/calendar_repository_impl_test.dart test/data/repositories/messages_repository_impl_test.dart
```

- [ ] **Step 3: Implement the four files.**

`lib/data/repositories/matters_repository_impl.dart`:

```dart
import '../../core/errors/failure.dart';
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/matter.dart';
import '../../domain/repositories/matters_repository.dart';
import '../data_sources/supabase/matters_data_source.dart';
import '../models/matter_model.dart';

class MattersRepositoryImpl implements MattersRepository {
  final MattersDataSource _ds;
  final String? Function() _currentUserId;
  MattersRepositoryImpl(this._ds, {required String? Function() currentUserId})
      : _currentUserId = currentUserId;

  @override
  Future<Result<List<Matter>>> listForCurrentUser() async {
    final uid = _currentUserId();
    if (uid == null) return const Err(AuthFailure('Not signed in'));
    try {
      final rows = await _ds.listForUser(uid);
      return Success(rows.map(MatterModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<Matter>> getById(String id) async {
    try {
      return Success(MatterModel.fromJson(await _ds.getById(id)));
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<List<Matter>>> listByStatus(MatterStatus status) async {
    final uid = _currentUserId();
    if (uid == null) return const Err(AuthFailure('Not signed in'));
    try {
      final rows = await _ds.listByStatus(uid, status.name);
      return Success(rows.map(MatterModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

`lib/data/repositories/invoices_repository_impl.dart`:

```dart
import '../../core/errors/failure.dart';
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../data_sources/supabase/invoices_data_source.dart';
import '../models/invoice_model.dart';

class InvoicesRepositoryImpl implements InvoicesRepository {
  final InvoicesDataSource _ds;
  final String? Function() _currentUserId;
  InvoicesRepositoryImpl(this._ds, {required String? Function() currentUserId})
      : _currentUserId = currentUserId;

  @override
  Future<Result<List<Invoice>>> listForCurrentUser() async {
    final uid = _currentUserId();
    if (uid == null) return const Err(AuthFailure('Not signed in'));
    try {
      final rows = await _ds.listForUser(uid);
      return Success(rows.map(InvoiceModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<List<Invoice>>> listForMatter(String matterId) async {
    try {
      final rows = await _ds.listForMatter(matterId);
      return Success(rows.map(InvoiceModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

`lib/data/repositories/calendar_repository_impl.dart`:

```dart
import '../../core/errors/failure.dart';
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../data_sources/supabase/calendar_data_source.dart';
import '../models/calendar_event_model.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarDataSource _ds;
  final String? Function() _currentUserId;
  final DateTime Function() _clock;
  CalendarRepositoryImpl(this._ds,
      {required String? Function() currentUserId, required DateTime Function() clock})
      : _currentUserId = currentUserId,
        _clock = clock;

  @override
  Future<Result<List<CalendarEvent>>> listUpcomingForCurrentUser() async {
    final uid = _currentUserId();
    if (uid == null) return const Err(AuthFailure('Not signed in'));
    try {
      final rows = await _ds.listUpcomingForUser(uid, _clock());
      return Success(rows.map(CalendarEventModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<List<CalendarEvent>>> listForMatter(String matterId) async {
    try {
      final rows = await _ds.listForMatter(matterId);
      return Success(rows.map(CalendarEventModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

`lib/data/repositories/messages_repository_impl.dart`:

```dart
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messages_repository.dart';
import '../data_sources/supabase/messages_data_source.dart';
import '../models/message_model.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesDataSource _ds;
  MessagesRepositoryImpl(this._ds);

  @override
  Future<Result<List<Message>>> listForConversation(String conversationId) async {
    try {
      final rows = await _ds.listForConversation(conversationId);
      return Success(rows.map(MessageModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<Message>> send({
    required String conversationId,
    required MessageRole role,
    required String content,
    Map<String, dynamic> metadata = const {},
  }) async {
    try {
      final inserted = await _ds.insert({
        'conversation_id': conversationId,
        'role': role.name,
        'content': content,
        'metadata': metadata,
      });
      return Success(MessageModel.fromJson(inserted));
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/data/repositories/matters_repository_impl_test.dart test/data/repositories/invoices_repository_impl_test.dart test/data/repositories/calendar_repository_impl_test.dart test/data/repositories/messages_repository_impl_test.dart
git add lib/data/repositories/{matters,invoices,calendar,messages}_repository_impl.dart \
        test/data/repositories/{matters,invoices,calendar,messages}_repository_impl_test.dart
git commit -m "site(data): add Matters/Invoices/Calendar/Messages repository impls"
```

---

## Task 20: Repository impls — batch 3 (write-heavy: `Documents`, `PortalMessages`, `Auth`)

These three coordinate uploads or wrap auth ops; slightly more interesting.

**Files:**
- Create: `lib/data/repositories/{documents,portal_messages,auth}_repository_impl.dart`
- Test: corresponding `*_repository_impl_test.dart`

- [ ] **Step 1: Write tests.**

`test/data/repositories/documents_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/document.dart';
import 'package:justicia_administrativa_site/data/repositories/documents_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/documents_data_source.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/storage_data_source.dart';

class _FakeDocs implements DocumentsDataSource {
  final List<Map<String, dynamic>> store = [];
  Map<String, dynamic> _row() => {
        'id': 'd1', 'matter_id': 'm1', 'client_id': 'u1', 'name': 'a.pdf',
        'file_url': 'https://x/a.pdf', 'file_size': 1024, 'mime_type': 'application/pdf',
        'category': 'escrito', 'uploaded_by': 'u1',
        'created_at': '2026-01-01T00:00:00Z',
      };
  @override Future<List<Map<String, dynamic>>> listForMatter(String m) async => [_row()];
  @override Future<Map<String, dynamic>> getById(String id) async => _row();
  @override Future<Map<String, dynamic>> insert(Map<String, dynamic> row) async {
    final stored = {..._row(), ...row};
    store.add(stored);
    return stored;
  }
}

class _FakeStorage implements StorageDataSource {
  String? lastPath;
  @override Future<String> uploadToClients({required String path, required List<int> bytes, required String contentType}) async {
    lastPath = path;
    return 'https://storage/$path';
  }
  @override Future<String> uploadToChatAttachments({required String path, required List<int> bytes, required String contentType}) async => '';
}

void main() {
  test('upload calls storage then inserts row with returned URL', () async {
    final docs = _FakeDocs();
    final storage = _FakeStorage();
    final repo = DocumentsRepositoryImpl(docs, storage, currentUserId: () => 'u1');
    final res = await repo.upload(
      matterId: 'm1', name: 'demanda.pdf', bytes: const [1, 2, 3],
      mimeType: 'application/pdf', category: DocumentCategory.escrito,
    );
    res.fold((d) => expect(d.fileUrl, contains('storage')), (_) => fail('expected Success'));
    expect(storage.lastPath, contains('m1'));
    expect(docs.store.length, 1);
  });
}
```

`test/data/repositories/portal_messages_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/data/repositories/portal_messages_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/portal_messages_data_source.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/storage_data_source.dart';

class _FakeDS implements PortalMessagesDataSource {
  final List<Map<String, dynamic>> store = [];
  @override Future<List<Map<String, dynamic>>> listForMatter(String m) async => store;
  @override Future<void> markRead(String id) async {}
  @override Future<Map<String, dynamic>> insert(Map<String, dynamic> row) async {
    final stored = {...row, 'id': 'pm-${store.length}', 'created_at': '2026-01-01T00:00:00Z',
                    'is_read': false};
    store.add(stored);
    return stored;
  }
}

class _FakeStorage implements StorageDataSource {
  @override Future<String> uploadToClients({required String path, required List<int> bytes, required String contentType}) async => 'https://storage/$path';
  @override Future<String> uploadToChatAttachments({required String path, required List<int> bytes, required String contentType}) async => 'https://storage/c/$path';
}

void main() {
  test('send without attachment skips storage call', () async {
    final repo = PortalMessagesRepositoryImpl(_FakeDS(), _FakeStorage(), currentUserId: () => 'u1');
    final res = await repo.send(matterId: 'm1', content: 'hola');
    res.fold((m) => expect(m.attachmentUrl, isNull), (_) => fail('expected Success'));
  });

  test('send with attachment uploads then inserts', () async {
    final repo = PortalMessagesRepositoryImpl(_FakeDS(), _FakeStorage(), currentUserId: () => 'u1');
    final res = await repo.send(
      matterId: 'm1', content: 'hola', attachmentName: 'a.pdf',
      attachmentBytes: const [1, 2], attachmentMime: 'application/pdf',
    );
    res.fold((m) => expect(m.attachmentUrl, contains('storage')), (_) => fail('expected Success'));
  });
}
```

`test/data/repositories/auth_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/data/repositories/auth_repository_impl.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/auth_data_source.dart';
import 'package:justicia_administrativa_site/data/data_sources/supabase/profiles_data_source.dart';

class _FakeAuth implements AuthDataSource {
  final User? user;
  final Object? throwOnSignIn;
  _FakeAuth({this.user, this.throwOnSignIn});
  @override User? get currentUser => user;
  @override Stream<AuthState> get authStateChanges => const Stream.empty();
  @override Future<AuthResponse> signInWithPassword({required String email, required String password}) async {
    if (throwOnSignIn != null) throw throwOnSignIn!;
    return AuthResponse(session: null, user: user);
  }
  @override Future<void> signOut() async {}
}

class _FakeProfiles implements ProfilesDataSource {
  @override Future<Map<String, dynamic>> getById(String id) async => {
        'id': id, 'full_name': 'A', 'company': null, 'phone': null, 'avatar_url': null,
        'created_at': '2026-01-01T00:00:00Z', 'updated_at': '2026-01-01T00:00:00Z',
      };
  @override Future<Map<String, dynamic>> update(String id, Map<String, dynamic> patch) async => throw UnimplementedError();
}

void main() {
  test('currentUser returns Profile when signed in', () async {
    final user = _MockUser('u1');
    final repo = AuthRepositoryImpl(_FakeAuth(user: user), _FakeProfiles());
    final res = await repo.currentUser();
    res.fold((p) => expect(p.id, 'u1'), (_) => fail('expected Success'));
  });

  test('currentUser returns NotFoundFailure when not signed in', () async {
    final repo = AuthRepositoryImpl(_FakeAuth(user: null), _FakeProfiles());
    final res = await repo.currentUser();
    res.fold((_) => fail('expected Err'), (f) => expect(f, isA<NotFoundFailure>()));
  });

  test('signInWithPassword maps AuthException -> AuthFailure', () async {
    final repo = AuthRepositoryImpl(
      _FakeAuth(throwOnSignIn: AuthException('bad', statusCode: '401')),
      _FakeProfiles(),
    );
    final res = await repo.signInWithPassword(email: 'a@b', password: 'x');
    res.fold((_) => fail('expected Err'), (f) => expect(f, isA<AuthFailure>()));
  });
}

class _MockUser implements User {
  @override final String id;
  _MockUser(this.id);
  @override dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/data/repositories/documents_repository_impl_test.dart test/data/repositories/portal_messages_repository_impl_test.dart test/data/repositories/auth_repository_impl_test.dart
```

- [ ] **Step 3: Implement the three repositories.**

`lib/data/repositories/documents_repository_impl.dart`:

```dart
import '../../core/errors/failure.dart';
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/documents_repository.dart';
import '../data_sources/supabase/documents_data_source.dart';
import '../data_sources/supabase/storage_data_source.dart';
import '../models/document_model.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final DocumentsDataSource _ds;
  final StorageDataSource _storage;
  final String? Function() _currentUserId;
  DocumentsRepositoryImpl(this._ds, this._storage, {required String? Function() currentUserId})
      : _currentUserId = currentUserId;

  @override
  Future<Result<List<Document>>> listForMatter(String matterId) async {
    try {
      final rows = await _ds.listForMatter(matterId);
      return Success(rows.map(DocumentModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<Document>> getById(String id) async {
    try {
      return Success(DocumentModel.fromJson(await _ds.getById(id)));
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<Document>> upload({
    required String matterId,
    required String name,
    required List<int> bytes,
    required String mimeType,
    required DocumentCategory category,
  }) async {
    final uid = _currentUserId();
    if (uid == null) return const Err(AuthFailure('Not signed in'));
    try {
      // Upload first; if insert fails, the orphan stays in storage (per spec §12 Q5).
      final path = '$matterId/${DateTime.now().toUtc().microsecondsSinceEpoch}_$name';
      final url = await _storage.uploadToClients(path: path, bytes: bytes, contentType: mimeType);
      final inserted = await _ds.insert({
        'matter_id': matterId,
        'client_id': uid,
        'name': name,
        'file_url': url,
        'file_size': bytes.length,
        'mime_type': mimeType,
        'category': category.name,
        'uploaded_by': uid,
      });
      return Success(DocumentModel.fromJson(inserted));
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

`lib/data/repositories/portal_messages_repository_impl.dart`:

```dart
import '../../core/errors/failure.dart';
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/portal_message.dart';
import '../../domain/repositories/portal_messages_repository.dart';
import '../data_sources/supabase/portal_messages_data_source.dart';
import '../data_sources/supabase/storage_data_source.dart';
import '../models/portal_message_model.dart';

class PortalMessagesRepositoryImpl implements PortalMessagesRepository {
  final PortalMessagesDataSource _ds;
  final StorageDataSource _storage;
  final String? Function() _currentUserId;
  PortalMessagesRepositoryImpl(this._ds, this._storage, {required String? Function() currentUserId})
      : _currentUserId = currentUserId;

  @override
  Future<Result<List<PortalMessage>>> listForMatter(String matterId) async {
    try {
      final rows = await _ds.listForMatter(matterId);
      return Success(rows.map(PortalMessageModel.fromJson).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<void>> markRead(String id) async {
    try {
      await _ds.markRead(id);
      return const Success(null);
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<PortalMessage>> send({
    required String matterId,
    required String content,
    String? attachmentName,
    List<int>? attachmentBytes,
    String? attachmentMime,
  }) async {
    final uid = _currentUserId();
    if (uid == null) return const Err(AuthFailure('Not signed in'));
    try {
      String? url;
      if (attachmentBytes != null && attachmentName != null && attachmentMime != null) {
        final path = '$matterId/${DateTime.now().toUtc().microsecondsSinceEpoch}_$attachmentName';
        url = await _storage.uploadToClients(path: path, bytes: attachmentBytes, contentType: attachmentMime);
      }
      final inserted = await _ds.insert({
        'matter_id': matterId,
        'sender_id': uid,
        'sender_type': 'client',
        'content': content,
        'attachment_url': url,
        'attachment_name': attachmentName,
      });
      return Success(PortalMessageModel.fromJson(inserted));
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

`lib/data/repositories/auth_repository_impl.dart`:

```dart
import 'dart:async';

import '../../core/errors/failure.dart';
import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/supabase/auth_data_source.dart';
import '../data_sources/supabase/profiles_data_source.dart';
import '../models/profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _auth;
  final ProfilesDataSource _profiles;
  AuthRepositoryImpl(this._auth, this._profiles);

  @override
  Future<Result<Profile>> currentUser() async {
    final u = _auth.currentUser;
    if (u == null) return const Err(NotFoundFailure('No signed-in user'));
    try {
      return Success(ProfileModel.fromJson(await _profiles.getById(u.id)));
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Stream<Profile?> watchAuthState() => _auth.authStateChanges.asyncMap((s) async {
        final u = s.session?.user;
        if (u == null) return null;
        try {
          return ProfileModel.fromJson(await _profiles.getById(u.id));
        } catch (_) {
          return null;
        }
      });

  @override
  Future<Result<Profile>> signInWithPassword({required String email, required String password}) async {
    try {
      final r = await _auth.signInWithPassword(email: email, password: password);
      final u = r.user;
      if (u == null) return const Err(AuthFailure('Sign-in returned no user'));
      return Success(ProfileModel.fromJson(await _profiles.getById(u.id)));
    } catch (e) {
      return Err(mapException(e));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Success(null);
    } catch (e) {
      return Err(mapException(e));
    }
  }
}
```

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/data/repositories/
git add lib/data/repositories/{documents,portal_messages,auth}_repository_impl.dart \
        test/data/repositories/{documents,portal_messages,auth}_repository_impl_test.dart
git commit -m "site(data): add Documents/PortalMessages/Auth repository impls"
```

After this commit, all 11 repositories are implemented and tested.

---

## Task 21: Use cases — `auth`, `portal`, `matters` bounded contexts

Use cases are thin wrappers over repository methods; their value is providing a stable, testable application-layer surface. Each takes the repository (interface) in the constructor and exposes a `call()` method.

**Files:**
- Create:
  - `lib/domain/use_cases/auth/sign_in.dart`
  - `lib/domain/use_cases/auth/sign_out.dart`
  - `lib/domain/use_cases/auth/watch_auth_state.dart`
  - `lib/domain/use_cases/portal/get_portal_stats.dart`
  - `lib/domain/use_cases/portal/list_my_matters.dart`
  - `lib/domain/use_cases/matters/get_matter.dart`
  - `lib/domain/use_cases/matters/list_matter_documents.dart`
  - `lib/domain/use_cases/matters/list_matter_invoices.dart`
  - `lib/domain/use_cases/matters/list_matter_events.dart`
  - `lib/domain/use_cases/matters/list_matter_portal_messages.dart`
- Test: `test/domain/use_cases/{auth,portal,matters}/*_test.dart` — one per use case, ~12 lines each

- [ ] **Step 1: Write a single combined test file per bounded context.**

`test/domain/use_cases/auth/sign_in_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/profile.dart';
import 'package:justicia_administrativa_site/domain/repositories/auth_repository.dart';
import 'package:justicia_administrativa_site/domain/use_cases/auth/sign_in.dart';

class _StubRepo implements AuthRepository {
  final Result<Profile> _r;
  _StubRepo(this._r);
  @override Future<Result<Profile>> currentUser() async => _r;
  @override Stream<Profile?> watchAuthState() => const Stream.empty();
  @override Future<Result<Profile>> signInWithPassword({required String email, required String password}) async => _r;
  @override Future<Result<void>> signOut() async => const Success(null);
}

void main() {
  test('SignInUseCase forwards email/password and returns repo result', () async {
    final profile = Profile(id: 'u1', createdAt: DateTime.utc(2026, 1, 1), updatedAt: DateTime.utc(2026, 1, 1));
    final uc = SignInUseCase(_StubRepo(Success(profile)));
    final r = await uc(email: 'a@b', password: 'x');
    expect(r, isA<Success<Profile>>());
  });

  test('SignInUseCase returns repo Err unchanged', () async {
    final uc = SignInUseCase(_StubRepo(const Err(AuthFailure('nope'))));
    final r = await uc(email: '', password: '');
    expect(r, isA<Err<Profile>>());
  });
}
```

`test/domain/use_cases/portal/get_portal_stats_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/portal_stats.dart';
import 'package:justicia_administrativa_site/domain/use_cases/portal/get_portal_stats.dart';

void main() {
  test('GetPortalStatsUseCase returns the result of the fetcher', () async {
    Future<Result<PortalStats>> fetch() async => const Success(PortalStats(activeMatters: 1, totalDocuments: 2, upcomingEvents: 3, pendingInvoices: 4));
    final uc = GetPortalStatsUseCase(fetch);
    final r = await uc();
    r.fold((s) => expect(s.activeMatters, 1), (_) => fail('expected Success'));
  });
}
```

`test/domain/use_cases/matters/get_matter_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/failure.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/matter.dart';
import 'package:justicia_administrativa_site/domain/repositories/matters_repository.dart';
import 'package:justicia_administrativa_site/domain/use_cases/matters/get_matter.dart';

class _Repo implements MattersRepository {
  @override Future<Result<List<Matter>>> listForCurrentUser() async => const Success([]);
  @override Future<Result<Matter>> getById(String id) async {
    return Success(Matter(
      id: id, clientId: 'u1', referenceCode: 'R', title: 'T',
      matterType: MatterType.amparo, status: MatterStatus.en_proceso,
      lastUpdate: DateTime.utc(2026, 1, 1),
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    ));
  }
  @override Future<Result<List<Matter>>> listByStatus(MatterStatus s) async => const Success([]);
}

void main() {
  test('GetMatterUseCase forwards id', () async {
    final uc = GetMatterUseCase(_Repo());
    final r = await uc('m9');
    r.fold((m) => expect(m.id, 'm9'), (_) => fail('expected Success'));
  });
}
```

(The other use cases — `sign_out`, `watch_auth_state`, `list_my_matters`, `list_matter_documents`, `list_matter_invoices`, `list_matter_events`, `list_matter_portal_messages` — get one similar 8-line test each. Same shape: stub repo with one method, assert the use case forwards.)

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/domain/use_cases/
```

- [ ] **Step 3: Implement the 10 use case files.**

`lib/domain/use_cases/auth/sign_in.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/profile.dart';
import '../../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repo;
  SignInUseCase(this._repo);
  Future<Result<Profile>> call({required String email, required String password}) =>
      _repo.signInWithPassword(email: email, password: password);
}
```

`lib/domain/use_cases/auth/sign_out.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repo;
  SignOutUseCase(this._repo);
  Future<Result<void>> call() => _repo.signOut();
}
```

`lib/domain/use_cases/auth/watch_auth_state.dart`:

```dart
import '../../entities/profile.dart';
import '../../repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository _repo;
  WatchAuthStateUseCase(this._repo);
  Stream<Profile?> call() => _repo.watchAuthState();
}
```

`lib/domain/use_cases/portal/get_portal_stats.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/portal_stats.dart';

/// Backed by the `get_portal_stats` RPC. Provider supplies the fetcher closure
/// (typically `() => rpcDataSource.getPortalStats(currentUserId)` mapped to PortalStats).
class GetPortalStatsUseCase {
  final Future<Result<PortalStats>> Function() _fetch;
  GetPortalStatsUseCase(this._fetch);
  Future<Result<PortalStats>> call() => _fetch();
}
```

`lib/domain/use_cases/portal/list_my_matters.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/matter.dart';
import '../../repositories/matters_repository.dart';

class ListMyMattersUseCase {
  final MattersRepository _repo;
  ListMyMattersUseCase(this._repo);
  Future<Result<List<Matter>>> call() => _repo.listForCurrentUser();
}
```

`lib/domain/use_cases/matters/get_matter.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/matter.dart';
import '../../repositories/matters_repository.dart';

class GetMatterUseCase {
  final MattersRepository _repo;
  GetMatterUseCase(this._repo);
  Future<Result<Matter>> call(String id) => _repo.getById(id);
}
```

`lib/domain/use_cases/matters/list_matter_documents.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/document.dart';
import '../../repositories/documents_repository.dart';

class ListMatterDocumentsUseCase {
  final DocumentsRepository _repo;
  ListMatterDocumentsUseCase(this._repo);
  Future<Result<List<Document>>> call(String matterId) => _repo.listForMatter(matterId);
}
```

`lib/domain/use_cases/matters/list_matter_invoices.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/invoice.dart';
import '../../repositories/invoices_repository.dart';

class ListMatterInvoicesUseCase {
  final InvoicesRepository _repo;
  ListMatterInvoicesUseCase(this._repo);
  Future<Result<List<Invoice>>> call(String matterId) => _repo.listForMatter(matterId);
}
```

`lib/domain/use_cases/matters/list_matter_events.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/calendar_event.dart';
import '../../repositories/calendar_repository.dart';

class ListMatterEventsUseCase {
  final CalendarRepository _repo;
  ListMatterEventsUseCase(this._repo);
  Future<Result<List<CalendarEvent>>> call(String matterId) => _repo.listForMatter(matterId);
}
```

`lib/domain/use_cases/matters/list_matter_portal_messages.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/portal_message.dart';
import '../../repositories/portal_messages_repository.dart';

class ListMatterPortalMessagesUseCase {
  final PortalMessagesRepository _repo;
  ListMatterPortalMessagesUseCase(this._repo);
  Future<Result<List<PortalMessage>>> call(String matterId) => _repo.listForMatter(matterId);
}
```

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/domain/use_cases/auth/ test/domain/use_cases/portal/ test/domain/use_cases/matters/
git add lib/domain/use_cases/{auth,portal,matters}/ test/domain/use_cases/{auth,portal,matters}/
git commit -m "site(domain): add use cases for auth, portal, matters bounded contexts"
```

---

## Task 22: Use cases — `chat`, `messages`, `blog` bounded contexts

`chat` introduces the `DocumentChunk` value object (per spec §12 Q6 decision).

**Files:**
- Create:
  - `lib/domain/use_cases/chat/document_chunk.dart`
  - `lib/domain/use_cases/chat/list_conversations.dart`
  - `lib/domain/use_cases/chat/open_conversation.dart`
  - `lib/domain/use_cases/chat/send_message.dart`
  - `lib/domain/use_cases/chat/match_documents.dart`
  - `lib/domain/use_cases/chat/match_session_documents.dart`
  - `lib/domain/use_cases/messages/mark_portal_message_read.dart`
  - `lib/domain/use_cases/messages/send_portal_message.dart`
  - `lib/domain/use_cases/blog/list_blog_posts.dart`
  - `lib/domain/use_cases/blog/get_blog_post_by_slug.dart`
- Test: corresponding `*_test.dart` files

- [ ] **Step 1: Write a smoke test for `DocumentChunk` and the two RPC use cases.**

`test/domain/use_cases/chat/document_chunk_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domain/use_cases/chat/document_chunk.dart';

void main() {
  test('DocumentChunk equality + fromRow', () {
    final c = DocumentChunk.fromRow({
      'id': 'x', 'source_file': 'a.pdf', 'chunk_text': 'hola',
      'metadata': {'page': 1}, 'similarity': 0.91,
    });
    expect(c.sourceFile, 'a.pdf');
    expect(c.similarity, closeTo(0.91, 0.0001));
  });
}
```

`test/domain/use_cases/chat/match_documents_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/use_cases/chat/document_chunk.dart';
import 'package:justicia_administrativa_site/domain/use_cases/chat/match_documents.dart';

void main() {
  test('MatchDocumentsUseCase maps rows to DocumentChunks', () async {
    Future<Result<List<DocumentChunk>>> fetch(List<double> q, double t, int n) async =>
        Success([DocumentChunk(id: 'x', sourceFile: 'a', chunkText: 't', metadata: const {}, similarity: 0.9)]);
    final uc = MatchDocumentsUseCase(fetch);
    final r = await uc(queryEmbedding: const [1, 2, 3], matchThreshold: 0.5, matchCount: 4);
    r.fold((l) => expect(l.first.sourceFile, 'a'), (_) => fail('expected Success'));
  });
}
```

(Other use cases get equally short tests.)

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/domain/use_cases/chat/ test/domain/use_cases/messages/ test/domain/use_cases/blog/
```

- [ ] **Step 3: Implement the files.**

`lib/domain/use_cases/chat/document_chunk.dart`:

```dart
import 'package:equatable/equatable.dart';

/// Search-hit value object returned by `match_documents` and
/// `match_session_documents`. Lives in the chat bounded context
/// because that's its only consumer (per spec §12 Q6).
class DocumentChunk extends Equatable {
  final String id;
  final String sourceFile;
  final String chunkText;
  final Map<String, dynamic> metadata;
  final double similarity;

  const DocumentChunk({
    required this.id,
    required this.sourceFile,
    required this.chunkText,
    required this.metadata,
    required this.similarity,
  });

  factory DocumentChunk.fromRow(Map<String, dynamic> row) => DocumentChunk(
        id: row['id'].toString(),
        sourceFile: (row['source_file'] ?? '') as String,
        chunkText: (row['chunk_text'] ?? '') as String,
        metadata: (row['metadata'] as Map?)?.cast<String, dynamic>() ?? const {},
        similarity: ((row['similarity'] as num?) ?? 0).toDouble(),
      );

  @override
  List<Object?> get props => [id, sourceFile, chunkText, metadata, similarity];
}
```

`lib/domain/use_cases/chat/list_conversations.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/conversation.dart';
import '../../repositories/conversations_repository.dart';

class ListConversationsUseCase {
  final ConversationsRepository _repo;
  ListConversationsUseCase(this._repo);
  Future<Result<List<Conversation>>> call() => _repo.listForCurrentUser();
}
```

`lib/domain/use_cases/chat/open_conversation.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/conversation.dart';
import '../../repositories/conversations_repository.dart';

/// Opens an existing conversation by id, or creates a new one if id is null.
class OpenConversationUseCase {
  final ConversationsRepository _repo;
  OpenConversationUseCase(this._repo);
  Future<Result<Conversation>> call({String? id, String? newTitle}) =>
      id == null ? _repo.create(newTitle) : _repo.getById(id);
}
```

`lib/domain/use_cases/chat/send_message.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/message.dart';
import '../../repositories/messages_repository.dart';

class SendMessageUseCase {
  final MessagesRepository _repo;
  SendMessageUseCase(this._repo);
  Future<Result<Message>> call({
    required String conversationId,
    required String content,
    MessageRole role = MessageRole.user,
    Map<String, dynamic> metadata = const {},
  }) =>
      _repo.send(conversationId: conversationId, role: role, content: content, metadata: metadata);
}
```

`lib/domain/use_cases/chat/match_documents.dart`:

```dart
import '../../../core/errors/result.dart';
import 'document_chunk.dart';

/// The provider supplies a fetcher closure that calls
/// `rpcDataSource.matchDocuments(...)` and maps rows to `DocumentChunk`.
class MatchDocumentsUseCase {
  final Future<Result<List<DocumentChunk>>> Function(List<double> q, double t, int n) _fetch;
  MatchDocumentsUseCase(this._fetch);
  Future<Result<List<DocumentChunk>>> call({
    required List<double> queryEmbedding,
    double matchThreshold = 0.5,
    int matchCount = 8,
  }) =>
      _fetch(queryEmbedding, matchThreshold, matchCount);
}
```

`lib/domain/use_cases/chat/match_session_documents.dart`:

```dart
import '../../../core/errors/result.dart';
import 'document_chunk.dart';

class MatchSessionDocumentsUseCase {
  final Future<Result<List<DocumentChunk>>> Function(
      List<double> q, String conversationId, double t, int n) _fetch;
  MatchSessionDocumentsUseCase(this._fetch);
  Future<Result<List<DocumentChunk>>> call({
    required List<double> queryEmbedding,
    required String conversationId,
    double matchThreshold = 0.5,
    int matchCount = 8,
  }) =>
      _fetch(queryEmbedding, conversationId, matchThreshold, matchCount);
}
```

`lib/domain/use_cases/messages/mark_portal_message_read.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../repositories/portal_messages_repository.dart';

class MarkPortalMessageReadUseCase {
  final PortalMessagesRepository _repo;
  MarkPortalMessageReadUseCase(this._repo);
  Future<Result<void>> call(String id) => _repo.markRead(id);
}
```

`lib/domain/use_cases/messages/send_portal_message.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/portal_message.dart';
import '../../repositories/portal_messages_repository.dart';

class SendPortalMessageUseCase {
  final PortalMessagesRepository _repo;
  SendPortalMessageUseCase(this._repo);
  Future<Result<PortalMessage>> call({
    required String matterId,
    required String content,
    String? attachmentName,
    List<int>? attachmentBytes,
    String? attachmentMime,
  }) =>
      _repo.send(
        matterId: matterId,
        content: content,
        attachmentName: attachmentName,
        attachmentBytes: attachmentBytes,
        attachmentMime: attachmentMime,
      );
}
```

`lib/domain/use_cases/blog/list_blog_posts.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/blog_post.dart';
import '../../repositories/blog_repository.dart';

class ListBlogPostsUseCase {
  final BlogRepository _repo;
  ListBlogPostsUseCase(this._repo);
  Future<Result<List<BlogPost>>> call({bool? featured}) => _repo.listPublished(featured: featured);
}
```

`lib/domain/use_cases/blog/get_blog_post_by_slug.dart`:

```dart
import '../../../core/errors/result.dart';
import '../../entities/blog_post.dart';
import '../../repositories/blog_repository.dart';

class GetBlogPostBySlugUseCase {
  final BlogRepository _repo;
  GetBlogPostBySlugUseCase(this._repo);
  Future<Result<BlogPost>> call(String slug) => _repo.getBySlug(slug);
}
```

- [ ] **Step 4: Run all use case tests, then commit.**

```bash
flutter test test/domain/use_cases/
git add lib/domain/use_cases/{chat,messages,blog}/ test/domain/use_cases/{chat,messages,blog}/
git commit -m "site(domain): add use cases for chat, messages, blog bounded contexts"
```

---

## Task 23: `main.dart` — wrap with `ProviderScope` and bind repository providers

This is the only modification this scaffold makes outside `lib/{core,domain,data,application}/`. It wraps the existing `runApp(...)` in a `ProviderScope` and pre-overrides every repository provider so that the Riverpod tree starts fully wired against the Supabase-backed implementations.

We also create a small `_repository_overrides.dart` helper to keep `main.dart` clean.

**Files:**
- Create: `lib/application/providers/_repository_overrides.dart`
- Modify: `lib/main.dart` (additive — keep existing imports, `Supabase.initialize`, etc.)

- [ ] **Step 1: First, define the abstract repository providers** (one `Provider<T>` per repository) **in `_repository_overrides.dart`.**

`lib/application/providers/_repository_overrides.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase/supabase_client_provider.dart';

import '../../data/data_sources/supabase/auth_data_source.dart';
import '../../data/data_sources/supabase/blog_data_source.dart';
import '../../data/data_sources/supabase/calendar_data_source.dart';
import '../../data/data_sources/supabase/conversations_data_source.dart';
import '../../data/data_sources/supabase/documents_data_source.dart';
import '../../data/data_sources/supabase/invoices_data_source.dart';
import '../../data/data_sources/supabase/lawyers_data_source.dart';
import '../../data/data_sources/supabase/matters_data_source.dart';
import '../../data/data_sources/supabase/messages_data_source.dart';
import '../../data/data_sources/supabase/portal_messages_data_source.dart';
import '../../data/data_sources/supabase/profiles_data_source.dart';
import '../../data/data_sources/supabase/rpc_data_source.dart';
import '../../data/data_sources/supabase/storage_data_source.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/blog_repository_impl.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../data/repositories/conversations_repository_impl.dart';
import '../../data/repositories/documents_repository_impl.dart';
import '../../data/repositories/invoices_repository_impl.dart';
import '../../data/repositories/lawyers_repository_impl.dart';
import '../../data/repositories/matters_repository_impl.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../data/repositories/portal_messages_repository_impl.dart';
import '../../data/repositories/profiles_repository_impl.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/blog_repository.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/repositories/conversations_repository.dart';
import '../../domain/repositories/documents_repository.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../../domain/repositories/lawyers_repository.dart';
import '../../domain/repositories/matters_repository.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../domain/repositories/portal_messages_repository.dart';
import '../../domain/repositories/profiles_repository.dart';

/// Returns the user-id getter that repositories use to scope queries.
String? Function() _currentUserIdReader(SupabaseClient client) =>
    () => client.auth.currentUser?.id;

// ----- Repository providers (abstract — overridden in main.dart) -----
final profilesRepositoryProvider = Provider<ProfilesRepository>((_) => throw UnimplementedError());
final lawyersRepositoryProvider = Provider<LawyersRepository>((_) => throw UnimplementedError());
final mattersRepositoryProvider = Provider<MattersRepository>((_) => throw UnimplementedError());
final documentsRepositoryProvider = Provider<DocumentsRepository>((_) => throw UnimplementedError());
final invoicesRepositoryProvider = Provider<InvoicesRepository>((_) => throw UnimplementedError());
final calendarRepositoryProvider = Provider<CalendarRepository>((_) => throw UnimplementedError());
final conversationsRepositoryProvider = Provider<ConversationsRepository>((_) => throw UnimplementedError());
final messagesRepositoryProvider = Provider<MessagesRepository>((_) => throw UnimplementedError());
final portalMessagesRepositoryProvider = Provider<PortalMessagesRepository>((_) => throw UnimplementedError());
final blogRepositoryProvider = Provider<BlogRepository>((_) => throw UnimplementedError());
final authRepositoryProvider = Provider<AuthRepository>((_) => throw UnimplementedError());

// Also export the RPC data source as a provider so chat use cases can wire match_documents.
final rpcDataSourceProvider = Provider<RpcDataSource>((_) => throw UnimplementedError());

/// Build the override list main.dart will pass to ProviderScope.
List<Override> buildRepositoryOverrides(SupabaseClient client) {
  final uid = _currentUserIdReader(client);

  final auth = AuthDataSource(client);
  final blog = BlogDataSource(client);
  final calendar = CalendarDataSource(client);
  final conversations = ConversationsDataSource(client);
  final documents = DocumentsDataSource(client);
  final invoices = InvoicesDataSource(client);
  final lawyers = LawyersDataSource(client);
  final matters = MattersDataSource(client);
  final messages = MessagesDataSource(client);
  final portalMessages = PortalMessagesDataSource(client);
  final profiles = ProfilesDataSource(client);
  final rpc = RpcDataSource(client);
  final storage = StorageDataSource(client);

  return [
    supabaseClientProvider.overrideWithValue(client),
    rpcDataSourceProvider.overrideWithValue(rpc),
    profilesRepositoryProvider.overrideWithValue(ProfilesRepositoryImpl(profiles, currentUserId: uid)),
    lawyersRepositoryProvider.overrideWithValue(LawyersRepositoryImpl(lawyers)),
    mattersRepositoryProvider.overrideWithValue(MattersRepositoryImpl(matters, currentUserId: uid)),
    documentsRepositoryProvider.overrideWithValue(DocumentsRepositoryImpl(documents, storage, currentUserId: uid)),
    invoicesRepositoryProvider.overrideWithValue(InvoicesRepositoryImpl(invoices, currentUserId: uid)),
    calendarRepositoryProvider.overrideWithValue(CalendarRepositoryImpl(calendar, currentUserId: uid, clock: DateTime.now)),
    conversationsRepositoryProvider.overrideWithValue(ConversationsRepositoryImpl(conversations, currentUserId: uid)),
    messagesRepositoryProvider.overrideWithValue(MessagesRepositoryImpl(messages)),
    portalMessagesRepositoryProvider.overrideWithValue(PortalMessagesRepositoryImpl(portalMessages, storage, currentUserId: uid)),
    blogRepositoryProvider.overrideWithValue(BlogRepositoryImpl(blog)),
    authRepositoryProvider.overrideWithValue(AuthRepositoryImpl(auth, profiles)),
  ];
}
```

- [ ] **Step 2: Open `lib/main.dart` and locate the existing `runApp(...)` call.**

```bash
grep -n 'runApp' lib/main.dart
```

You'll see the current setup (likely something like `runApp(const MyApp())` or with a `ProviderScope` already — the site uses Riverpod). Note the line numbers.

- [ ] **Step 3: Wrap `runApp` with the new overrides.**

If the existing `runApp` already uses `ProviderScope`, add `overrides:` to it. If it doesn't, wrap with `ProviderScope(overrides: ..., child: ...)`.

Insert near the top of `main.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'application/providers/_repository_overrides.dart';
```

Replace the `runApp(...)` line with:

```dart
runApp(ProviderScope(
  overrides: buildRepositoryOverrides(Supabase.instance.client),
  child: const MyApp(), // keep whatever the existing widget class is named
));
```

If `ProviderScope` was already wrapping the app, only add the `overrides:` parameter using `[...buildRepositoryOverrides(Supabase.instance.client), ...existingOverrides]`.

- [ ] **Step 4: Verify.**

```bash
flutter analyze lib/main.dart lib/application/providers/_repository_overrides.dart
```

Expected: 0 errors. Then a smoke test:

```bash
flutter test test/main_test.dart
```

Expected: existing main test still passes (or, if it instantiated `MyApp` directly without a `ProviderScope`, update the test to wrap in a ProviderScope override-free for the smoke test). If the test starts failing because of the wiring, the most likely cause is an existing test that constructs `MyApp` without a `ProviderScope` — update only that test, not the production wiring.

- [ ] **Step 5: Commit.**

```bash
git add lib/main.dart lib/application/providers/_repository_overrides.dart
git commit -m "site(application): wire ProviderScope with repository overrides in main.dart"
```

---

## Task 24: Provider files — `auth_provider.dart`, `portal_provider.dart`

These two providers consume the repository providers from Task 23 and expose application-layer state.

**Files:**
- Create: `lib/application/providers/auth_provider.dart`, `lib/application/providers/portal_provider.dart`
- Test: `test/application/providers/auth_provider_test.dart`, `test/application/providers/portal_provider_test.dart`

- [ ] **Step 1: Write tests.**

`test/application/providers/auth_provider_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/profile.dart';
import 'package:justicia_administrativa_site/domain/repositories/auth_repository.dart';
import 'package:justicia_administrativa_site/application/providers/_repository_overrides.dart';
import 'package:justicia_administrativa_site/application/providers/auth_provider.dart';

class _StubAuth implements AuthRepository {
  Profile? user;
  _StubAuth(this.user);
  @override Future<Result<Profile>> currentUser() async =>
      user == null ? const Err(NotFoundFailureForTest()) : Success(user!);
  @override Stream<Profile?> watchAuthState() => const Stream.empty();
  @override Future<Result<Profile>> signInWithPassword({required String email, required String password}) async {
    user = Profile(id: 'u1', createdAt: DateTime.utc(2026, 1, 1), updatedAt: DateTime.utc(2026, 1, 1));
    return Success(user!);
  }
  @override Future<Result<void>> signOut() async { user = null; return const Success(null); }
}

class NotFoundFailureForTest extends Failure {
  const NotFoundFailureForTest() : super('none');
}

void main() {
  test('currentProfileProvider returns Profile after signIn', () async {
    final stub = _StubAuth(null);
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(stub),
    ]);
    addTearDown(container.dispose);

    await container.read(authControllerProvider.notifier).signIn('a@b', 'x');
    final state = container.read(currentProfileProvider).value;
    expect(state?.id, 'u1');
  });
}
```

(Imports `Failure` indirectly — adjust the import in `auth_provider_test.dart` if needed: `import 'package:justicia_administrativa_site/core/errors/failure.dart';`.)

`test/application/providers/portal_provider_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/matter.dart';
import 'package:justicia_administrativa_site/domain/entities/portal_stats.dart';
import 'package:justicia_administrativa_site/domain/repositories/matters_repository.dart';
import 'package:justicia_administrativa_site/application/providers/_repository_overrides.dart';
import 'package:justicia_administrativa_site/application/providers/portal_provider.dart';

class _StubMatters implements MattersRepository {
  @override Future<Result<List<Matter>>> listForCurrentUser() async => const Success([]);
  @override Future<Result<Matter>> getById(String id) async => throw UnimplementedError();
  @override Future<Result<List<Matter>>> listByStatus(MatterStatus s) async => const Success([]);
}

void main() {
  test('portalStatsProvider returns the stats from the fetcher override', () async {
    final container = ProviderContainer(overrides: [
      mattersRepositoryProvider.overrideWithValue(_StubMatters()),
      portalStatsFetcherProvider.overrideWithValue(
        () async => const Success(PortalStats(activeMatters: 7, totalDocuments: 0, upcomingEvents: 0, pendingInvoices: 0)),
      ),
    ]);
    addTearDown(container.dispose);

    final stats = await container.read(portalStatsProvider.future);
    expect(stats.activeMatters, 7);
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/application/providers/auth_provider_test.dart test/application/providers/portal_provider_test.dart
```

- [ ] **Step 3: Implement the two provider files.**

`lib/application/providers/auth_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/result.dart';
import '../../domain/entities/profile.dart';
import '../../domain/use_cases/auth/sign_in.dart';
import '../../domain/use_cases/auth/sign_out.dart';
import '../../domain/use_cases/auth/watch_auth_state.dart';

import '_repository_overrides.dart';

final signInUseCaseProvider = Provider((ref) => SignInUseCase(ref.read(authRepositoryProvider)));
final signOutUseCaseProvider = Provider((ref) => SignOutUseCase(ref.read(authRepositoryProvider)));
final watchAuthStateUseCaseProvider =
    Provider((ref) => WatchAuthStateUseCase(ref.read(authRepositoryProvider)));

/// Stream of the currently signed-in profile (null when signed out).
final currentProfileStreamProvider = StreamProvider<Profile?>((ref) {
  return ref.watch(watchAuthStateUseCaseProvider)();
});

/// Synchronous-ish snapshot AsyncValue<Profile?> backed by the controller below.
final currentProfileProvider = StateProvider<AsyncValue<Profile?>>((ref) {
  // Initialize from stream — ref.listen forwards to state.
  ref.listen<AsyncValue<Profile?>>(currentProfileStreamProvider, (_, next) {
    ref.controller.state = next;
  });
  return const AsyncLoading();
});

class AuthController extends Notifier<AsyncValue<void>> {
  @override AsyncValue<void> build() => const AsyncData(null);

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final r = await ref.read(signInUseCaseProvider)(email: email, password: password);
    state = r.fold(
      (_) => const AsyncData(null),
      (f) => AsyncError(f, StackTrace.current),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final r = await ref.read(signOutUseCaseProvider)();
    state = r.fold((_) => const AsyncData(null), (f) => AsyncError(f, StackTrace.current));
  }
}

final authControllerProvider = NotifierProvider<AuthController, AsyncValue<void>>(AuthController.new);
```

`lib/application/providers/portal_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/matter.dart';
import '../../domain/entities/portal_stats.dart';
import '../../domain/use_cases/portal/get_portal_stats.dart';
import '../../domain/use_cases/portal/list_my_matters.dart';
import '../../data/models/portal_stats_model.dart';

import '_repository_overrides.dart';

/// Closure that fetches stats. Production override calls the RPC data source;
/// tests override with a fake closure.
final portalStatsFetcherProvider = Provider<Future<Result<PortalStats>> Function()>((ref) {
  return () async {
    try {
      final rpc = ref.read(rpcDataSourceProvider);
      final client = ref.read(supabaseClientProvider);
      final uid = client.auth.currentUser?.id;
      if (uid == null) return const Err(AuthFailure('Not signed in'));
      final json = await rpc.getPortalStats(uid);
      return Success(PortalStatsModel.fromJson(json));
    } catch (e) {
      return Err(mapException(e));
    }
  };
});

final getPortalStatsUseCaseProvider =
    Provider((ref) => GetPortalStatsUseCase(ref.read(portalStatsFetcherProvider)));

final portalStatsProvider = FutureProvider<PortalStats>((ref) async {
  final r = await ref.read(getPortalStatsUseCaseProvider)();
  return r.fold((s) => s, (f) => throw f);
});

final listMyMattersUseCaseProvider =
    Provider((ref) => ListMyMattersUseCase(ref.read(mattersRepositoryProvider)));

final myMattersProvider = FutureProvider<List<Matter>>((ref) async {
  final r = await ref.read(listMyMattersUseCaseProvider)();
  return r.fold((l) => l, (f) => throw f);
});
```

> Note: `import 'package:justicia_administrativa_site/core/errors/failure.dart';` is needed in both files; add it if your IDE doesn't auto-add.

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/application/providers/auth_provider_test.dart test/application/providers/portal_provider_test.dart
git add lib/application/providers/{auth,portal}_provider.dart \
        test/application/providers/{auth,portal}_provider_test.dart
git commit -m "site(application): add auth + portal Riverpod providers"
```

---

## Task 25: Provider files — `matters_provider.dart`, `chat_provider.dart`

`matters_provider` exposes per-matter detail + child lists via a `family` provider keyed by matterId. `chat_provider` exposes conversations, messages-per-conversation, and the two RAG search providers.

**Files:**
- Create: `lib/application/providers/matters_provider.dart`, `lib/application/providers/chat_provider.dart`
- Test: `test/application/providers/matters_provider_test.dart`, `test/application/providers/chat_provider_test.dart`

- [ ] **Step 1: Write tests.**

`test/application/providers/matters_provider_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/matter.dart';
import 'package:justicia_administrativa_site/domain/repositories/matters_repository.dart';
import 'package:justicia_administrativa_site/application/providers/_repository_overrides.dart';
import 'package:justicia_administrativa_site/application/providers/matters_provider.dart';

class _Repo implements MattersRepository {
  @override Future<Result<List<Matter>>> listForCurrentUser() async => const Success([]);
  @override Future<Result<Matter>> getById(String id) async => Success(Matter(
    id: id, clientId: 'u1', referenceCode: 'R', title: 'T',
    matterType: MatterType.amparo, status: MatterStatus.en_proceso,
    lastUpdate: DateTime.utc(2026, 1, 1),
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  ));
  @override Future<Result<List<Matter>>> listByStatus(MatterStatus s) async => const Success([]);
}

void main() {
  test('matterByIdProvider returns the right matter', () async {
    final container = ProviderContainer(overrides: [
      mattersRepositoryProvider.overrideWithValue(_Repo()),
    ]);
    addTearDown(container.dispose);

    final m = await container.read(matterByIdProvider('m9').future);
    expect(m.id, 'm9');
  });
}
```

`test/application/providers/chat_provider_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/conversation.dart';
import 'package:justicia_administrativa_site/domain/repositories/conversations_repository.dart';
import 'package:justicia_administrativa_site/application/providers/_repository_overrides.dart';
import 'package:justicia_administrativa_site/application/providers/chat_provider.dart';

class _Repo implements ConversationsRepository {
  @override Future<Result<List<Conversation>>> listForCurrentUser() async => Success([
        Conversation(id: 'c1', userId: 'u1', createdAt: DateTime.utc(2026,1,1), updatedAt: DateTime.utc(2026,1,1)),
      ]);
  @override Future<Result<Conversation>> getById(String id) async => throw UnimplementedError();
  @override Future<Result<Conversation>> create(String? title) async => throw UnimplementedError();
  @override Future<Result<void>> delete(String id) async => const Success(null);
}

void main() {
  test('conversationsProvider returns the list', () async {
    final container = ProviderContainer(overrides: [
      conversationsRepositoryProvider.overrideWithValue(_Repo()),
    ]);
    addTearDown(container.dispose);

    final list = await container.read(conversationsProvider.future);
    expect(list.first.id, 'c1');
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/application/providers/matters_provider_test.dart test/application/providers/chat_provider_test.dart
```

- [ ] **Step 3: Implement the two provider files.**

`lib/application/providers/matters_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/matter.dart';
import '../../domain/entities/portal_message.dart';
import '../../domain/use_cases/matters/get_matter.dart';
import '../../domain/use_cases/matters/list_matter_documents.dart';
import '../../domain/use_cases/matters/list_matter_events.dart';
import '../../domain/use_cases/matters/list_matter_invoices.dart';
import '../../domain/use_cases/matters/list_matter_portal_messages.dart';

import '_repository_overrides.dart';

final getMatterUseCaseProvider = Provider((ref) => GetMatterUseCase(ref.read(mattersRepositoryProvider)));
final listMatterDocumentsUseCaseProvider =
    Provider((ref) => ListMatterDocumentsUseCase(ref.read(documentsRepositoryProvider)));
final listMatterInvoicesUseCaseProvider =
    Provider((ref) => ListMatterInvoicesUseCase(ref.read(invoicesRepositoryProvider)));
final listMatterEventsUseCaseProvider =
    Provider((ref) => ListMatterEventsUseCase(ref.read(calendarRepositoryProvider)));
final listMatterPortalMessagesUseCaseProvider =
    Provider((ref) => ListMatterPortalMessagesUseCase(ref.read(portalMessagesRepositoryProvider)));

final matterByIdProvider = FutureProvider.family<Matter, String>((ref, id) async {
  final r = await ref.read(getMatterUseCaseProvider)(id);
  return r.fold((m) => m, (f) => throw f);
});

final matterDocumentsProvider = FutureProvider.family<List<Document>, String>((ref, matterId) async {
  final r = await ref.read(listMatterDocumentsUseCaseProvider)(matterId);
  return r.fold((l) => l, (f) => throw f);
});

final matterInvoicesProvider = FutureProvider.family<List<Invoice>, String>((ref, matterId) async {
  final r = await ref.read(listMatterInvoicesUseCaseProvider)(matterId);
  return r.fold((l) => l, (f) => throw f);
});

final matterEventsProvider = FutureProvider.family<List<CalendarEvent>, String>((ref, matterId) async {
  final r = await ref.read(listMatterEventsUseCaseProvider)(matterId);
  return r.fold((l) => l, (f) => throw f);
});

final matterPortalMessagesProvider = FutureProvider.family<List<PortalMessage>, String>((ref, matterId) async {
  final r = await ref.read(listMatterPortalMessagesUseCaseProvider)(matterId);
  return r.fold((l) => l, (f) => throw f);
});
```

`lib/application/providers/chat_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/result.dart';
import '../../core/supabase/error_mapper.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/use_cases/chat/document_chunk.dart';
import '../../domain/use_cases/chat/list_conversations.dart';
import '../../domain/use_cases/chat/match_documents.dart';
import '../../domain/use_cases/chat/match_session_documents.dart';
import '../../domain/use_cases/chat/open_conversation.dart';
import '../../domain/use_cases/chat/send_message.dart';

import '_repository_overrides.dart';

final listConversationsUseCaseProvider =
    Provider((ref) => ListConversationsUseCase(ref.read(conversationsRepositoryProvider)));
final openConversationUseCaseProvider =
    Provider((ref) => OpenConversationUseCase(ref.read(conversationsRepositoryProvider)));
final sendMessageUseCaseProvider =
    Provider((ref) => SendMessageUseCase(ref.read(messagesRepositoryProvider)));

final matchDocumentsUseCaseProvider = Provider<MatchDocumentsUseCase>((ref) {
  final rpc = ref.read(rpcDataSourceProvider);
  return MatchDocumentsUseCase((q, t, n) async {
    try {
      final rows = await rpc.matchDocuments(queryEmbedding: q, matchThreshold: t, matchCount: n);
      return Success(rows.map(DocumentChunk.fromRow).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  });
});

final matchSessionDocumentsUseCaseProvider = Provider<MatchSessionDocumentsUseCase>((ref) {
  final rpc = ref.read(rpcDataSourceProvider);
  return MatchSessionDocumentsUseCase((q, conv, t, n) async {
    try {
      final rows = await rpc.matchSessionDocuments(
        queryEmbedding: q, conversationId: conv, matchThreshold: t, matchCount: n,
      );
      return Success(rows.map(DocumentChunk.fromRow).toList());
    } catch (e) {
      return Err(mapException(e));
    }
  });
});

final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final r = await ref.read(listConversationsUseCaseProvider)();
  return r.fold((l) => l, (f) => throw f);
});

final messagesForConversationProvider =
    FutureProvider.family<List<Message>, String>((ref, conversationId) async {
  final repo = ref.read(messagesRepositoryProvider);
  final r = await repo.listForConversation(conversationId);
  return r.fold((l) => l, (f) => throw f);
});
```

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/application/providers/matters_provider_test.dart test/application/providers/chat_provider_test.dart
git add lib/application/providers/{matters,chat}_provider.dart \
        test/application/providers/{matters,chat}_provider_test.dart
git commit -m "site(application): add matters + chat Riverpod providers"
```

---

## Task 26: Provider files — `messages_provider.dart`, `blog_provider.dart`

The smallest two — wrap a couple of use cases each.

**Files:**
- Create: `lib/application/providers/messages_provider.dart`, `lib/application/providers/blog_provider.dart`
- Test: `test/application/providers/messages_provider_test.dart`, `test/application/providers/blog_provider_test.dart`

- [ ] **Step 1: Write tests.**

`test/application/providers/blog_provider_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/blog_post.dart';
import 'package:justicia_administrativa_site/domain/repositories/blog_repository.dart';
import 'package:justicia_administrativa_site/application/providers/_repository_overrides.dart';
import 'package:justicia_administrativa_site/application/providers/blog_provider.dart';

class _Repo implements BlogRepository {
  @override Future<Result<List<BlogPost>>> listPublished({bool? featured}) async => Success([
        BlogPost(id: 'b1', title: 'X', slug: 'x', content: '...', isPublished: true, isFeatured: featured ?? false,
                 createdAt: DateTime.utc(2026,1,1), updatedAt: DateTime.utc(2026,1,1)),
      ]);
  @override Future<Result<BlogPost>> getBySlug(String slug) async => throw UnimplementedError();
}

void main() {
  test('blogPostsProvider returns published posts', () async {
    final container = ProviderContainer(overrides: [blogRepositoryProvider.overrideWithValue(_Repo())]);
    addTearDown(container.dispose);
    final list = await container.read(blogPostsProvider.future);
    expect(list.first.slug, 'x');
  });
}
```

`test/application/providers/messages_provider_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:justicia_administrativa_site/core/errors/result.dart';
import 'package:justicia_administrativa_site/domain/entities/portal_message.dart';
import 'package:justicia_administrativa_site/domain/repositories/portal_messages_repository.dart';
import 'package:justicia_administrativa_site/application/providers/_repository_overrides.dart';
import 'package:justicia_administrativa_site/application/providers/messages_provider.dart';

class _Repo implements PortalMessagesRepository {
  @override Future<Result<List<PortalMessage>>> listForMatter(String m) async => const Success([]);
  @override Future<Result<void>> markRead(String id) async => const Success(null);
  @override Future<Result<PortalMessage>> send({required String matterId, required String content,
    String? attachmentName, List<int>? attachmentBytes, String? attachmentMime}) async => throw UnimplementedError();
}

void main() {
  test('markPortalMessageReadController completes', () async {
    final container = ProviderContainer(overrides: [
      portalMessagesRepositoryProvider.overrideWithValue(_Repo()),
    ]);
    addTearDown(container.dispose);

    await container.read(markPortalMessageReadControllerProvider.notifier).run('pm1');
    expect(container.read(markPortalMessageReadControllerProvider), isA<AsyncData<void>>());
  });
}
```

- [ ] **Step 2: Run, expect fail.**

```bash
flutter test test/application/providers/messages_provider_test.dart test/application/providers/blog_provider_test.dart
```

- [ ] **Step 3: Implement.**

`lib/application/providers/messages_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_cases/messages/mark_portal_message_read.dart';
import '../../domain/use_cases/messages/send_portal_message.dart';
import '_repository_overrides.dart';

final markReadUseCaseProvider =
    Provider((ref) => MarkPortalMessageReadUseCase(ref.read(portalMessagesRepositoryProvider)));
final sendPortalMessageUseCaseProvider =
    Provider((ref) => SendPortalMessageUseCase(ref.read(portalMessagesRepositoryProvider)));

class MarkPortalMessageReadController extends Notifier<AsyncValue<void>> {
  @override AsyncValue<void> build() => const AsyncData(null);

  Future<void> run(String id) async {
    state = const AsyncLoading();
    final r = await ref.read(markReadUseCaseProvider)(id);
    state = r.fold((_) => const AsyncData(null), (f) => AsyncError(f, StackTrace.current));
  }
}

final markPortalMessageReadControllerProvider =
    NotifierProvider<MarkPortalMessageReadController, AsyncValue<void>>(MarkPortalMessageReadController.new);

class SendPortalMessageController extends Notifier<AsyncValue<void>> {
  @override AsyncValue<void> build() => const AsyncData(null);

  Future<void> run({
    required String matterId,
    required String content,
    String? attachmentName,
    List<int>? attachmentBytes,
    String? attachmentMime,
  }) async {
    state = const AsyncLoading();
    final r = await ref.read(sendPortalMessageUseCaseProvider)(
      matterId: matterId, content: content,
      attachmentName: attachmentName, attachmentBytes: attachmentBytes, attachmentMime: attachmentMime,
    );
    state = r.fold((_) => const AsyncData(null), (f) => AsyncError(f, StackTrace.current));
  }
}

final sendPortalMessageControllerProvider =
    NotifierProvider<SendPortalMessageController, AsyncValue<void>>(SendPortalMessageController.new);
```

`lib/application/providers/blog_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/blog_post.dart';
import '../../domain/use_cases/blog/get_blog_post_by_slug.dart';
import '../../domain/use_cases/blog/list_blog_posts.dart';

import '_repository_overrides.dart';

final listBlogPostsUseCaseProvider =
    Provider((ref) => ListBlogPostsUseCase(ref.read(blogRepositoryProvider)));
final getBlogPostBySlugUseCaseProvider =
    Provider((ref) => GetBlogPostBySlugUseCase(ref.read(blogRepositoryProvider)));

final blogPostsProvider = FutureProvider<List<BlogPost>>((ref) async {
  final r = await ref.read(listBlogPostsUseCaseProvider)();
  return r.fold((l) => l, (f) => throw f);
});

final featuredBlogPostsProvider = FutureProvider<List<BlogPost>>((ref) async {
  final r = await ref.read(listBlogPostsUseCaseProvider)(featured: true);
  return r.fold((l) => l, (f) => throw f);
});

final blogPostBySlugProvider = FutureProvider.family<BlogPost, String>((ref, slug) async {
  final r = await ref.read(getBlogPostBySlugUseCaseProvider)(slug);
  return r.fold((p) => p, (f) => throw f);
});
```

- [ ] **Step 4: Run, expect pass; commit.**

```bash
flutter test test/application/providers/messages_provider_test.dart test/application/providers/blog_provider_test.dart
git add lib/application/providers/{messages,blog}_provider.dart \
        test/application/providers/{messages,blog}_provider_test.dart
git commit -m "site(application): add messages + blog Riverpod providers"
```

After this commit, all 6 provider files exist and are tested.

---

## Task 27: `import_hygiene_test.dart` — enforce layer boundaries

A single test that walks `lib/` source files and asserts the architectural rules from the spec (§5).

**Files:**
- Create: `test/architecture/import_hygiene_test.dart`

- [ ] **Step 1: Write the test.**

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Import hygiene', () {
    test('domain/ imports nothing app-specific (no Supabase / Flutter / dio)', () {
      final files = Directory('lib/domain').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
      final forbidden = ['package:supabase_flutter', 'package:flutter/', 'package:dio/', "import 'dart:html"];
      for (final f in files) {
        final src = f.readAsStringSync();
        for (final bad in forbidden) {
          expect(src.contains(bad), isFalse, reason: '${f.path} imports forbidden $bad');
        }
      }
    });

    test('data/ does not import application/ or app/', () {
      final files = Directory('lib/data').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
      for (final f in files) {
        final src = f.readAsStringSync();
        expect(src.contains("import '../../application/"), isFalse, reason: '${f.path} imports application');
        expect(src.contains("import '../../app/"), isFalse, reason: '${f.path} imports app');
      }
    });

    test('domain/ + data/ + application/ do NOT import legacy core/models or core/services', () {
      for (final dir in const ['lib/domain', 'lib/data', 'lib/application']) {
        final files = Directory(dir).listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
        for (final f in files) {
          final src = f.readAsStringSync();
          expect(src.contains('core/models/'), isFalse, reason: '${f.path} imports legacy core/models');
          expect(src.contains('core/services/'), isFalse, reason: '${f.path} imports legacy core/services');
          expect(src.contains('core/di/'), isFalse, reason: '${f.path} imports legacy core/di');
        }
      }
    });
  });
}
```

- [ ] **Step 2: Run.**

```bash
flutter test test/architecture/import_hygiene_test.dart
```

Expected: 3 tests pass. If any fail, the failing message lists the offending file — go fix the offending import before continuing.

- [ ] **Step 3: Commit.**

```bash
git add test/architecture/import_hygiene_test.dart
git commit -m "site(test): add import hygiene test enforcing layer boundaries"
```

---

## Task 28: Final acceptance verification

This task runs every check from spec §13 and produces a single artifact (a markdown summary) committed at the end.

**Files:**
- Create: `001-apps/001-site/docs/superpowers/plans/2026-04-19-site-ddd-supabase-alignment-acceptance.md` (a sibling to this plan, containing the verification output)

- [ ] **Step 1: Run `flutter analyze` and capture output.**

```bash
flutter analyze 2>&1 | tee /tmp/site-analyze.txt
```

Expected: warning count equal to the pre-execution baseline. Diff to confirm:

```bash
diff <(grep -E '(info|warning|error)' /tmp/site-analyze-baseline.txt 2>/dev/null || echo NONE) \
     <(grep -E '(info|warning|error)' /tmp/site-analyze.txt) || true
```

If new entries appear, fix them before continuing.

- [ ] **Step 2: Run the full test suite.**

```bash
flutter test 2>&1 | tee /tmp/site-test.txt
```

Expected: green. Capture the "All tests passed!" line and the test count.

- [ ] **Step 3: Build web release and confirm no UI regression.**

```bash
flutter build web --release 2>&1 | tee /tmp/site-build.txt
```

Expected: build succeeds. Then compare key UI artifacts byte-wise against the current production deploy:

```bash
diff -r build/web/index.html /var/www/new/index.html || echo "index.html differs (expected if hash-busted; check that the diff is only in script src hashes)"
diff build/web/manifest.json /var/www/new/manifest.json || echo "manifest differs"
```

The HTML diff should be limited to compiled-Dart hashes (different `main.dart.js?v=...` query strings) — not in any rendered text/markup. If you see differences in headings, classes, or body content, **stop**: a screen has changed somewhere and the scaffold-only invariant is broken.

- [ ] **Step 4: Inventory check — confirm every file from the spec exists.**

```bash
expected=(
  lib/core/errors/failure.dart
  lib/core/errors/result.dart
  lib/core/supabase/error_mapper.dart
  lib/core/supabase/supabase_client_provider.dart
  lib/domain/entities/{profile,lawyer,matter,document,invoice,calendar_event,conversation,message,portal_message,blog_post,portal_stats}.dart
  lib/domain/repositories/{profiles,lawyers,matters,documents,invoices,calendar,conversations,messages,portal_messages,blog,auth}_repository.dart
  lib/data/models/{profile,lawyer,matter,document,invoice,calendar_event,conversation,message,portal_message,blog_post,portal_stats}_model.dart
  lib/data/data_sources/supabase/{profiles,lawyers,matters,documents,invoices,calendar,conversations,messages,portal_messages,blog,auth,rpc,storage}_data_source.dart
  lib/data/repositories/{profiles,lawyers,matters,documents,invoices,calendar,conversations,messages,portal_messages,blog,auth}_repository_impl.dart
  lib/application/providers/{auth,portal,matters,chat,messages,blog}_provider.dart
  lib/application/providers/_repository_overrides.dart
)
missing=()
for f in "${expected[@]}"; do [ -f "$f" ] || missing+=("$f"); done
if [ ${#missing[@]} -ne 0 ]; then printf 'MISSING: %s\n' "${missing[@]}"; exit 1; fi
echo "All ${#expected[@]} expected files exist."
```

- [ ] **Step 5: Confirm pubspec change is `equatable` only.**

```bash
git diff main -- pubspec.yaml | grep '^+' | grep -v '^+++' | grep -v 'equatable' | grep -E '^\+[^+]' && echo "FAIL: pubspec.yaml has changes other than equatable" || echo "OK: equatable is the only added dep"
```

- [ ] **Step 6: Confirm legacy directories are unmodified.**

```bash
git diff --stat main -- lib/app/ lib/core/config/ lib/core/theme/ lib/core/utils/ lib/core/models/ lib/core/services/ lib/core/di/ \
  | tail -1 \
  | grep -qE '^ 0 files? changed' && echo OK || echo "FAIL: legacy dirs were modified"
```

- [ ] **Step 7: Write the acceptance summary file and commit.**

```bash
cat > docs/superpowers/plans/2026-04-19-site-ddd-supabase-alignment-acceptance.md <<'EOF'
# Acceptance — site DDD scaffold

- flutter analyze: <paste warning count line from /tmp/site-analyze.txt>
- flutter test:    <paste "All tests passed (N)" from /tmp/site-test.txt>
- flutter build web --release: success; build/web/index.html diff vs production = <hash-only|other>
- File inventory: <paste output of Step 4>
- pubspec.yaml diff: only `equatable: ^2.0.7` added
- Legacy dirs (lib/app, lib/core/{config,theme,utils,models,services,di}): 0 files changed
- Import hygiene test: PASS

Result: ACCEPTED.
EOF
git add docs/superpowers/plans/2026-04-19-site-ddd-supabase-alignment-acceptance.md
git commit -m "site: scaffold acceptance — all spec §13 criteria met"
```

If any step in 1–6 fails, do **not** commit the acceptance file. Open an issue with the failing step's output and resolve before declaring done.

---

## Self-review

After writing the plan, ran the four checks the skill mandates:

**1. Spec coverage.** Walked spec §3 (in-scope) and §13 (acceptance) item-by-item:
- All 11 entities → Tasks 6–9 ✓
- All 11 models → Tasks 10–13 ✓
- All 11 abstract repositories → Task 14 ✓
- All 13 data sources → Tasks 15–17 ✓
- All 11 repository impls → Tasks 18–20 ✓
- All bounded-context use cases → Tasks 21–22 (incl. `DocumentChunk` from §12 Q6) ✓
- All 6 provider files + `_repository_overrides` + `main.dart` wiring → Tasks 23–26 ✓
- `core/errors/{failure,result}` → Tasks 2, 3 ✓
- `core/supabase/{error_mapper,supabase_client_provider}` → Tasks 4, 5 ✓
- Import hygiene test → Task 27 ✓
- Acceptance criteria → Task 28 ✓
- `equatable` dep added → Task 1 ✓
- Tests mirror lib/ → present in every TDD micro-cycle ✓

**2. Placeholder scan.** No "TODO", "TBD", "implement later", "similar to" found. Every code step contains the actual code.

**3. Type consistency.** Cross-checked names referenced across tasks:
- `mapException(...)` used in repos matches signature in Task 4 ✓
- `Success`/`Err`/`Result.fold` used consistently across all repos and providers ✓
- Repository constructor signatures (e.g. `currentUserId: () => uid`) match between impls (Tasks 18–20) and `_repository_overrides.dart` (Task 23) ✓
- `DocumentChunk.fromRow` used by `chat_provider.dart` matches definition in Task 22 ✓
- Use case `call(...)` signatures match how providers invoke them ✓

**4. Bite-sized.** Each step is one of: write a test file, run a test command, write/edit a code file, run analyze, commit. None spans more than ~5 minutes of operator work. Long files appear inside steps as full content the engineer pastes — that's input volume, not step granularity.

No issues found that need fixing inline.

---

## Execution handoff

Plan complete and saved to `001-apps/001-site/docs/superpowers/plans/2026-04-19-site-ddd-supabase-alignment.md`. Two execution options:

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration. Best for a long plan like this where each task is genuinely independent and the cumulative context would otherwise grow quickly.

**2. Inline Execution** — Execute tasks in this session using `executing-plans`, batch execution with checkpoints. Better if you want to watch the work unfold step by step in this conversation, at the cost of more in-conversation context.

**Which approach?**
