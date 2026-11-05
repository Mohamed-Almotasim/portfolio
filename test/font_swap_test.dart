import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/app_typography.dart';

import 'helpers/pump_app.dart';

List<double> _rowHeights(WidgetTester tester) => tester
    .renderObjectList<RenderBox>(find.byType(IntrinsicHeight))
    .map((b) => b.size.height)
    .toList();

// main() no longer waits for fonts before runApp, so the first layout uses a
// fallback font. Grid rows must re-measure once the real fonts arrive.
void main() {
  testWidgets('grid rows resize when fonts load after the first layout', (
    tester,
  ) async {
    await pumpApp(tester, path: '/services');
    final fallback = _rowHeights(tester);
    await tester.runAsync(preloadFonts);
    await settle(tester);
    final swapped = _rowHeights(tester);

    await tester.pumpWidget(const SizedBox());
    await pumpApp(tester, path: '/services');
    expect(fallback, isNot(swapped), reason: 'fonts should change layout');
    expect(swapped, _rowHeights(tester));
  });
}
