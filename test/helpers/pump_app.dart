import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/theme/app_typography.dart';

/// Every page a visitor can land on, including the redirecting old URLs.
const allRoutes = [
  '/',
  '/work',
  '/work/dukkan',
  '/work/recall',
  '/playground',
  '/playground/one-codebase',
  '/playground/role-based-ui',
  '/playground/data-at-scale',
  '/playground/offline-sync',
  '/playground/rtl-localization',
  '/playground/motion-lab',
  '/ui-showcase',
  '/widget-gallery',
  '/app-demos',
  '/architecture',
  '/services',
  '/contact',
];

/// Call from `setUpAll` so layout is measured with the real bundled fonts
/// (Archivo Expanded / IBM Plex Sans / IBM Plex Mono), not the test framework's square placeholder glyphs.
Future<void> loadAppFonts() {
  return preloadFonts();
}

/// Pumps the whole app (ProviderScope + router + theme) at [path] and [size],
/// then lets it run a second. Returns the router so tests can read the URL.
Future<GoRouter> pumpApp(
  WidgetTester tester, {
  String path = '/',
  Size size = const Size(1280, 900),
  double textScale = 1,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final router = createRouter(initialLocation: path);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [routerProvider.overrideWithValue(router), ...overrides],
      child: const PortfolioApp(),
    ),
  );
  await settle(tester);
  return router;
}

/// The landing page loops background animations, so pumpAndSettle never
/// settles; pump a fixed second instead.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

/// Runs [body] and returns Flutter errors (overflows etc.) it reported, each
/// reduced to its first line plus the app source location, de-duplicated.
Future<Set<String>> collectFlutterErrors(Future<void> Function() body) async {
  final errors = <String>{};
  final original = FlutterError.onError;
  FlutterError.onError = (d) {
    final where = RegExp(r'lib/\S+\.dart:\d+').firstMatch(d.toString());
    errors.add('${d.exceptionAsString().split('\n').first} @ ${where?[0]}');
  };
  try {
    await body();
  } finally {
    FlutterError.onError = original;
  }
  return errors;
}
