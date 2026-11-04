import 'package:flutter/material.dart';

/// The palette. Widgets never read these directly: they go through
/// `Theme.of(context).colorScheme` or the [AppDecorations] extension.
abstract final class AppColors {
  // Brand: indigo primary, cyan accent.
  static const indigo50 = Color(0xFFEEF0FF);
  static const indigo200 = Color(0xFFC7CBFE);
  static const indigo400 = Color(0xFF8B92FA);
  static const indigo600 = Color(0xFF4F46E5);
  static const indigo800 = Color(0xFF312E81);
  static const indigo950 = Color(0xFF1A1745);
  static const cyan100 = Color(0xFFCFFAFE);
  static const cyan400 = Color(0xFF22D3EE);
  static const cyan700 = Color(0xFF0E7490);
  static const cyan900 = Color(0xFF164E63);
  static const cyan950 = Color(0xFF083344);

  // Neutrals: cool slate, so surfaces feel "engineered" rather than grey.
  static const slate0 = Color(0xFFFFFFFF);
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate150 = Color(0xFFE9EEF5);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate850 = Color(0xFF222A3B);
  static const slate900 = Color(0xFF1A2130);
  static const slate925 = Color(0xFF131926);
  static const slate950 = Color(0xFF0F141D);
  static const ink = Color(0xFF0B0F17);
  static const inkDeep = Color(0xFF070A10);
  static const text = Color(0xFF0F172A);

  // Status, tuned per brightness for contrast.
  static const successLight = Color(0xFF047857);
  static const successDark = Color(0xFF34D399);
  static const warningLight = Color(0xFFB45309);
  static const warningDark = Color(0xFFFBBF24);
  static const errorLight = Color(0xFFDC2626);
  static const errorDark = Color(0xFFF87171);

  static const light = ColorScheme(
    brightness: Brightness.light,
    primary: indigo600,
    onPrimary: slate0,
    primaryContainer: indigo50,
    onPrimaryContainer: indigo950,
    secondary: cyan700,
    onSecondary: slate0,
    secondaryContainer: cyan100,
    onSecondaryContainer: cyan950,
    tertiary: warningLight,
    onTertiary: slate0,
    error: errorLight,
    onError: slate0,
    surface: slate0,
    onSurface: text,
    onSurfaceVariant: slate600,
    surfaceContainerLowest: slate0,
    surfaceContainerLow: slate50,
    surfaceContainer: slate100,
    surfaceContainerHigh: slate150,
    surfaceContainerHighest: slate200,
    outline: slate300,
    outlineVariant: slate200,
    shadow: text,
    scrim: text,
    inverseSurface: slate800,
    onInverseSurface: slate100,
    inversePrimary: indigo200,
  );

  static const dark = ColorScheme(
    brightness: Brightness.dark,
    primary: indigo400,
    onPrimary: indigo950,
    primaryContainer: indigo800,
    onPrimaryContainer: indigo50,
    secondary: cyan400,
    onSecondary: cyan950,
    secondaryContainer: cyan900,
    onSecondaryContainer: cyan100,
    tertiary: warningDark,
    onTertiary: inkDeep,
    error: errorDark,
    onError: Color(0xFF450A0A),
    surface: ink,
    onSurface: slate200,
    onSurfaceVariant: slate400,
    surfaceContainerLowest: inkDeep,
    surfaceContainerLow: slate950,
    surfaceContainer: slate925,
    surfaceContainerHigh: slate900,
    surfaceContainerHighest: slate850,
    outline: slate700,
    outlineVariant: slate800,
    shadow: inkDeep,
    scrim: inkDeep,
    inverseSurface: slate200,
    onInverseSurface: slate800,
    inversePrimary: indigo600,
  );
}
