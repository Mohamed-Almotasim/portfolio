import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/landing/landing_page.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';
import 'package:portfolio/shared/widgets/cta_band.dart';

import 'helpers/pump_app.dart';

/// Widths that matter: smallest phone, common phone, tablet, both sides of
/// the drawer breakpoint, laptop and wide desktop.
const _sizes = [
  Size(320, 900),
  Size(390, 844),
  Size(768, 1024),
  Size(1023, 900),
  Size(1024, 900),
  Size(1440, 900),
  Size(1920, 1080),
];

void main() {
  setUpAll(loadAppFonts);

  for (final size in _sizes) {
    for (final path in allRoutes) {
      testWidgets('$path renders without errors at ${size.width.toInt()}px', (
        tester,
      ) async {
        final errors = await collectFlutterErrors(
          () => pumpApp(tester, path: path, size: size),
        );
        expect(errors, isEmpty);
      });
    }
  }

  testWidgets('hamburger opens the drawer below 1024px', (tester) async {
    await pumpApp(tester, size: const Size(1023, 900));
    expect(find.byType(Drawer), findsNothing);
    await tester.tap(find.byIcon(Icons.menu));
    await settle(tester);
    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('no hamburger at 1024px', (tester) async {
    await pumpApp(tester, size: const Size(1024, 900));
    expect(find.byIcon(Icons.menu), findsNothing);
  });

  testWidgets('unknown route shows 404 and Back home works', (tester) async {
    await pumpApp(tester, path: '/nope');
    expect(find.text('404'), findsOneWidget);
    await tester.tap(find.text('Back home'));
    await settle(tester);
    expect(find.text('404'), findsNothing);
  });

  testWidgets('nav link navigates and the navbar persists', (tester) async {
    await pumpApp(tester);
    final navbar = tester.element(find.byType(AppNavbar));
    await tester.tap(
      find.descendant(
        of: find.byType(AppNavbar),
        matching: find.text('Architecture'),
      ),
    );
    await settle(tester);
    expect(find.byType(LandingPage), findsNothing);
    expect(find.text('Notes on this codebase'), findsOneWidget);
    // Same element: the shell was not rebuilt from scratch.
    expect(tester.element(find.byType(AppNavbar)), same(navbar));
  });

  testWidgets('sections below the fold reveal only once scrolled into view', (
    tester,
  ) async {
    await pumpApp(tester);
    double opacityOf(Type section) => tester
        .widget<FadeTransition>(
          find
              .ancestor(
                of: find.byType(section),
                matching: find.byType(FadeTransition),
              )
              .first,
        )
        .opacity
        .value;
    expect(opacityOf(CtaBand), 0);
    await tester.scrollUntilVisible(find.byType(CtaBand), 300);
    await settle(tester);
    expect(opacityOf(CtaBand), 1);
  });
}
