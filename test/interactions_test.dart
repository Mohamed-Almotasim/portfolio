import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';
import 'package:portfolio/shared/widgets/theme_toggle_button.dart';

import 'helpers/pump_app.dart';

Brightness _brightness(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(AppNavbar))).brightness;

void main() {
  setUpAll(loadAppFonts);

  testWidgets('the theme toggle switches between dark and light', (
    tester,
  ) async {
    // Follows the OS until the visitor picks.
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await pumpApp(tester);
    expect(_brightness(tester), Brightness.dark);

    await tester.tap(find.byType(ThemeToggleButton));
    await settle(tester);
    expect(_brightness(tester), Brightness.light);

    await tester.tap(find.byType(ThemeToggleButton));
    await settle(tester);
    expect(_brightness(tester), Brightness.dark);
  });
}
