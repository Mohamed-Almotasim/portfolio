import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/landing/landing_page.dart';
import 'package:portfolio/features/landing/widgets/home_sections.dart';
import 'package:portfolio/features/work/work_page.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';
import 'package:portfolio/shared/widgets/theme_toggle_button.dart';

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

/// Phones (portrait and landscape), also run at 130% text.
const _phones = [Size(360, 640), Size(412, 915), Size(844, 390)];

String _label(Size s) => '${s.width.toInt()}x${s.height.toInt()}';

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

  for (final size in _phones) {
    for (final scale in [1.0, 1.3]) {
      for (final path in allRoutes) {
        testWidgets('$path renders at ${_label(size)} text x$scale', (
          tester,
        ) async {
          final errors = await collectFlutterErrors(
            () => pumpApp(tester, path: path, size: size, textScale: scale),
          );
          expect(errors, isEmpty);
        });
      }
    }

    testWidgets('/contact with the keyboard open at ${_label(size)}', (
      tester,
    ) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      final errors = await collectFlutterErrors(() async {
        await pumpApp(tester, path: '/contact', size: size);
        await tester.showKeyboard(find.byType(TextField).first);
        await settle(tester);
      });
      expect(errors, isEmpty);
    });
  }

  // From 320px up, nothing in the bar is cut off or ellipsized.
  for (final width in <double>[320, 360, 412, 599, 600, 1023, 1024]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('navbar text fits at ${width.toInt()}px text x$scale', (
        tester,
      ) async {
        await pumpApp(tester, size: Size(width, 800), textScale: scale);
        final clipped = tester
            .renderObjectList<RenderParagraph>(
              find.descendant(
                of: find.byType(AppNavbar),
                matching: find.byType(RichText),
              ),
            )
            .where(
              (p) =>
                  p.didExceedMaxLines ||
                  p.size.width < p.getMaxIntrinsicWidth(double.infinity) - 0.5,
            )
            .map((p) => p.text.toPlainText());
        expect(clipped, isEmpty);
      });
    }
  }

  testWidgets('compact bar: monogram, Hire me and menu only', (tester) async {
    await pumpApp(tester, size: const Size(390, 844));
    final bar = find.byType(AppNavbar);
    Finder inBar(Finder f) => find.descendant(of: bar, matching: f);
    expect(inBar(find.text('Hire me')), findsOneWidget);
    expect(inBar(find.byIcon(Icons.menu)), findsOneWidget);
    expect(inBar(find.byType(ThemeToggleButton)), findsNothing);
    expect(inBar(find.byType(InspectToggle)), findsNothing);
    expect(inBar(find.text('Mohamed Almotasim Salih')), findsNothing);
    for (final e in tester.widgetList(inBar(find.byType(InkWell)))) {
      final size = tester.getSize(find.byWidget(e));
      expect(size.shortestSide, greaterThanOrEqualTo(48), reason: '$e');
    }
  });

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
      find.descendant(of: find.byType(AppNavbar), matching: find.text('Work')),
    );
    await settle(tester);
    expect(find.byType(LandingPage), findsNothing);
    expect(find.byType(WorkPage), findsOneWidget);
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
    expect(opacityOf(ContactBlock), 0);
    // The page's own scroll view is the outermost Scrollable.
    await tester.scrollUntilVisible(
      find.byType(ContactBlock),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester);
    expect(opacityOf(ContactBlock), 1);
  });
}
