import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';

const _routes = [
  '/',
  '/work',
  '/work/portfolio-web-app',
  '/playground',
  '/playground?tab=patterns',
  '/app-demos',
  '/architecture',
  '/services',
  '/contact',
];

Future<List<String>> pumpCollectingErrors(
  WidgetTester tester, {
  required double width,
  required String path,
  double textScale = 1,
}) async {
  tester.view.physicalSize = Size(width, 1000);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final errors = <String>[];
  final original = FlutterError.onError;
  FlutterError.onError = (d) {
    final where = RegExp(r'lib/\S+\.dart:\d+').firstMatch(d.toString());
    errors.add('${d.exceptionAsString().split('\n').first} @ ${where?[0]}');
  };
  try {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          routerProvider.overrideWithValue(createRouter(initialLocation: path)),
        ],
        child: const PortfolioApp(),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  } finally {
    FlutterError.onError = original;
  }
  return errors;
}

void main() {
  for (final width in [390.0, 1280.0]) {
    for (final path in _routes) {
      testWidgets('$path survives 1.3x text at ${width}px', (tester) async {
        final errors = await pumpCollectingErrors(
          tester,
          width: width,
          path: path,
          textScale: 1.3,
        );
        expect(errors.toSet(), isEmpty);
      });
    }
  }

  testWidgets('first Tab press lands in the navbar', (tester) async {
    await pumpCollectingErrors(tester, width: 1280, path: '/');
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final focused = FocusManager.instance.primaryFocus!.context!;
    expect(
      find.ancestor(
        of: find.byWidget(focused.widget),
        matching: find.byType(AppNavbar),
      ),
      findsWidgets,
    );

    // ...and keeps going past the navbar into the page.
    var reachedPage = false;
    for (var i = 0; i < 20 && !reachedPage; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final ctx = FocusManager.instance.primaryFocus!.context!;
      reachedPage = ctx.findAncestorWidgetOfExactType<AppNavbar>() == null;
    }
    expect(reachedPage, isTrue);
  });
}
