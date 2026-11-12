import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/theme/app_decorations.dart';

/// Drafting set (docs/DESIGN.md §3): Archivo Expanded for display, IBM Plex
/// Sans for text, IBM Plex Mono for labels, metadata, nav and code.
/// Files are bundled in assets/google_fonts/, so nothing hits the network.
abstract final class AppTypography {
  /// Not exposed by google_fonts (width axis), so loaded by [preloadFonts].
  static const displayFamily = 'ArchivoExpanded';
  static const _displayAsset =
      'assets/google_fonts/ArchivoExpanded-SemiBold.ttf';

  static const _tabular = [FontFeature.tabularFigures()];

  /// [arabic] sets every style in IBM Plex Sans Arabic: no tracking (the
  /// script is joined) and taller lines (marks above and below the letters).
  static TextTheme textTheme(
    ColorScheme scheme, {
    required bool compact,
    bool arabic = false,
  }) {
    if (arabic) {
      TextStyle ar(double size, FontWeight weight, double height) =>
          GoogleFonts.ibmPlexSansArabic(
            fontSize: size,
            fontWeight: weight,
            height: height,
            fontFeatures: _tabular,
          );
      TextStyle display(double size, double desktopSize) =>
          ar(compact ? size : desktopSize, FontWeight.w600, 1.3);
      TextStyle text(double size, FontWeight weight) => ar(size, weight, 1.7);
      return TextTheme(
        displayLarge: display(44, 88),
        displayMedium: display(36, 64),
        displaySmall: display(32, 48),
        headlineLarge: display(28, 40),
        headlineMedium: display(24, 32),
        headlineSmall: display(20, 24),
        titleLarge: ar(20, FontWeight.w600, 1.5),
        titleMedium: ar(17, FontWeight.w600, 1.6),
        titleSmall: ar(15, FontWeight.w600, 1.6),
        bodyLarge: text(compact ? 16 : 17, FontWeight.w400),
        bodyMedium: text(15, FontWeight.w400),
        bodySmall: text(13, FontWeight.w400),
        labelLarge: ar(14, FontWeight.w500, 1.5),
        labelMedium: ar(13, FontWeight.w400, 1.5),
        labelSmall: ar(12, FontWeight.w400, 1.5),
      ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
    }

    TextStyle display(double size, double desktopSize, {double height = 1}) {
      final s = compact ? size : desktopSize;
      return TextStyle(
        fontFamily: displayFamily,
        fontWeight: FontWeight.w600,
        fontSize: s,
        height: height,
        letterSpacing: -0.03 * s,
      );
    }

    TextStyle text(double size, FontWeight weight, {double height = 1.55}) =>
        GoogleFonts.ibmPlexSans(
          fontSize: size,
          fontWeight: weight,
          height: height,
        );
    TextStyle mono(double size, {FontWeight weight = FontWeight.w400}) =>
        GoogleFonts.ibmPlexMono(
          fontSize: size,
          fontWeight: weight,
          height: 1.35,
          letterSpacing: 0.02 * size,
          fontFeatures: _tabular,
        );

    return TextTheme(
      // `display` token.
      displayLarge: display(44, 88, height: 0.95),
      displayMedium: display(36, 64, height: 0.98),
      displaySmall: display(32, 48),
      // `heading` token.
      headlineLarge: display(28, 40, height: 1.05),
      headlineMedium: display(24, 32, height: 1.08),
      headlineSmall: display(20, 24, height: 1.12),
      titleLarge: text(20, FontWeight.w600, height: 1.3),
      titleMedium: text(17, FontWeight.w600, height: 1.4),
      titleSmall: text(15, FontWeight.w600, height: 1.4),
      // `body` token.
      bodyLarge: text(compact ? 16 : 17, FontWeight.w400),
      bodyMedium: text(15, FontWeight.w400, height: 1.5),
      bodySmall: text(13, FontWeight.w400, height: 1.45),
      // `label` token: mono, sentence case, tabular figures.
      labelLarge: mono(14, weight: FontWeight.w500),
      labelMedium: mono(13),
      labelSmall: mono(12),
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      // Arabic words in the English theme (and mid language switch) get real
      // glyphs instead of empty boxes.
      fontFamilyFallback: [GoogleFonts.ibmPlexSansArabic().fontFamily!],
    );
  }

  /// `lead` token: the one supporting sentence under a headline.
  static TextStyle lead(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final theme = Theme.of(context);
    final scale = theme.extension<AppDecorations>()?.typeScale ?? 1;
    return theme.textTheme.bodyLarge!.copyWith(
      fontSize: (compact ? 19 : 22) * scale,
      height: 1.45,
    );
  }

  static TextStyle code(Color color) => GoogleFonts.ibmPlexMono(
    fontSize: 13,
    height: 1.6,
    color: color,
    fontFeatures: _tabular,
  );
}

/// Loads every bundled face [AppTypography] uses; main() keeps the HTML
/// splash up until this completes. Only these files are bundled.
Future<void> preloadFonts() {
  for (final w in [FontWeight.w400, FontWeight.w600]) {
    GoogleFonts.ibmPlexSans(fontWeight: w);
  }
  for (final w in [FontWeight.w400, FontWeight.w500]) {
    GoogleFonts.ibmPlexMono(fontWeight: w);
  }
  // Arabic too, so a language switch never shows fallback glyphs.
  for (final w in [FontWeight.w400, FontWeight.w500, FontWeight.w600]) {
    GoogleFonts.ibmPlexSansArabic(fontWeight: w);
  }
  final display = FontLoader(AppTypography.displayFamily)
    ..addFont(rootBundle.load(AppTypography._displayAsset));
  return Future.wait([GoogleFonts.pendingFonts(), display.load()]);
}
