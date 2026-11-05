// Regenerates the web icons (favicon, PWA icons) as a monogram of
// Profile.name. Opt-in, because it writes into web/:
//
//   GENERATE_ICONS=1 flutter test test/tool/generate_icons_test.dart
//
// Run it again after changing your name in portfolio_content.dart.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/content/portfolio_content.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/shared/widgets/brand_logo.dart';

void main() {
  if (Platform.environment['GENERATE_ICONS'] == null) return;

  setUpAll(preloadFonts);

  // (file, size, maskable). Maskable icons keep the glyph in the 80% safe zone.
  const icons = [
    ('web/favicon.png', 48.0, false),
    ('web/icons/Icon-192.png', 192.0, false),
    ('web/icons/Icon-512.png', 512.0, false),
    ('web/icons/Icon-maskable-192.png', 192.0, true),
    ('web/icons/Icon-maskable-512.png', 512.0, true),
  ];

  for (final (path, size, maskable) in icons) {
    testWidgets('icon $path', (tester) async {
      tester.view.physicalSize = Size(size, size);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RepaintBoundary(
            key: key,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.indigo600,
                borderRadius: maskable
                    ? null
                    : BorderRadius.circular(size * 0.22),
              ),
              child: Text(
                BrandLogo.initials(profile.name),
                style: AppTypography.textTheme(AppColors.dark, compact: false)
                    .displayLarge
                    ?.copyWith(
                      color: AppColors.slate0,
                      fontSize: size * (maskable ? 0.34 : 0.42),
                      letterSpacing: 0,
                    ),
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pump();
      }
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File(path).writeAsBytesSync(png!.buffer.asUint8List());
      });
    });
  }
}
