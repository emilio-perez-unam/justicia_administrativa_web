import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/core/routes/app_routes.dart';

class JusticiaAdministrativaApp extends StatelessWidget {
  const JusticiaAdministrativaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Justicia Administrativa',
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
