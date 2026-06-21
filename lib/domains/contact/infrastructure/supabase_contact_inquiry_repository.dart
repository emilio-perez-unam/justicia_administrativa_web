import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../application/contact_inquiry_repository.dart';
import '../domain/contact_inquiry.dart';

/// Supabase adapter for [ContactInquiryRepository].
///
/// Inserts a row into `public.contact_inquiries` using the anonymous RLS
/// policy that permits INSERT for both `anon` and `authenticated` roles.
/// All errors are translated to domain [Failure]s via [mapErrorToFailure].
class SupabaseContactInquiryRepository implements ContactInquiryRepository {
  /// The Supabase client used for DB operations.
  /// Defaults to [Supabase.instance.client] to allow injection in tests.
  final SupabaseClient _client;

  SupabaseContactInquiryRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  @override
  Future<Result<ContactInquiry>> submit(ContactInquiry inquiry) async {
    try {
      await _client.from('contact_inquiries').insert(inquiry.toInsert());
      return Ok(inquiry);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
