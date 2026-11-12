import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/state/locale_provider.dart';
import 'package:portfolio/shared/layout/locale_transition_host.dart';
import 'package:portfolio/shared/widgets/language_toggle.dart';

import 'helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('host: switches at once, ignores a second call while running, '
      'then cleans up', (tester) async {
    final got = <Locale>[];
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: Text('page')),
        builder: (context, child) =>
            LocaleTransitionHost(onLocaleChanged: got.add, child: child!),
      ),
    );
    final host = tester.state<LocaleTransitionHostState>(
      find.byType(LocaleTransitionHost),
    );
    Finder overlay() => find.byWidgetPredicate(
      (w) =>
          w is CustomPaint && '${w.painter.runtimeType}' == '_SnapshotPainter',
    );

    host.switchLocale(const Locale('ar'));
    expect(host.running.value, isTrue);
    await tester.pump(); // the frame the picture is taken after
    expect(got, [const Locale('ar')]);
    host.switchLocale(const Locale('en'));
    await tester.pump(const Duration(milliseconds: 700));
    expect(overlay(), findsOneWidget, reason: 'dust is mid-flight');
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 5)); // outlasts the 4.4 s dust
    await tester.pump();
    expect(host.running.value, isFalse);
    expect(overlay(), findsNothing, reason: 'the snapshot is gone');
    expect(got, [const Locale('ar')]);
  });

  // A heading only the Arabic page shows, per route.
  const arabicPages = {
    '/about': 'الأدوات',
    '/contact': 'ما نوع المشروع؟',
    '/playground': 'ما الذي تثبته',
    '/playground/one-codebase': 'جرّب هذا',
    '/playground/role-based-ui': 'كل الطلبات',
    '/playground/data-at-scale': 'الصفوف المبنية',
    '/playground/offline-sync': 'إضافة مهمة',
    '/playground/rtl-localization': 'حجم النص',
    '/playground/motion-lab': 'آخر استقرار',
    '/playground/nope': 'العودة إلى الرئيسية',
  };
  for (final size in const [Size(1280, 900), Size(390, 844)]) {
    testWidgets('every other page turns Arabic without overflow at '
        '${size.width.toInt()}', (tester) async {
      for (final MapEntry(key: path, value: heading) in arabicPages.entries) {
        final errors = await collectFlutterErrors(() async {
          await pumpApp(tester, path: path, size: size);
          ProviderScope.containerOf(
            tester.element(find.byType(LocaleTransitionHost)),
          ).read(localeProvider.notifier).set(const Locale('ar'));
          await settle(tester);
        });
        expect(errors, isEmpty, reason: path);
        // The 720 px register folds its header columns away.
        if (path != '/playground' || size.width >= 720) {
          expect(find.text(heading), findsWidgets, reason: path);
        }
        await tester.pumpWidget(const SizedBox());
      }
    });
  }

  testWidgets('a picked budget survives the switch to Arabic', (tester) async {
    await pumpApp(tester, path: '/contact');
    // Mid-screen, clear of the navbar.
    await Scrollable.ensureVisible(
      tester.element(find.text('Select a range')),
      alignment: 0.5,
    );
    await settle(tester);
    await tester.tap(find.text('Select a range'));
    await settle(tester);
    await tester.tap(find.text('Medium (1–3 months)').last);
    await settle(tester);
    ProviderScope.containerOf(
      tester.element(find.byType(LocaleTransitionHost)),
    ).read(localeProvider.notifier).set(const Locale('ar'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('متوسط (1–3 أشهر)'), findsOneWidget);
  });

  for (final size in const [Size(1280, 900), Size(390, 844)]) {
    testWidgets('the landing page turns Arabic and RTL without overflow at '
        '${size.width.toInt()}', (tester) async {
      late ProviderContainer container;
      final errors = await collectFlutterErrors(() async {
        await pumpApp(tester, size: size);
        container = ProviderScope.containerOf(
          tester.element(find.byType(LocaleTransitionHost)),
        );
        expect(find.text('Selected work'), findsOneWidget);

        if (size.width >= 1024) {
          await tester.tap(find.byType(LanguageToggle));
          await tester.pump();
          final toggle = tester.widget<TextButton>(
            find.descendant(
              of: find.byType(LanguageToggle),
              matching: find.byType(TextButton),
            ),
          );
          expect(toggle.onPressed, isNull, reason: 'disabled while running');
        } else {
          // Phones keep the toggle in the drawer; drive the host directly.
          tester
              .state<LocaleTransitionHostState>(
                find.byType(LocaleTransitionHost),
              )
              .switchLocale(const Locale('ar'));
        }
        await settle(tester);
        await settle(tester);
      });

      expect(errors, isEmpty);
      expect(container.read(localeProvider), const Locale('ar'));
      expect(find.text('أعمال مختارة'), findsOneWidget);
      expect(find.text('Selected work'), findsNothing);
      expect(
        Directionality.of(tester.element(find.text('أعمال مختارة'))),
        TextDirection.rtl,
      );
      if (size.width >= 1024) expect(find.text('English'), findsOneWidget);
    });
  }
}
