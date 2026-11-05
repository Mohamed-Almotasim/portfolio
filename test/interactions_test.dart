import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';
import 'package:portfolio/shared/widgets/code_viewer.dart';
import 'package:portfolio/shared/widgets/theme_toggle_button.dart';

import 'helpers/pump_app.dart';

Brightness _brightness(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(AppNavbar))).brightness;

void main() {
  setUpAll(loadAppFonts);

  testWidgets('the theme toggle switches between dark and light', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(_brightness(tester), Brightness.dark);

    await tester.tap(find.byType(ThemeToggleButton));
    await settle(tester);
    expect(_brightness(tester), Brightness.light);

    await tester.tap(find.byType(ThemeToggleButton));
    await settle(tester);
    expect(_brightness(tester), Brightness.dark);
  });

  testWidgets('developer mode reveals the real source of a demo', (
    tester,
  ) async {
    await pumpApp(
      tester,
      path: AppRoutes.playground,
      size: const Size(1280, 2400),
    );
    expect(find.text('Show code'), findsNothing);

    await tester.tap(
      find.byTooltip('Developer mode: show the code behind each demo'),
    );
    await settle(tester);
    expect(find.textContaining('Developer mode is on'), findsOneWidget);

    await tester.tap(find.text('Show code').first);
    // The snippet is read from the bundled source file (real I/O).
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await settle(tester);

    expect(find.byType(CodeViewer), findsOneWidget);
    expect(find.textContaining('_isHovered', findRichText: true), findsWidgets);
  });
}
