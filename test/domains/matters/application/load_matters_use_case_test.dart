import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/models/matter.dart';
import 'package:justicia_administrativa_site/domains/matters/application/matters_repository.dart';
import 'package:justicia_administrativa_site/domains/matters/application/load_matters_use_case.dart';

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class _FakeMattersRepo implements MattersRepository {
  final Result<List<Matter>> result;

  const _FakeMattersRepo(this.result);

  @override
  Future<Result<List<Matter>>> matters() async => result;
}

// ---------------------------------------------------------------------------
// Helper builders
// ---------------------------------------------------------------------------

Matter _matter(String id) => Matter(
  id: id,
  clientId: 'client-1',
  referenceCode: 'EXP-$id',
  title: 'Asunto $id',
  matterType: MatterType.consulta,
  status: MatterStatus.enProceso,
  lastUpdate: DateTime(2025, 1, 1),
  createdAt: DateTime(2025, 1, 1),
);

void main() {
  group('LoadMattersUseCase', () {
    test('returns Ok with matters on repository success', () async {
      final matters = [_matter('m1'), _matter('m2')];
      final useCase = LoadMattersUseCase(_FakeMattersRepo(Ok(matters)));

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, hasLength(2));
      expect(result.valueOrNull!.first.id, equals('m1'));
    });

    test('returns Ok with empty list when repository returns empty', () async {
      final useCase = LoadMattersUseCase(_FakeMattersRepo(Ok(<Matter>[])));

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    test('returns Err when repository returns NetworkFailure', () async {
      const failure = NetworkFailure();
      final useCase = LoadMattersUseCase(
        _FakeMattersRepo(Err<List<Matter>>(failure)),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<NetworkFailure>()),
      );
    });

    test('returns Err when repository returns AuthFailure', () async {
      const failure = AuthFailure();
      final useCase = LoadMattersUseCase(
        _FakeMattersRepo(Err<List<Matter>>(failure)),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<AuthFailure>()),
      );
    });
  });
}
