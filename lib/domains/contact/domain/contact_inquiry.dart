import 'value_objects/contact_message.dart';
import 'value_objects/email_address.dart';
import 'value_objects/person_name.dart';

/// Immutable domain entity for a contact inquiry submitted by a site visitor.
///
/// Required fields are wrapped in validated value objects; optional fields
/// use nullable [String] since they have no domain invariants beyond presence.
final class ContactInquiry {
  /// Visitor's full name.
  final PersonName name;

  /// Visitor's email address.
  final EmailAddress email;

  /// Optional phone number — no format validation at domain level.
  final String? phone;

  /// Optional company or organisation name.
  final String? company;

  /// Selected consultation type (e.g. 'Servicios Legales', 'Soluciones IA').
  final String? consultationType;

  /// Preferred office location identifier (e.g. 'CDMX', 'GDL', 'Virtual').
  final String? preferredOffice;

  /// The body of the inquiry message.
  final ContactMessage message;

  /// Whether the visitor considers the matter urgent.
  final bool isUrgent;

  /// Preferred contact method: 'email' or 'phone'.
  final String contactMethod;

  const ContactInquiry({
    required this.name,
    required this.email,
    this.phone,
    this.company,
    this.consultationType,
    this.preferredOffice,
    required this.message,
    required this.isUrgent,
    required this.contactMethod,
  });

  /// Converts the entity to a map suitable for a Supabase INSERT into
  /// `public.contact_inquiries`.  Keys match the table column names exactly.
  Map<String, dynamic> toInsert() => {
    'name': name.value,
    'email': email.value,
    if (phone != null && phone!.isNotEmpty) 'phone': phone,
    if (company != null && company!.isNotEmpty) 'company': company,
    if (consultationType != null) 'consultation_type': consultationType,
    if (preferredOffice != null) 'preferred_office': preferredOffice,
    'message': message.value,
    'is_urgent': isUrgent,
    'contact_method': contactMethod,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactInquiry &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          company == other.company &&
          consultationType == other.consultationType &&
          preferredOffice == other.preferredOffice &&
          message == other.message &&
          isUrgent == other.isUrgent &&
          contactMethod == other.contactMethod);

  @override
  int get hashCode => Object.hash(
    name,
    email,
    phone,
    company,
    consultationType,
    preferredOffice,
    message,
    isUrgent,
    contactMethod,
  );

  @override
  String toString() =>
      'ContactInquiry(name: ${name.value}, email: ${email.value})';
}
