// Actor + use-case integration test for the contact form.
//
// NOTE: The contact form widget (_ContactFormSection) is declared as a
// private `part of` class inside contact.dart.  Flutter's test runner
// cannot directly instantiate private classes from other libraries.
// Rather than wrapping every private type in a thin test shim, we verify the
// full submission lifecycle through the public actor / use-case API —
// which is the exact code path the widget drives at runtime.
//
// Comprehensive widget-level smoke tests live in the actor tests at
// test/domains/contact/actors/contact_form_actor_test.dart.
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/domains/contact/actors/contact_form_actor.dart';
import 'package:justicia_administrativa_site/domains/contact/application/contact_inquiry_repository.dart';
import 'package:justicia_administrativa_site/domains/contact/application/submit_contact_inquiry_use_case.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/contact_inquiry.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/contact_message.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/email_address.dart';
import 'package:justicia_administrativa_site/domains/contact/domain/value_objects/person_name.dart';

// ---------------------------------------------------------------------------
// Fake repository for integration tests.
// ---------------------------------------------------------------------------
class _FakeRepo implements ContactInquiryRepository {
  late Result<ContactInquiry> _result;

  void willReturn(Result<ContactInquiry> r) => _result = r;

  @override
  Future<Result<ContactInquiry>> submit(ContactInquiry inquiry) async =>
      _result;
}

// ---------------------------------------------------------------------------
// Shared fixture.
// ---------------------------------------------------------------------------
ContactInquiry _buildInquiry({
  String name = 'Rosa Martínez',
  String email = 'rosa@example.com',
  String message = 'Requiero asesoría sobre contrato laboral.',
  bool isUrgent = false,
  String contactMethod = 'email',
  String? consultationType = 'Servicios Legales',
  String? preferredOffice = 'CDMX',
  String? phone,
  String? company,
}) {
  return ContactInquiry(
    name: PersonName.fromTrusted(name),
    email: EmailAddress.fromTrusted(email),
    message: ContactMessage.fromTrusted(message),
    isUrgent: isUrgent,
    contactMethod: contactMethod,
    consultationType: consultationType,
    preferredOffice: preferredOffice,
    phone: phone,
    company: company,
  );
}

void main() {
  late _FakeRepo repo;
  late SubmitContactInquiryUseCase useCase;
  late ContactFormActor actor;

  setUp(() {
    repo = _FakeRepo();
    useCase = SubmitContactInquiryUseCase(repo);
    actor = ContactFormActor(useCase);
  });

  tearDown(() => actor.dispose());

  // ─── toInsert() ───────────────────────────────────────────────────────────

  group('ContactInquiry.toInsert()', () {
    test('includes all required fields with snake_case keys', () {
      final inquiry = _buildInquiry();
      final map = inquiry.toInsert();

      expect(map['name'], 'Rosa Martínez');
      expect(map['email'], 'rosa@example.com');
      expect(map['message'], 'Requiero asesoría sobre contrato laboral.');
      expect(map['is_urgent'], isFalse);
      expect(map['contact_method'], 'email');
      expect(map['consultation_type'], 'Servicios Legales');
      expect(map['preferred_office'], 'CDMX');
    });

    test('omits null optional fields', () {
      final inquiry = _buildInquiry(
        phone: null,
        company: null,
        consultationType: null,
        preferredOffice: null,
      );
      final map = inquiry.toInsert();

      expect(map.containsKey('phone'), isFalse);
      expect(map.containsKey('company'), isFalse);
      expect(map.containsKey('consultation_type'), isFalse);
      expect(map.containsKey('preferred_office'), isFalse);
    });

    test('includes phone and company when provided', () {
      final inquiry = _buildInquiry(phone: '+52 55 1234 5678', company: 'UNAM');
      final map = inquiry.toInsert();

      expect(map['phone'], '+52 55 1234 5678');
      expect(map['company'], 'UNAM');
    });

    test('is_urgent is true when flagged', () {
      final inquiry = _buildInquiry(isUrgent: true);
      expect(inquiry.toInsert()['is_urgent'], isTrue);
    });

    test('contact_method reflects phone selection', () {
      final inquiry = _buildInquiry(contactMethod: 'phone');
      expect(inquiry.toInsert()['contact_method'], 'phone');
    });
  });

  // ─── Full submission lifecycle ────────────────────────────────────────────

  group('ContactFormActor full submission lifecycle', () {
    test('success: idle → submitting → success, failure null', () async {
      final inquiry = _buildInquiry();
      repo.willReturn(Ok(inquiry));

      final statuses = <ContactFormStatus>[];
      actor.addListener(() => statuses.add(actor.status));

      await actor.submit(inquiry);

      expect(
        statuses,
        containsAllInOrder([
          ContactFormStatus.submitting,
          ContactFormStatus.success,
        ]),
      );
      expect(actor.failure, isNull);
    });

    test('error: idle → submitting → error, failure is set', () async {
      final inquiry = _buildInquiry();
      repo.willReturn(const Err(ServerFailure()));

      await actor.submit(inquiry);

      expect(actor.status, ContactFormStatus.error);
      expect(actor.failure, isA<ServerFailure>());
    });

    test('reset after error restores idle with null failure', () async {
      final inquiry = _buildInquiry();
      repo.willReturn(const Err(NetworkFailure()));
      await actor.submit(inquiry);

      actor.reset();

      expect(actor.status, ContactFormStatus.idle);
      expect(actor.failure, isNull);
    });

    test('second successful submit after error returns to success', () async {
      final inquiry = _buildInquiry();

      // First attempt fails.
      repo.willReturn(const Err(ServerFailure()));
      await actor.submit(inquiry);
      expect(actor.status, ContactFormStatus.error);

      // Second attempt succeeds.
      repo.willReturn(Ok(inquiry));
      await actor.submit(inquiry);
      expect(actor.status, ContactFormStatus.success);
      expect(actor.failure, isNull);
    });
  });

  // ─── Value-object validation helpers (unit-level, here for regression) ───

  group('Value object validation (regression guard)', () {
    test('EmailAddress.create rejects bad email', () {
      final result = EmailAddress.create('not-an-email');
      expect(result.isErr, isTrue);
    });

    test('EmailAddress.create accepts valid email', () {
      final result = EmailAddress.create('valid@domain.com');
      expect(result.isOk, isTrue);
    });

    test('PersonName.create rejects blank name', () {
      final result = PersonName.create('  ');
      expect(result.isErr, isTrue);
    });

    test('ContactMessage.create rejects empty message', () {
      final result = ContactMessage.create('');
      expect(result.isErr, isTrue);
    });

    test('ContactMessage.create accepts valid message', () {
      final result = ContactMessage.create('Consulta sobre trámite.');
      expect(result.isOk, isTrue);
    });
  });
}
