import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/unit.dart';
import 'package:justicia_administrativa_site/domains/blog/application/blog_admin_repository.dart';
import 'package:justicia_administrativa_site/domains/blog/application/create_post_use_case.dart';
import 'package:justicia_administrativa_site/domains/blog/application/delete_post_use_case.dart';
import 'package:justicia_administrativa_site/domains/blog/application/load_all_posts_use_case.dart';
import 'package:justicia_administrativa_site/domains/blog/application/set_featured_use_case.dart';
import 'package:justicia_administrativa_site/domains/blog/application/set_published_use_case.dart';
import 'package:justicia_administrativa_site/domains/blog/application/update_post_use_case.dart';
import 'package:justicia_administrativa_site/domains/blog/domain/blog_post.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

BlogPost _post(String id) => BlogPost(
  id: id,
  title: 'Post $id',
  slug: 'post-$id',
  excerpt: 'Excerpt $id',
  content: 'Content',
  category: 'Derecho',
  tags: const ['tag1'],
  imageUrl: '',
  authorName: 'Autor',
  authorRole: 'Abogado',
  authorBio: '',
  authorImageUrl: '',
  readMinutes: 2,
  viewsCount: 0,
  commentsCount: 0,
  isFeatured: false,
  isPublished: false,
  publishedAt: null,
  createdAt: DateTime(2025, 1, 1),
  updatedAt: DateTime(2025, 1, 1),
  createdBy: 'user-1',
);

BlogPostDraftInput _draft() => const BlogPostDraftInput(
  title: 'Test',
  slug: 'test',
  excerpt: 'Excerpt',
  content: 'Body',
  category: 'Derecho',
  tags: ['tag'],
  imageUrl: '',
  authorName: 'Autor',
  authorRole: 'Abogado',
  authorBio: '',
  authorImageUrl: '',
  isFeatured: false,
  isPublished: false,
);

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class _FakeRepo implements BlogAdminRepository {
  // Configurable responses
  Result<List<BlogPost>>? getAllPostsResult;
  Result<BlogPost>? createPostResult;
  Result<BlogPost>? updatePostResult;
  Result<Unit>? deletePostResult;
  Result<BlogPost>? setPublishedResult;
  Result<BlogPost>? setFeaturedResult;

  // Captured args
  BlogPostDraftInput? capturedCreateInput;
  String? capturedDeleteId;
  String? capturedUpdateId;
  String? capturedSetPublishedId;
  bool? capturedIsPublished;
  String? capturedSetFeaturedId;
  bool? capturedIsFeatured;

  _FakeRepo({
    this.getAllPostsResult,
    this.createPostResult,
    this.updatePostResult,
    this.deletePostResult,
    this.setPublishedResult,
    this.setFeaturedResult,
  });

  @override
  Future<Result<List<BlogPost>>> getAllPosts() async =>
      getAllPostsResult ?? Ok([]);

  @override
  Future<Result<BlogPost>> createPost(BlogPostDraftInput input) async {
    capturedCreateInput = input;
    return createPostResult ?? Ok(_post('new'));
  }

  @override
  Future<Result<BlogPost>> updatePost({
    required String id,
    required BlogPostDraftInput input,
    DateTime? previousPublishedAt,
  }) async {
    capturedUpdateId = id;
    return updatePostResult ?? Ok(_post(id));
  }

  @override
  Future<Result<Unit>> deletePost(String id) async {
    capturedDeleteId = id;
    return deletePostResult ?? Ok(unit);
  }

  @override
  Future<Result<BlogPost>> setPublished({
    required String id,
    required bool isPublished,
  }) async {
    capturedSetPublishedId = id;
    capturedIsPublished = isPublished;
    return setPublishedResult ?? Ok(_post(id));
  }

  @override
  Future<Result<BlogPost>> setFeatured({
    required String id,
    required bool isFeatured,
  }) async {
    capturedSetFeaturedId = id;
    capturedIsFeatured = isFeatured;
    return setFeaturedResult ?? Ok(_post(id));
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ── LoadAllPostsUseCase ──────────────────────────────────────────────────
  group('LoadAllPostsUseCase', () {
    test('returns Ok with list from repository', () async {
      final posts = [_post('1'), _post('2')];
      final useCase = LoadAllPostsUseCase(
        _FakeRepo(getAllPostsResult: Ok(posts)),
      );

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, hasLength(2));
    });

    test('returns Ok with empty list', () async {
      final useCase = LoadAllPostsUseCase(_FakeRepo(getAllPostsResult: Ok([])));

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    test('returns Err when repository fails', () async {
      const failure = NetworkFailure();
      final useCase = LoadAllPostsUseCase(
        _FakeRepo(getAllPostsResult: Err<List<BlogPost>>(failure)),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<NetworkFailure>()),
      );
    });
  });

  // ── CreatePostUseCase ────────────────────────────────────────────────────
  group('CreatePostUseCase', () {
    test('delegates draft input and returns created post', () async {
      final repo = _FakeRepo(createPostResult: Ok(_post('new')));
      final useCase = CreatePostUseCase(repo);
      final draft = _draft();

      final result = await useCase(draft);

      expect(result.isOk, isTrue);
      expect(repo.capturedCreateInput, same(draft));
    });

    test('returns Err on failure', () async {
      const failure = AuthFailure();
      final useCase = CreatePostUseCase(
        _FakeRepo(createPostResult: Err<BlogPost>(failure)),
      );

      final result = await useCase(_draft());

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<AuthFailure>()),
      );
    });
  });

  // ── UpdatePostUseCase ────────────────────────────────────────────────────
  group('UpdatePostUseCase', () {
    test('delegates id and returns updated post', () async {
      final repo = _FakeRepo(updatePostResult: Ok(_post('42')));
      final useCase = UpdatePostUseCase(repo);

      final result = await useCase(id: '42', input: _draft());

      expect(result.isOk, isTrue);
      expect(repo.capturedUpdateId, equals('42'));
    });

    test('returns Err on server failure', () async {
      const failure = ServerFailure();
      final useCase = UpdatePostUseCase(
        _FakeRepo(updatePostResult: Err<BlogPost>(failure)),
      );

      final result = await useCase(id: '42', input: _draft());

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<ServerFailure>()),
      );
    });
  });

  // ── DeletePostUseCase ────────────────────────────────────────────────────
  group('DeletePostUseCase', () {
    test('delegates id to repository', () async {
      final repo = _FakeRepo(deletePostResult: Ok(unit));
      final useCase = DeletePostUseCase(repo);

      await useCase('post-99');

      expect(repo.capturedDeleteId, equals('post-99'));
    });

    test('returns Ok(unit) on success', () async {
      final result = await DeletePostUseCase(_FakeRepo())('post-1');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isA<Unit>());
    });

    test('returns Err when repository fails', () async {
      const failure = ServerFailure();
      final result = await DeletePostUseCase(
        _FakeRepo(deletePostResult: Err<Unit>(failure)),
      )('post-1');

      expect(result.isErr, isTrue);
    });
  });

  // ── SetPublishedUseCase ──────────────────────────────────────────────────
  group('SetPublishedUseCase', () {
    test('passes id and isPublished flag to repository', () async {
      final repo = _FakeRepo(setPublishedResult: Ok(_post('5')));
      final useCase = SetPublishedUseCase(repo);

      await useCase(id: '5', isPublished: true);

      expect(repo.capturedSetPublishedId, equals('5'));
      expect(repo.capturedIsPublished, isTrue);
    });

    test('returns Err when repository fails', () async {
      const failure = NetworkFailure();
      final result = await SetPublishedUseCase(
        _FakeRepo(setPublishedResult: Err<BlogPost>(failure)),
      )(id: '5', isPublished: false);

      expect(result.isErr, isTrue);
    });
  });

  // ── SetFeaturedUseCase ───────────────────────────────────────────────────
  group('SetFeaturedUseCase', () {
    test('passes id and isFeatured flag to repository', () async {
      final repo = _FakeRepo(setFeaturedResult: Ok(_post('7')));
      final useCase = SetFeaturedUseCase(repo);

      await useCase(id: '7', isFeatured: true);

      expect(repo.capturedSetFeaturedId, equals('7'));
      expect(repo.capturedIsFeatured, isTrue);
    });

    test('returns Ok with updated post on success', () async {
      final result = await SetFeaturedUseCase(
        _FakeRepo(setFeaturedResult: Ok(_post('7'))),
      )(id: '7', isFeatured: false);

      expect(result.isOk, isTrue);
    });

    test('returns Err when repository fails', () async {
      const failure = ServerFailure(message: 'DB error');
      final result = await SetFeaturedUseCase(
        _FakeRepo(setFeaturedResult: Err<BlogPost>(failure)),
      )(id: '7', isFeatured: true);

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f.message, equals('DB error')),
      );
    });
  });
}
