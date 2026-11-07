import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/playground/playground_page.dart';
import 'package:portfolio/features/playground/specimen_info.dart';
import 'package:portfolio/features/playground/specimen_page.dart';
import 'package:portfolio/features/playground/specimens/rtl_localization.dart';

import 'helpers/pump_app.dart';

Future<String> at(WidgetTester tester, String path, [Size? size]) async {
  final router = await pumpApp(
    tester,
    path: path,
    size: size ?? const Size(1280, 1600),
  );
  return router.routerDelegate.currentConfiguration.uri.path;
}

Future<void> tapText(WidgetTester tester, String text) async {
  final f = find.text(text);
  await tester.ensureVisible(f.first);
  await tester.tap(f.first);
  await settle(tester);
}

Future<void> reset(WidgetTester tester) async {
  final f = find.byKey(const Key('specimen-reset'));
  await tester.ensureVisible(f);
  await tester.tap(f);
  await settle(tester);
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('register lists every specimen and opens one', (tester) async {
    expect(await at(tester, '/playground'), '/playground');
    expect(find.byType(PlaygroundPage), findsOneWidget);
    for (final s in specimens) {
      expect(find.text(s.name), findsOneWidget);
    }
    await tapText(tester, 'Role-based UI');
    expect(find.byType(SpecimenPage), findsOneWidget);
    expect(find.text('TRY THIS'), findsOneWidget);
  });

  testWidgets('prev and next move between specimens', (tester) async {
    await at(tester, '/playground/role-based-ui');
    await tapText(tester, 'Data at scale →');
    expect(
      find.text('Ten thousand rows stay smooth', skipOffstage: false),
      findsNothing,
    ); // claim reads "Ten thousand rows stay smooth with…"
    expect(find.textContaining('Ten thousand rows'), findsOneWidget);
    await tapText(tester, '← Role-based UI');
    expect(find.textContaining('same screen changes'), findsOneWidget);
  });

  testWidgets('unknown specimen is a 404 page', (tester) async {
    await at(tester, '/playground/nope');
    expect(find.byType(SpecimenPage), findsOneWidget);
    expect(find.text('TRY THIS'), findsNothing);
  });

  for (final old in ['/ui-showcase', '/widget-gallery', '/app-demos']) {
    testWidgets('old $old redirects to the playground', (tester) async {
      expect(await at(tester, old), '/playground');
      expect(find.byType(PlaygroundPage), findsOneWidget);
    });
  }

  testWidgets('01 size class follows the preset and reset restores', (
    tester,
  ) async {
    await at(tester, '/playground/one-codebase');
    expect(find.text('phone'), findsOneWidget);
    await tapText(tester, 'Desktop');
    expect(find.text('1200 px'), findsOneWidget);
    expect(find.text('list + detail'), findsOneWidget);
    await reset(tester);
    expect(find.text('390 px'), findsOneWidget);
  });

  testWidgets('02 role switch locks and explains actions', (tester) async {
    await at(tester, '/playground/role-based-ui');
    expect(find.text('6 / 6'), findsOneWidget);
    await tapText(tester, 'Customer');
    expect(find.text('2 / 6'), findsOneWidget);
    await tapText(tester, 'Refund');
    expect(
      find.textContaining('denied orders.refund (needs Admin)'),
      findsOneWidget,
    );
    await reset(tester);
    expect(find.text('6 / 6'), findsOneWidget);
  });

  testWidgets('03 virtualized builds a handful of rows, naive many', (
    tester,
  ) async {
    await at(tester, '/playground/data-at-scale');
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.textContaining('10,000'), findsWidgets);
    expect(find.text('virtualized'), findsOneWidget);
    await tapText(tester, '1,000');
    await tapText(tester, 'Naive');
    expect(find.text('naive'), findsOneWidget);
    await reset(tester);
    expect(find.text('virtualized'), findsOneWidget);
  });

  testWidgets('04 offline queues a task and reconnecting syncs it', (
    tester,
  ) async {
    await at(tester, '/playground/offline-sync');
    await tapText(tester, 'Offline');
    await tapText(tester, 'Add task');
    expect(find.text('offline'), findsWidgets);
    expect(find.text('pending'), findsOneWidget);
    await tapText(tester, 'Online');
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('pending'), findsNothing);
    await reset(tester);
    expect(find.text('queue: empty'), findsOneWidget);
  });

  testWidgets('05 Arabic mirrors the layout and formats numbers', (
    tester,
  ) async {
    await at(tester, '/playground/rtl-localization');
    Directionality cart() => tester.widget<Directionality>(
      find
          .descendant(
            of: find.byType(RtlLocalizationSpecimen),
            matching: find.byType(Directionality),
          )
          .first,
    );
    expect(cart().textDirection, TextDirection.ltr);
    expect(find.text('2,110 SAR'), findsWidgets);
    await tapText(tester, 'العربية');
    expect(cart().textDirection, TextDirection.rtl);
    expect(find.text('rtl'), findsWidgets);
    expect(find.textContaining('٢٬١١٠'), findsWidgets);
    await reset(tester);
    expect(cart().textDirection, TextDirection.ltr);
  });

  testWidgets('06 fold animates and reset unfolds', (tester) async {
    await at(tester, '/playground/motion-lab');
    expect(find.text('0%'), findsOneWidget);
    await tapText(tester, 'Fold');
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('100%'), findsOneWidget);
    await reset(tester);
    expect(find.text('0%'), findsOneWidget);
  });

  testWidgets('every specimen fits at all sizes and text scales', (
    tester,
  ) async {
    final errors = await collectFlutterErrors(() async {
      for (final size in const [
        Size(390, 844),
        Size(820, 1180),
        Size(1440, 900),
      ]) {
        for (final scale in const [1.0, 2.0]) {
          for (final s in ['', ...specimens.map((s) => '/${s.slug}')]) {
            await pumpApp(
              tester,
              path: '/playground$s',
              size: size,
              textScale: scale,
            );
          }
        }
      }
    });
    expect(errors, isEmpty);
  });
}
