import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/features/playground/playground_page.dart';
import 'package:portfolio/features/widget_gallery/pattern_card.dart';
import 'package:portfolio/shared/demo/demo_component.dart';

Future<GoRouterHolder> pumpRoute(WidgetTester tester, String path) async {
  tester.view.physicalSize = const Size(1280, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = createRouter(initialLocation: path);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [routerProvider.overrideWithValue(router)],
      child: const PortfolioApp(),
    ),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  return GoRouterHolder(router.routerDelegate.currentConfiguration.uri);
}

class GoRouterHolder {
  GoRouterHolder(this.uri);
  final Uri uri;
}

void main() {
  testWidgets('/playground opens on the Components tab', (tester) async {
    await pumpRoute(tester, AppRoutes.playground);
    expect(find.byType(PlaygroundPage), findsOneWidget);
    expect(find.byType(DemoComponent), findsWidgets);
    expect(find.byType(PatternCard), findsNothing);
  });

  testWidgets('?tab=patterns opens the Patterns tab', (tester) async {
    await pumpRoute(tester, AppRoutes.playgroundPatterns);
    expect(find.byType(PatternCard), findsWidgets);
    expect(find.byType(DemoComponent), findsNothing);
  });

  testWidgets('old /ui-showcase URL redirects to the playground', (
    tester,
  ) async {
    final at = await pumpRoute(tester, AppRoutes.uiShowcase);
    expect(at.uri.path, AppRoutes.playground);
    expect(find.byType(DemoComponent), findsWidgets);
  });

  testWidgets('old /widget-gallery URL redirects to the Patterns tab', (
    tester,
  ) async {
    final at = await pumpRoute(tester, AppRoutes.widgetGallery);
    expect(at.uri.toString(), AppRoutes.playgroundPatterns);
    expect(find.byType(PatternCard), findsWidgets);
  });

  testWidgets('tapping the Patterns tab switches content', (tester) async {
    await pumpRoute(tester, AppRoutes.playground);
    await tester.tap(find.widgetWithText(Tab, 'Patterns'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.byType(PatternCard), findsWidgets);
  });
}
