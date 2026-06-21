import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:context_menus/context_menus.dart';
import 'core/config/env_config.dart';
import 'core/theme/app_theme.dart';
import 'app/router.dart';
import 'core/di/dependency_injection.dart';
import 'core/services/app_telemetry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppTelemetry.initialize(() async {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      final stack = details.stack ?? StackTrace.current;
      AppTelemetry.captureException(
        details.exception,
        stack,
        context: 'flutter_framework',
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      AppTelemetry.captureException(
        error,
        stack,
        context: 'platform_dispatcher',
      );
      return true;
    };

    await EasyLocalization.ensureInitialized();

    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );

    try {
      await Hive.initFlutter();
    } catch (e, stack) {
      await AppTelemetry.captureException(e, stack, context: 'hive_init');
    }

    try {
      await setupServiceLocator();
    } catch (e, stack) {
      await AppTelemetry.captureException(e, stack, context: 'service_locator');
    }

    GoRouter.optionURLReflectsImperativeAPIs = true;

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('es'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('es'),
        child: const ProviderScope(child: JusticIApp()),
      ),
    );
  });
}

class JusticIApp extends StatelessWidget {
  const JusticIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuOverlay(
      child: ToastificationWrapper(
        config: const ToastificationConfig(
          alignment: Alignment.topRight,
          itemWidth: 440,
          animationDuration: Duration(milliseconds: 500),
        ),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'JusticIA Administrativa',
          theme: AppTheme.light,
          themeMode: ThemeMode.light,
          routerConfig: AppRouter.router,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 767, name: 'MOBILE'),
              Breakpoint(start: 768, end: 1199, name: 'TABLET'),
              Breakpoint(start: 1200, end: 3840, name: 'DESKTOP'),
            ],
          ),
          localizationsDelegates: [
            ...context.localizationDelegates,
            FormBuilderLocalizations.delegate,
          ],
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ),
      ),
    );
  }
}
