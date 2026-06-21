import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/domains/contact/application/contact_inquiry_repository.dart';
import 'package:justicia_administrativa_site/domains/contact/application/submit_contact_inquiry_use_case.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/contact_inquiry.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/contact_message.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/email_address.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/person_name.dart';

// ---------------------------------------------------------------------------
// Fake repository for testing — holds injected results.
// ---------------------------------------------------------------------------
class _FakeContactInquiryRepository implements ContactInquiryRepository {
  Result<ContactInquiry>? _nextResult;

  void willReturn(Result<ContactInquiry> result) => _nextResult = result;

  @override
  Future<Result<ContactInquiry>> submit(ContactInquiry inquiry) async {
    return _nextResult ?? const Ok(_sampleInquiry);
  }
}

// ---------------------------------------------------------------------------
// Shared test fixture helpers.
// ---------------------------------------------------------------------------
const _sampleInquiry = ContactInquiry(
  name: PersonName.fromTrusted('María López'),
  email: EmailAddress.fromTrusted('maria@example.com'),
  message: ContactMessage.fromTrusted('Necesito asesoría legal.'),
  isUrgent: false,
  contactMethod: 'email',
);

void main() {
  late _FakeContactInquiryRepository fakeRepo;
  late SubmitContactInquiryUseCase useCase;

  setUp(() {
    fakeRepo = _FakeContactInquiryRepository();
    useCase = SubmitContactInquiryUseCase(fakeRepo);
  });

  group('SubmitContactInquiryUseCase', () {
    test('delegates to repository and returns Ok when repo succeeds', () async {
      fakeRepo.willReturn(const Ok(_sampleInquiry));

      final result = await useCase(_sampleInquiry);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, _sampleInquiry);
    });

    test('returns Err(ServerFailure) when repo returns Err', () async {
      fakeRepo.willReturn(const Err(ServerFailure()));

      final result = await useCase(_sampleInquiry);

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('Expected Err'),
        (f) => expect(f, isA<ServerFailure>()),
      );
    });

    test(
      'returns Err(NetworkFailure) when repo returns network failure',
      () async {
        fakeRepo.willReturn(const Err(NetworkFailure()));

        final result = await useCase(_sampleInquiry);

        expect(result.isErr, isTrue);
        result.fold(
          (_) => fail('Expected Err'),
          (f) => expect(f, isA<NetworkFailure>()),
        );
      },
    );
  });
}
