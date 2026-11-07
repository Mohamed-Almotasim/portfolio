// Renders routes to PNG in dark and light, for docs and visual checks. Opt-in:
//   SHOT_DIR=out SHOT_PATHS="/,/work" SHOT_W=1280 SHOT_H=900 [SHOT_DEV=1] \
//     [SHOT_HOVER=x,y] [SHOT_SELECT=x,y] \
//     flutter test test/tool/screenshots_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/state/theme_mode_provider.dart';
import 'package:portfolio/core/theme/app_typography.dart';

class _Dev extends DeveloperModeNotifier {
  @override
  bool build() => true;
}

// Default follows the OS (light in tests), so both modes are explicit.
class _Dark extends ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.dark;
}

class _Light extends ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.light;
}

void main() {
  final out = Platform.environment['SHOT_DIR'];
  if (out == null) return; // only runs when asked for screenshots
  setUpAll(() async {
    await preloadFonts();
    final dir =
        '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
    final icons = FontLoader('MaterialIcons')
      ..addFont(
        Future.value(
          ByteData.sublistView(
            File('$dir/MaterialIcons-Regular.otf').readAsBytesSync(),
          ),
        ),
      );
    await icons.load();
  });

  final paths = (Platform.environment['SHOT_PATHS'] ?? '/').split(',');
  final width = double.parse(Platform.environment['SHOT_W'] ?? '1280');
  for (final light in [false, true]) {
    for (final path in paths) {
      testWidgets('shot $path light=$light', (tester) async {
        tester.view.physicalSize = Size(
          width,
          double.parse(Platform.environment['SHOT_H'] ?? '2200'),
        );
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: ProviderScope(
              overrides: [
                routerProvider.overrideWithValue(
                  createRouter(initialLocation: path),
                ),
                themeModeProvider.overrideWith(light ? _Light.new : _Dark.new),
                if (Platform.environment['SHOT_DEV'] != null)
                  developerModeProvider.overrideWith(_Dev.new),
              ],
              child: const PortfolioApp(),
            ),
          ),
        );
        if (Platform.environment['SHOT_DEV'] != null) {
          await tester.pump();
          final show = find.text('Show code');
          if (show.evaluate().isNotEmpty) await tester.tap(show.first);
          // SHOT_HOVER=x,y parks a mouse there, e.g. to show an inspector tag.
          final hover = Platform.environment['SHOT_HOVER']?.split(',');
          if (hover != null) {
            final mouse = await tester.createGesture(
              kind: PointerDeviceKind.mouse,
            );
            addTearDown(mouse.removePointer);
            await mouse.moveTo(
              Offset(double.parse(hover[0]), double.parse(hover[1])),
            );
          }
          // SHOT_SELECT=x,y clicks there, opening the inspector panel.
          final select = Platform.environment['SHOT_SELECT']?.split(',');
          if (select != null) {
            await tester.pump(const Duration(seconds: 1));
            await tester.tapAt(
              Offset(double.parse(select[0]), double.parse(select[1])),
            );
          }
        }
        for (var i = 0; i < 20; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 50)),
          );
          await tester.pump(const Duration(milliseconds: 200));
        }
        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final name = path == '/'
              ? 'home'
              : path.substring(1).replaceAll(RegExp(r'[/?=]'), '_');
          File(
            '$out/${name}_${width.toInt()}_${light ? 'light' : 'dark'}.png',
          ).writeAsBytesSync(bytes!.buffer.asUint8List());
        });
      });
    }
  }
}
