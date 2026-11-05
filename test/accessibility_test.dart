import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';

import 'helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final size in const [Size(390, 844), Size(1280, 900)]) {
    for (final path in allRoutes) {
      testWidgets('$path survives 1.3x text at ${size.width.toInt()}px', (
        tester,
      ) async {
        final errors = await collectFlutterErrors(
          () => pumpApp(tester, path: path, size: size, textScale: 1.3),
        );
        expect(errors, isEmpty);
      });
    }
  }

  testWidgets('first Tab lands in the navbar, then moves into the page', (
    tester,
  ) async {
    await pumpApp(tester);
    bool focusInNavbar() =>
        FocusManager.instance.primaryFocus!.context!
            .findAncestorWidgetOfExactType<AppNavbar>() !=
        null;

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focusInNavbar(), isTrue);

    var reachedPage = false;
    for (var i = 0; i < 20 && !reachedPage; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      reachedPage = !focusInNavbar();
    }
    expect(reachedPage, isTrue);
  });
}
