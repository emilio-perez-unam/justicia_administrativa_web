import 'package:supabase_flutter/supabase_flutter.dart';

/// Persists public blog newsletter sign-ups to the `newsletter_subscribers`
/// table, mirroring the lightweight static-service pattern used elsewhere in
/// `core/services` (e.g. `BlogService`).
class NewsletterService {
  static final _client = Supabase.instance.client;

  /// Records a newsletter subscription for [email].
  ///
  /// Returns normally on success and on a duplicate e-mail (the visitor is
  /// already subscribed, which is not an error from their perspective).
  /// Rethrows any other failure so the caller can surface an honest message.
  static Future<void> subscribe(String email) async {
    try {
      await _client.from('newsletter_subscribers').insert({'email': email});
    } on PostgrestException catch (error) {
      // 23505 = unique_violation → already subscribed; treat as success.
      if (error.code == '23505') return;
      rethrow;
    }
  }
}
