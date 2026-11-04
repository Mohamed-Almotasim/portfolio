import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Space Grotesk for display/headlines, Inter for everything else.
/// Font files are bundled in assets/google_fonts/, so nothing hits the network.
abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme scheme, {required bool compact}) {
    TextStyle display(double size, double desktopSize, FontWeight weight) =>
        GoogleFonts.spaceGrotesk(
          fontSize: compact ? size : desktopSize,
          fontWeight: weight,
          height: 1.1,
          letterSpacing: -0.02 * (compact ? size : desktopSize),
        );
    TextStyle body(double size, FontWeight weight, {double height = 1.5}) =>
        GoogleFonts.inter(fontSize: size, fontWeight: weight, height: height);

    return TextTheme(
      displayLarge: display(44, 64, FontWeight.w700),
      displayMedium: display(36, 48, FontWeight.w700),
      displaySmall: display(30, 40, FontWeight.w600),
      headlineLarge: display(28, 34, FontWeight.w600),
      headlineMedium: display(24, 28, FontWeight.w600),
      headlineSmall: display(20, 24, FontWeight.w600),
      titleLarge: body(20, FontWeight.w600, height: 1.3),
      titleMedium: body(16, FontWeight.w600, height: 1.4),
      titleSmall: body(14, FontWeight.w600, height: 1.4),
      bodyLarge: body(16, FontWeight.w400, height: 1.6),
      bodyMedium: body(14, FontWeight.w400),
      bodySmall: body(12, FontWeight.w400),
      labelLarge: body(14, FontWeight.w600, height: 1.2),
      labelMedium: body(12, FontWeight.w500, height: 1.2),
      labelSmall: body(11, FontWeight.w500, height: 1.2),
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
  }

  static TextStyle code(Color color) =>
      GoogleFonts.jetBrainsMono(fontSize: 13, height: 1.6, color: color);
}
