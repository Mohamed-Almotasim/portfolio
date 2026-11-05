import 'package:flutter/material.dart';

/// The Inspector palette (docs/DESIGN.md §2). Widgets never read these
/// directly: they go through `Theme.of(context).colorScheme` or
/// [AppDecorations]. Contrast ratios in comments are WCAG, against the ground.
abstract final class AppColors {
  // Paper (light).
  static const paper = Color(0xFFF4F1EA);
  static const paperRaised = Color(0xFFFAF8F3);
  static const paper2 = Color(0xFFECE8DE);
  static const paper3 = Color(0xFFE5E0D4);
  static const paper4 = Color(0xFFDDD7C9);
  static const ink = Color(0xFF16150F); // 16.2:1
  static const inkMute = Color(0xFF5C5A52); // 6.1:1
  static const paperRule = Color(0xFFD5D2CB); // ink at 14%
  static const paperOutline = Color(0xFF85837D); // 3.4:1, input borders

  // Night blueprint (dark).
  static const night = Color(0xFF0E1A22);
  static const nightLowest = Color(0xFF0A141A);
  static const night2 = Color(0xFF14232D);
  static const night3 = Color(0xFF1B2D39);
  static const night4 = Color(0xFF233745);
  static const nightInk = Color(0xFFE6E2D6); // 13.6:1
  static const nightMute = Color(0xFF93A0A6); // 6.6:1
  static const nightRule = Color(0xFF313A3F);
  static const nightOutline = Color(0xFF7E8280); // 4.5:1

  // Signal orange: fill/line on paper, text on paper, everything on night.
  static const orange = Color(0xFFEB4700); // 3.4:1 line; ink on it 4.7:1
  static const orangeText = Color(0xFFB83A00); // 5.1:1
  static const orangeNight = Color(0xFFFF6A2B); // 6.2:1; night on it 6.2:1
  static const orangeTint = Color(0xFFF3DDCE);
  static const orangeTintNight = Color(0xFF352723);

  // Status, tuned per ground for 4.5:1.
  static const successLight = Color(0xFF1E6B35);
  static const successDark = Color(0xFF7FD08F);
  static const warningLight = Color(0xFF8A5A00);
  static const warningDark = Color(0xFFE0B04A);
  static const errorLight = Color(0xFFB42318);
  static const errorDark = Color(0xFFFF8A7A);

  // Code blocks stay night in both themes (CodeSyntax is tuned for night).
  static const codeBlue = Color(0xFF8FB8DE);

  static const light = ColorScheme(
    brightness: Brightness.light,
    // Text-safe orange, so every `primary` used as text passes AA. Filled
    // buttons use the brighter fill via the button theme.
    primary: orangeText,
    onPrimary: paperRaised,
    primaryContainer: orangeTint,
    onPrimaryContainer: ink,
    secondary: inkMute,
    onSecondary: paperRaised,
    secondaryContainer: paper3,
    onSecondaryContainer: ink,
    tertiary: warningLight,
    onTertiary: paperRaised,
    error: errorLight,
    onError: paperRaised,
    surface: paper,
    onSurface: ink,
    onSurfaceVariant: inkMute,
    surfaceContainerLowest: paperRaised,
    surfaceContainerLow: paper2,
    surfaceContainer: paper2,
    surfaceContainerHigh: paper3,
    surfaceContainerHighest: paper4,
    outline: paperOutline,
    outlineVariant: paperRule,
    shadow: ink,
    scrim: ink,
    inverseSurface: night,
    onInverseSurface: nightInk,
    inversePrimary: orangeNight,
  );

  static const dark = ColorScheme(
    brightness: Brightness.dark,
    primary: orangeNight,
    onPrimary: night,
    primaryContainer: orangeTintNight,
    onPrimaryContainer: nightInk,
    secondary: nightMute,
    onSecondary: night,
    secondaryContainer: night3,
    onSecondaryContainer: nightInk,
    tertiary: warningDark,
    onTertiary: night,
    error: errorDark,
    onError: night,
    surface: night,
    onSurface: nightInk,
    onSurfaceVariant: nightMute,
    surfaceContainerLowest: nightLowest,
    surfaceContainerLow: night2,
    surfaceContainer: night2,
    surfaceContainerHigh: night3,
    surfaceContainerHighest: night4,
    outline: nightOutline,
    outlineVariant: nightRule,
    shadow: nightLowest,
    scrim: nightLowest,
    inverseSurface: paper,
    onInverseSurface: ink,
    inversePrimary: orangeText,
  );
}
