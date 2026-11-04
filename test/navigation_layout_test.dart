import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/routing/app_router.dart';

const routes = [
  '/',
  '/ui-showcase',
  '/widget-gallery',
  '/architecture',
  '/services',
  '/contact',
  '/app-demos',
];

Future<void> pumpAt(WidgetTester tester, double width, String path) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  AppRouter.router.go(path);
  await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
  await tester.pump(const Duration(seconds: 1));
}

// The default test font has square glyphs, far wider than Roboto; load the
// SDK's Roboto so overflow checks match what Chrome renders.
Future<void> loadRoboto() async {
  final dir =
      '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
  final loader = FontLoader('Roboto');
  for (final f in ['regular', 'medium', 'bold', 'light']) {
    final file = File('$dir/roboto-$f.ttf');
    if (file.existsSync()) {
      loader.addFont(
        Future.value(ByteData.sublistView(file.readAsBytesSync())),
      );
    }
  }
  await loader.load();
}

void main() {
  setUpAll(loadRoboto);

  for (final width in [320.0, 600.0, 1023.0, 1024.0, 1280.0, 1920.0]) {
    for (final path in routes) {
      testWidgets('$path renders without overflow at ${width}px', (
        tester,
      ) async {
        final errors = <String>[];
        final original = FlutterError.onError;
        FlutterError.onError = (d) {
          final where = RegExp(r'lib/\S+\.dart:\d+').firstMatch(d.toString());
          errors.add(
            '${d.exceptionAsString().split('\n').first} @ ${where?[0]}',
          );
        };
        try {
          await pumpAt(tester, width, path);
        } finally {
          FlutterError.onError = original;
        }
        expect(errors.toSet(), isEmpty);
      });
    }
  }

  testWidgets('hamburger opens the drawer below 1024px', (tester) async {
    await pumpAt(tester, 1023, '/');
    expect(find.byType(Drawer), findsNothing);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('no hamburger at 1024px', (tester) async {
    await pumpAt(tester, 1024, '/');
    expect(find.byIcon(Icons.menu), findsNothing);
  });

  testWidgets('unknown route shows 404 and Back home works', (tester) async {
    await pumpAt(tester, 1280, '/nope');
    expect(find.text('404'), findsOneWidget);
    await tester.tap(find.text('Back home'));
    await tester.pumpAndSettle();
    expect(find.text('404'), findsNothing);
  });
}
