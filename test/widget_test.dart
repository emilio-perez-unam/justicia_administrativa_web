import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:justicia_administrativa_site/app/app.dart';
import 'package:justicia_administrativa_site/app/components/navbar.dart';

const MethodChannel _sharedPrefsChannel = MethodChannel(
  'plugins.flutter.io/shared_preferences',
);

Future<void> _initializeTestDependencies() async {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_sharedPrefsChannel, (call) async {
        if (call.method == 'getAll') return <String, Object>{};
        if (call.method == 'setBool' ||
            call.method == 'setDouble' ||
            call.method == 'setInt' ||
            call.method == 'setString' ||
            call.method == 'setStringList' ||
            call.method == 'remove' ||
            call.method == 'clear') {
          return true;
        }
        return null;
      });

  try {
    Supabase.instance.client;
  } catch (_) {
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlc3QiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTY4MDAwMDAwMCwiZXhwIjoyMDAwMDAwMDAwfQ.'
          'testsignature',
    );
  }
}

Widget _testShell(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: ResponsiveBreakpoints.builder(
        child: child,
        breakpoints: const [
          Breakpoint(start: 0, end: 767, name: 'MOBILE'),
          Breakpoint(start: 768, end: 1199, name: 'TABLET'),
          Breakpoint(start: 1200, end: 3840, name: 'DESKTOP'),
        ],
      ),
    ),
  );
}

Widget _testAppLayoutShell(Widget child) {
  return MaterialApp(
    home: AppLayout(routeLocation: '/', child: child),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _initializeTestDependencies();
  });

  testWidgets('Navbar desktop renders links and portal action', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_testShell(const Navbar()));
    await tester.pump();

    expect(find.text('Servicios'), findsOneWidget);
    expect(find.text('Contacto'), findsOneWidget);
    expect(find.text('Portal Cliente'), findsOneWidget);
  });

  testWidgets('Navbar mobile opens full-screen menu drawer', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_testShell(const Navbar()));
    await tester.pump();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Menú'), findsOneWidget);
    expect(find.text('Portal Cliente'), findsOneWidget);
  });

  testWidgets('Navbar mobile uses a single close button and closes correctly', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_testShell(const Navbar()));
    await tester.pump();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Menú'), findsOneWidget);
    expect(find.byIcon(LucideIcons.x), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pumpAndSettle();

    expect(find.text('Menú'), findsNothing);
  });

  testWidgets('AppLayout mobile menu opens from navbar overlay', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(760, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _testAppLayoutShell(const SizedBox(width: double.infinity, height: 1400)),
    );
    await tester.pump();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Menú'), findsOneWidget);
    expect(find.text('Portal Cliente'), findsOneWidget);
  });
}
