import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int n = 0;

  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: () => setState(() => n++), child: Text('n=$n'));
}

void main() {
  late ProviderContainer container;

  Future<void> pump(WidgetTester tester) {
    container = ProviderContainer();
    addTearDown(container.dispose);
    return tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Center(
            child: Inspectable(
              label: 'Outer',
              padding: EdgeInsets.all(24),
              child: Inspectable(label: 'Inner', child: _Counter()),
            ),
          ),
        ),
      ),
    );
  }

  RenderInspectable box(WidgetTester tester, String label) => tester
      .renderObjectList<RenderInspectable>(find.byType(Inspectable))
      .elementAt(label == 'Outer' ? 0 : 1);

  testWidgets('off: inert, no layer, not mouse-tracked', (tester) async {
    await pump(tester);
    final outer = box(tester, 'Outer');
    expect(outer.enabled, isFalse);
    expect(outer.validForMouseTracker, isFalse);
    expect(outer.debugLayer, isNull);
  });

  testWidgets('toggling keeps the child state and applies the padding', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('n=0'));
    await tester.pump();
    container.read(developerModeProvider.notifier).set(true);
    await tester.pump();
    expect(find.text('n=1'), findsOneWidget, reason: 'state survived');
    expect(box(tester, 'Outer').validForMouseTracker, isTrue);
    expect(
      box(tester, 'Outer').size.width - box(tester, 'Inner').size.width,
      48,
    );
  });

  testWidgets('hover activates the innermost box; off clears it', (
    tester,
  ) async {
    await pump(tester);
    container.read(developerModeProvider.notifier).set(true);
    await tester.pump();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.text('n=0')));
    await tester.pump();
    expect(RenderInspectable.active, same(box(tester, 'Inner')));

    await mouse.moveTo(
      tester.getTopLeft(find.byType(Inspectable).first) + const Offset(4, 4),
    );
    await tester.pump();
    expect(RenderInspectable.active, same(box(tester, 'Outer')));

    container.read(developerModeProvider.notifier).set(false);
    await tester.pump();
    expect(RenderInspectable.active, isNull);
  });
}
