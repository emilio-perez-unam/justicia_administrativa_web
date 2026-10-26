import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/client_portal.dart';
import '../router.dart';

class PortalView extends StatelessWidget {
  final String? initialTab;
  const PortalView({super.key, this.initialTab});

  @override
  Widget build(BuildContext context) {
    return ClientPortal(
      initialTab: initialTab,
      onLogout: () async {
        try {
          await Supabase.instance.client.auth.signOut();
        } catch (_) {
          // Best-effort logout: leave the portal even if remote sign-out
          // fails, so no session data stays visible.
        }
        if (context.mounted) context.go(AppRouter.home);
      },
    );
  }
}
