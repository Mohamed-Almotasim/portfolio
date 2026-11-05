import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';

abstract final class AppTheme {
  // Built once per (brightness, compact): app.dart asks again on every resize.
  static final _cache = <(Brightness, bool), ThemeData>{};

  /// [compact] shrinks display/headline sizes for mobile widths.
  static ThemeData light({bool compact = false}) =>
      _cache[(Brightness.light, compact)] ??= _build(
        AppColors.light,
        AppDecorations.light,
        compact,
      );

  static ThemeData dark({bool compact = false}) =>
      _cache[(Brightness.dark, compact)] ??= _build(
        AppColors.dark,
        AppDecorations.dark,
        compact,
      );

  static ThemeData _build(ColorScheme s, AppDecorations d, bool compact) {
    final text = AppTypography.textTheme(s, compact: compact);
    final radius = BorderRadius.circular(AppRadius.md);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.s24,
      vertical: AppSpacing.s16,
    );
    final buttonShape = RoundedRectangleBorder(borderRadius: radius);
    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: s,
      scaffoldBackgroundColor: s.brightness == Brightness.dark
          ? s.surface
          : s.surfaceContainerLow,
      textTheme: text,
      extensions: [d],
      splashFactory: InkSparkle.splashFactory,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: s.primary,
        selectionColor: s.primary.withValues(alpha: 0.28),
        selectionHandleColor: s.primary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: s.shadow.withValues(alpha: 0.4),
        color: s.surface,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.all(AppSpacing.s8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: d.cardBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: s.primary,
          foregroundColor: s.onPrimary,
          elevation: 0,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: s.onSurface,
          side: BorderSide(color: s.outline),
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: s.primary,
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.surfaceContainerLow,
        border: inputBorder(s.outline),
        enabledBorder: inputBorder(s.outline),
        focusedBorder: inputBorder(s.primary, 1.5),
        errorBorder: inputBorder(s.error),
        focusedErrorBorder: inputBorder(s.error, 1.5),
        labelStyle: text.bodyMedium?.copyWith(color: s.onSurfaceVariant),
        hintStyle: text.bodyMedium?.copyWith(color: s.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: s.surface,
        selectedColor: s.primaryContainer,
        side: BorderSide(color: s.outlineVariant),
        shape: const StadiumBorder(),
        labelStyle: text.labelMedium,
        showCheckmark: false,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: s.surface,
        surfaceTintColor: Colors.transparent,
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: s.surface,
        indicatorColor: s.primaryContainer,
        surfaceTintColor: Colors.transparent,
      ),
      listTileTheme: ListTileThemeData(
        selectedColor: s.primary,
        selectedTileColor: s.primaryContainer.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: s.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: s.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      dividerTheme: DividerThemeData(
        color: s.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: s.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: text.bodySmall?.copyWith(color: s.onInverseSurface),
        waitDuration: const Duration(milliseconds: 400),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: s.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
