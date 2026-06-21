import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../core/services/auth_notifier.dart';
import '../core/services/app_telemetry.dart';
import 'app.dart';
import 'views/home_view.dart';
import 'views/services_view.dart';
import 'views/about_view.dart';
import 'views/team_view.dart';
import 'views/blog_view.dart';
import 'views/contact_view.dart';
import 'views/portal_view.dart';
import 'views/login_view.dart';
import 'views/reset_password_view.dart';

enum _RouteTransitionProfile { mobile, tablet, desktop }

class AppRouter {
  static const String home = '/';
  static const String services = '/servicios';
  static const String about = '/nosotros';
  static const String team = '/equipo';
  static const String blog = '/blog';
  static const String contact = '/contacto';
  static const String portal = '/portal';
  static const String login = '/login';
  static const String resetPassword = '/reset-password';
  static const String aiAssistant = '/asistente-ia';

  static const String homeName = 'home';
  static const String servicesName = 'services';
  static const String aboutName = 'about';
  static const String teamName = 'team';
  static const String blogName = 'blog';
  static const String contactName = 'contact';
  static const String portalName = 'portal';
  static const String loginName = 'login';
  static const String resetPasswordName = 'reset_password';
  static const String aiAssistantName = 'ai_assistant';

  static final AuthNotifier authNotifier = AuthNotifier();

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: authNotifier,
    observers: <NavigatorObserver>[
      if (AppTelemetry.isEnabled) SentryNavigatorObserver(),
      _TelemetryRouteObserver(),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authNotifier.isAuthenticated;
      final location = state.matchedLocation;

      // Protected routes — require authentication.
      if ((location == portal || location == aiAssistant) && !isAuthenticated) {
        return login;
      }
      // Redirect authenticated users away from login to the portal.
      if (location == login && isAuthenticated) {
        return portal;
      }
      // /reset-password must NEVER be redirected to /login even when
      // unauthenticated: the user arrives here via a Supabase recovery link
      // and holds only a temporary recovery session (not a full auth session).
      if (location == resetPassword) {
        return null;
      }
      return null;
    },
    routes: [
      GoRoute(
        name: loginName,
        path: login,
        pageBuilder: (context, state) =>
            _adaptivePage(context, state, const LoginView(), isModal: true),
      ),

      GoRoute(
        name: resetPasswordName,
        path: resetPassword,
        pageBuilder: (context, state) => _adaptivePage(
          context,
          state,
          const ResetPasswordView(),
          isModal: true,
        ),
      ),

      GoRoute(
        name: aiAssistantName,
        path: aiAssistant,
        pageBuilder: (context, state) => _adaptivePage(
          context,
          state,
          const PortalView(initialTab: 'Herramientas IA'),
        ),
      ),

      GoRoute(
        name: portalName,
        path: portal,
        pageBuilder: (context, state) =>
            _adaptivePage(context, state, const PortalView()),
      ),

      ShellRoute(
        builder: (context, state, child) =>
            AppLayout(routeLocation: state.uri.path, child: child),
        routes: [
          GoRoute(
            name: homeName,
            path: home,
            pageBuilder: (context, state) =>
                _shellPage(state, const HomeView()),
          ),
          GoRoute(
            name: servicesName,
            path: services,
            pageBuilder: (context, state) =>
                _shellPage(state, const ServicesView()),
          ),
          GoRoute(
            name: aboutName,
            path: about,
            pageBuilder: (context, state) =>
                _shellPage(state, const AboutView()),
          ),
          GoRoute(
            name: teamName,
            path: team,
            pageBuilder: (context, state) =>
                _shellPage(state, const TeamView()),
          ),
          GoRoute(
            name: blogName,
            path: blog,
            pageBuilder: (context, state) =>
                _shellPage(state, const BlogView()),
          ),
          GoRoute(
            name: contactName,
            path: contact,
            pageBuilder: (context, state) =>
                _shellPage(state, const ContactView()),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.alertTriangle,
              color: Color(0xFFD4AF37),
              size: 64,
            ),
            const SizedBox(height: 24),
            const Text(
              '404',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Página no encontrada',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go(home),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Volver al Inicio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  static _RouteTransitionProfile _transitionProfileForContext(
    BuildContext context,
  ) {
    final width = MediaQuery.maybeOf(context)?.size.width ?? 1200;
    if (width < 768) return _RouteTransitionProfile.mobile;
    if (width < 1200) return _RouteTransitionProfile.tablet;
    return _RouteTransitionProfile.desktop;
  }

  static NoTransitionPage<void> _shellPage(GoRouterState state, Widget child) {
    return NoTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
    );
  }

  static CustomTransitionPage<void> _adaptivePage(
    BuildContext context,
    GoRouterState state,
    Widget child, {
    bool isModal = false,
  }) {
    final profile = _transitionProfileForContext(context);
    final transitionDuration = switch (profile) {
      _RouteTransitionProfile.mobile =>
        isModal
            ? const Duration(milliseconds: 320)
            : const Duration(milliseconds: 280),
      _RouteTransitionProfile.tablet => const Duration(milliseconds: 240),
      _RouteTransitionProfile.desktop => const Duration(milliseconds: 170),
    };
    final reverseTransitionDuration = switch (profile) {
      _RouteTransitionProfile.mobile => const Duration(milliseconds: 220),
      _RouteTransitionProfile.tablet => const Duration(milliseconds: 200),
      _RouteTransitionProfile.desktop => const Duration(milliseconds: 150),
    };

    return CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      child: RepaintBoundary(child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fillColor = Theme.of(context).scaffoldBackgroundColor;
        return ColoredBox(
          color: fillColor,
          child: switch (profile) {
            _RouteTransitionProfile.mobile => _buildMobileTransition(
              animation,
              secondaryAnimation,
              child,
              isModal: isModal,
            ),
            _RouteTransitionProfile.tablet => _buildTabletTransition(
              animation,
              secondaryAnimation,
              child,
              fillColor,
            ),
            _RouteTransitionProfile.desktop => _buildDesktopTransition(
              animation,
              secondaryAnimation,
              child,
              fillColor,
            ),
          },
        );
      },
    );
  }

  static Widget _buildMobileTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    required bool isModal,
  }) {
    final entranceOffset = isModal
        ? const Offset(0, 0.05)
        : const Offset(0.06, 0);
    final exitOffset = isModal
        ? const Offset(0, -0.02)
        : const Offset(-0.02, 0);

    final entranceSlide = Tween<Offset>(begin: entranceOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    final entranceFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.08, 1.0, curve: Curves.easeOut),
      ),
    );

    final outgoingDrift = Tween<Offset>(begin: Offset.zero, end: exitOffset)
        .animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeOutCubic,
          ),
        );

    return SlideTransition(
      position: outgoingDrift,
      child: FadeTransition(
        opacity: entranceFade,
        child: SlideTransition(position: entranceSlide, child: child),
      ),
    );
  }

  static Widget _buildTabletTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Color fillColor,
  ) {
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.scaled,
      fillColor: fillColor,
      child: child,
    );
  }

  static Widget _buildDesktopTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Color fillColor,
  ) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      fillColor: fillColor,
      child: child,
    );
  }
}

class _TelemetryRouteObserver extends NavigatorObserver {
  static String _nameFor(Route<dynamic>? route) {
    if (route == null) return 'unknown';
    if (route.settings.name case final String name when name.isNotEmpty) {
      return name;
    }
    final settings = route.settings;
    return settings.toString();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    unawaited(
      AppTelemetry.addNavigationBreadcrumb(
        action: 'push',
        route: _nameFor(route),
      ),
    );
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final target = previousRoute == null
        ? _nameFor(route)
        : _nameFor(previousRoute);
    unawaited(
      AppTelemetry.addNavigationBreadcrumb(action: 'pop', route: target),
    );
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    unawaited(
      AppTelemetry.addNavigationBreadcrumb(
        action: 'replace',
        route: _nameFor(newRoute ?? oldRoute),
      ),
    );
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    unawaited(
      AppTelemetry.addNavigationBreadcrumb(
        action: 'remove',
        route: _nameFor(route),
      ),
    );
    super.didRemove(route, previousRoute);
  }
}
