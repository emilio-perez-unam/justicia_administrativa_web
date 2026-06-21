import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/domains/contact/actors/contact_form_actor.dart';
import 'package:justicia_administrativa_site/domains/contact/application/submit_contact_inquiry_use_case.dart';
import 'package:justicia_administrativa_site/domains/contact/application/contact_inquiry_repository.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/contact_inquiry.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/contact_message.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/email_address.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/person_name.dart';

// ---------------------------------------------------------------------------
// Controllable fake repository for actor tests.
// ---------------------------------------------------------------------------
class _ControllableRepo implements ContactInquiryRepository {
  late Future<Result<ContactInquiry>> Function(ContactInquiry) _handler;

  void willReturn(Result<ContactInquiry> result) {
    _handler = (_) async => result;
  }

  void willDelay(Result<ContactInquiry> result, Duration delay) {
    _handler = (_) async {
      await Future.delayed(delay);
      return result;
    };
  }

  @override
  Future<Result<ContactInquiry>> submit(ContactInquiry inquiry) =>
      _handler(inquiry);
}

// ---------------------------------------------------------------------------
// Sample fixture.
// ---------------------------------------------------------------------------
const _inquiry = ContactInquiry(
  name: PersonName.fromTrusted('Carlos Ruiz'),
  email: EmailAddress.fromTrusted('carlos@example.com'),
  message: ContactMessage.fromTrusted('Consulta urgente sobre impuesto.'),
  isUrgent: true,
  contactMethod: 'phone',
);

void main() {
  late _ControllableRepo repo;
  late SubmitContactInquiryUseCase useCase;
  late ContactFormActor actor;

  setUp(() {
    repo = _ControllableRepo();
    useCase = SubmitContactInquiryUseCase(repo);
    actor = ContactFormActor(useCase);
  });

  tearDown(() => actor.dispose());

  group('ContactFormActor — initial state', () {
    test('starts in idle status', () {
      expect(actor.status, ContactFormStatus.idle);
    });

    test('failure is null initially', () {
      expect(actor.failure, isNull);
    });
  });

  group('ContactFormActor — successful submission', () {
    test('transitions idle → submitting → success', () async {
      repo.willReturn(const Ok(_inquiry));

      final statuses = <ContactFormStatus>[];
      actor.addListener(() => statuses.add(actor.status));

      await actor.submit(_inquiry);

      // The actor notifies at least once for submitting and once for success.
      expect(
        statuses,
        containsAllInOrder([
          ContactFormStatus.submitting,
          ContactFormStatus.success,
        ]),
      );
      expect(actor.status, ContactFormStatus.success);
    });

    test('failure is null after success', () async {
      repo.willReturn(const Ok(_inquiry));
      await actor.submit(_inquiry);
      expect(actor.failure, isNull);
    });
  });

  group('ContactFormActor — failed submission', () {
    test('transitions idle → submitting → error', () async {
      repo.willReturn(const Err(ServerFailure()));

      final statuses = <ContactFormStatus>[];
      actor.addListener(() => statuses.add(actor.status));

      await actor.submit(_inquiry);

      expect(
        statuses,
        containsAllInOrder([
          ContactFormStatus.submitting,
          ContactFormStatus.error,
        ]),
      );
      expect(actor.status, ContactFormStatus.error);
    });

    test('failure is set after error', () async {
      repo.willReturn(const Err(ServerFailure()));
      await actor.submit(_inquiry);
      expect(actor.failure, isA<ServerFailure>());
    });

    test(
      'failure carries network failure when repo returns NetworkFailure',
      () async {
        repo.willReturn(const Err(NetworkFailure()));
        await actor.submit(_inquiry);
        expect(actor.failure, isA<NetworkFailure>());
      },
    );
  });

  group('ContactFormActor — reset', () {
    test('reset returns to idle and clears failure', () async {
      repo.willReturn(const Err(ServerFailure()));
      await actor.submit(_inquiry);

      actor.reset();

      expect(actor.status, ContactFormStatus.idle);
      expect(actor.failure, isNull);
    });
  });
}
