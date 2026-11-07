import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/state/theme_tokens_provider.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/core/theme/theme_tokens.dart';
import 'package:portfolio/features/landing/landing_page.dart';
import 'package:portfolio/features/work/work_page.dart';
import 'package:portfolio/shared/demo/source_snippet.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/layout/inspector_panel.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';

import 'helpers/pump_app.dart';

void main() {
  tearDown(RenderInspectable.selection.clear);

  testWidgets('a click opens the panel with label, note and constraints; '
      'Esc and an outside click close it', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(developerModeProvider.notifier).set(true);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Stack(
            children: [
              Center(
                child: Inspectable(
                  label: 'Outer',
                  padding: EdgeInsets.all(8),
                  child: Inspectable(
                    label: 'Card',
                    note: 'Why it is built this way.',
                    child: SizedBox(width: 200, height: 100),
                  ),
                ),
              ),
              Positioned.fill(child: InspectorLayer()),
            ],
          ),
        ),
      ),
    );
    expect(find.byType(InspectorPanel), findsNothing);

    // The test view is 800×600; the panel is a bottom sheet there.
    await tester.tapAt(const Offset(400, 260));
    await tester.pump();
    expect(find.byType(InspectorPanel), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('Why it is built this way.'), findsOneWidget);
    // Center loosens 800×600; Outer's 8px padding takes 16 off each axis.
    expect(find.text('w 0–784 · h 0–584'), findsOneWidget);
    expect(find.text('200 × 100'), findsOneWidget);
    expect(find.text('Outer / Card'), findsOneWidget, reason: 'path');
    expect(find.text('none'), findsNWidgets(2), reason: 'padding, margin');

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.byType(InspectorPanel), findsNothing);

    await tester.tapAt(const Offset(400, 260));
    await tester.pump();
    expect(find.byType(InspectorPanel), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    expect(find.byType(InspectorPanel), findsNothing);

    // Every tab renders; clicks inside the panel keep it open.
    await tester.tapAt(const Offset(400, 260));
    await tester.pump();
    for (final tab in ['Tokens', 'Perf', 'A11y', 'Layout']) {
      await tester.tap(find.text(tab));
      await tester.pump();
      await tester.pump();
      expect(find.byType(InspectorPanel), findsOneWidget, reason: tab);
    }
    expect(find.text('Text contrast'), findsNothing, reason: 'left A11y');
  });

  testWidgets('token changes update the theme; Inspect off resets them', (
    tester,
  ) async {
    await pumpApp(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(LandingPage)),
    );
    container.read(developerModeProvider.notifier).set(true);
    final base = Theme.of(tester.element(find.byType(LandingPage)));

    container
        .read(themeTokensProvider.notifier)
        .set(
          const ThemeTokens(
            accent: AccentOption.red,
            space: 1.5,
            typeScale: 1.25,
          ),
        );
    await settle(tester); // MaterialApp animates theme changes
    var theme = Theme.of(tester.element(find.byType(LandingPage)));
    expect(theme.extension<AppDecorations>()!.accent, AppColors.red);
    expect(theme.colorScheme.primary, AppColors.redText);
    expect(theme.extension<AppDecorations>()!.space, 1.5);
    expect(
      theme.textTheme.bodyLarge!.fontSize,
      base.textTheme.bodyLarge!.fontSize! * 1.25,
    );

    container.read(developerModeProvider.notifier).set(false);
    await settle(tester); // MaterialApp animates theme changes
    theme = Theme.of(tester.element(find.byType(LandingPage)));
    expect(container.read(themeTokensProvider).isDefault, isTrue);
    expect(theme.extension<AppDecorations>()!.accent, AppColors.orange);
  });

  testWidgets('dev mode off: no panel, no tracking, no layers, no counts', (
    tester,
  ) async {
    RenderInspectable.rebuilds.clear();
    await pumpApp(tester);
    await tester.tapAt(const Offset(400, 300));
    await settle(tester);
    expect(find.byType(InspectorLayer), findsNothing);
    final boxes = tester.renderObjectList<RenderInspectable>(
      find.byType(Inspectable),
    );
    expect(boxes, isNotEmpty);
    for (final b in boxes) {
      expect(b.validForMouseTracker, isFalse);
      expect(b.debugLayer, isNull);
    }
    expect(RenderInspectable.selection.box, isNull);
    expect(RenderInspectable.rebuilds, isEmpty);
  });

  test('every annotated source points at its Inspectable and is bundled', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final pattern = RegExp(r"[sS]ource: '(lib/[^']+):(\d+)'");
    var found = 0;
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      for (final m in pattern.allMatches(f.readAsStringSync())) {
        found++;
        final path = m[1]!;
        final first = extractLines(
          File(path).readAsStringSync(),
          int.parse(m[2]!),
        ).split('\n').first;
        expect(
          first,
          matches(RegExp(r'(Inspectable|AppSection)\(')),
          reason: '${m[0]} in ${f.path}',
        );
        expect(inspectorSourceFiles, contains(path));
        expect(pubspec, contains('- $path'), reason: 'bundle $path');
      }
    }
    expect(found, greaterThanOrEqualTo(10));
  });

  testWidgets('on desktop the open panel narrows the page instead of '
      'covering it', (tester) async {
    await pumpApp(tester, path: '/work', size: const Size(1440, 900));
    await tester.tap(find.byType(InspectToggle));
    await settle(tester);
    final before = tester.getSize(find.byType(RegisterRow).first).width;

    await tester.tap(find.text('No.'));
    await settle(tester);
    expect(find.byType(InspectorPanel), findsOneWidget);
    const panel = 1440.0 - 380; // docked right, 380 wide
    final row = tester.getTopRight(find.byType(RegisterRow).first).dx;
    expect(row, lessThanOrEqualTo(panel), reason: 'row ends before the panel');

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await settle(tester);
    expect(tester.getSize(find.byType(RegisterRow).first).width, before);
  });
}
