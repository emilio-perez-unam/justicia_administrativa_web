import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:justicia_administrativa_web/features/ai_solutions/screens/ai_solutions_screen.dart';
import 'package:justicia_administrativa_web/features/team/screens/team_screen.dart';
import 'package:justicia_administrativa_web/features/team/screens/profile_screen.dart'; // <-- ADDED IMPORT
import 'package:justicia_administrativa_web/shared/widgets/app_layout.dart';
import 'package:justicia_administrativa_web/features/home/screens/home_screen.dart';
import 'package:justicia_administrativa_web/features/legal_services/screens/legal_services_screen.dart';
import 'package:justicia_administrativa_web/features/about/screens/about_screen.dart';
import 'package:justicia_administrativa_web/features/contact/screens/contact_screen.dart';
import 'package:justicia_administrativa_web/features/blog/screens/blog_screen.dart';
import 'package:justicia_administrativa_web/features/publications/screens/publications_screen.dart';

/// Route configuration for Justicia Administrativa
class AppRoutes {
  static const String about = '/nosotros';
  static const String aiSolutions = '/soluciones-ia';
  static const String blog = '/blog';
  static const String contact = '/contacto';
  static const String home = '/';
  static const String legalServices = '/servicios-legales';
  static const String portal = '/portal';
  static const String publications = '/publicaciones';
  static const String team = '/equipo';
  static const String teamProfile = '/equipo/:id'; // <-- ADDED ROUTE PATH

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppLayout(child: child),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: team,
            name: 'team',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const TeamScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: teamProfile, // <-- ADDED PROFILE ROUTE
            name: 'team-profile',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: ProfileScreen(memberId: state.pathParameters['id']!),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Hero animation transition
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0.0, 0.05),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                        child: child,
                      ),
                    );
                  },
            ),
          ),
          GoRoute(
            path: legalServices,
            name: 'legal-services',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const LegalServicesScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: aiSolutions,
            name: 'ai-solutions',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AiSolutionsScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: publications,
            name: 'publications',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const PublicationsScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: about,
            name: 'about',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AboutScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: contact,
            name: 'contact',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ContactScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: portal,
            name: 'portal',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const Placeholder(
                child: Center(child: Text('Client Portal')),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: blog,
            name: 'blog',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const BlogScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
