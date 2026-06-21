import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/unit.dart';
import 'package:justicia_administrativa_site/core/models/document.dart';
import 'package:justicia_administrativa_site/domains/documents/application/documents_repository.dart';
import 'package:justicia_administrativa_site/domains/documents/application/load_documents_use_case.dart';
import 'package:justicia_administrativa_site/domains/documents/application/upload_document_use_case.dart';

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class _FakeDocumentsRepo implements DocumentsRepository {
  final Result<List<Document>> loadResult;
  final Result<Unit> uploadResult;

  const _FakeDocumentsRepo({
    required this.loadResult,
    Result<Unit>? uploadResult,
  }) : uploadResult = uploadResult ?? const Ok(unit);

  @override
  Future<Result<List<Document>>> documents({String? matterId}) async =>
      loadResult;

  @override
  Future<Result<Unit>> upload({
    required PlatformFile file,
    DocumentCategory category = DocumentCategory.otro,
    String? matterId,
  }) async => uploadResult;
}

// ---------------------------------------------------------------------------
// Helper builders
// ---------------------------------------------------------------------------

Document _document(String id) => Document(
  id: id,
  clientId: 'client-1',
  name: 'documento_$id.pdf',
  category: DocumentCategory.otro,
  createdAt: DateTime(2025, 1, 1),
);

PlatformFile _platformFile(String name) => PlatformFile(
  name: name,
  size: 1024,
  bytes: Uint8List.fromList([0, 1, 2, 3]),
);

void main() {
  group('LoadDocumentsUseCase', () {
    test('returns Ok with documents on repository success', () async {
      final docs = [_document('d1'), _document('d2')];
      final useCase = LoadDocumentsUseCase(
        _FakeDocumentsRepo(loadResult: Ok(docs)),
      );

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, hasLength(2));
      expect(result.valueOrNull!.first.id, equals('d1'));
    });

    test('returns Ok with empty list when repository returns empty', () async {
      final useCase = LoadDocumentsUseCase(
        _FakeDocumentsRepo(loadResult: Ok(<Document>[])),
      );

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    test('returns Err when repository returns failure', () async {
      const failure = NetworkFailure();
      final useCase = LoadDocumentsUseCase(
        _FakeDocumentsRepo(loadResult: Err<List<Document>>(failure)),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<NetworkFailure>()),
      );
    });
  });

  group('UploadDocumentUseCase', () {
    test('returns Ok(unit) on repository success', () async {
      final useCase = UploadDocumentUseCase(
        _FakeDocumentsRepo(
          loadResult: Ok(<Document>[]),
          uploadResult: const Ok(unit),
        ),
      );

      final result = await useCase(file: _platformFile('test.pdf'));

      expect(result.isOk, isTrue);
    });

    test('returns Err when repository upload fails', () async {
      const failure = ServerFailure(message: 'Error de almacenamiento.');
      final useCase = UploadDocumentUseCase(
        _FakeDocumentsRepo(
          loadResult: Ok(<Document>[]),
          uploadResult: Err<Unit>(failure),
        ),
      );

      final result = await useCase(file: _platformFile('test.pdf'));

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<ServerFailure>()),
      );
    });

    test('passes category and matterId to repository', () async {
      String? capturedMatterId;
      DocumentCategory? capturedCategory;

      final repo = _CapturingRepo(
        onUpload: (file, category, matterId) {
          capturedCategory = category;
          capturedMatterId = matterId;
        },
      );
      final useCase = UploadDocumentUseCase(repo);

      await useCase(
        file: _platformFile('contrato.pdf'),
        category: DocumentCategory.contrato,
        matterId: 'matter-99',
      );

      expect(capturedCategory, equals(DocumentCategory.contrato));
      expect(capturedMatterId, equals('matter-99'));
    });
  });
}

class _CapturingRepo implements DocumentsRepository {
  final void Function(
    PlatformFile file,
    DocumentCategory category,
    String? matterId,
  )
  onUpload;

  const _CapturingRepo({required this.onUpload});

  @override
  Future<Result<List<Document>>> documents({String? matterId}) async =>
      Ok(<Document>[]);

  @override
  Future<Result<Unit>> upload({
    required PlatformFile file,
    DocumentCategory category = DocumentCategory.otro,
    String? matterId,
  }) async {
    onUpload(file, category, matterId);
    return const Ok(unit);
  }
}
