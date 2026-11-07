import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/core/theme/theme_tokens.dart';

abstract final class AppTheme {
  // Built once per (brightness, compact): app.dart asks again on every resize.
  static final _cache = <(Brightness, bool), ThemeData>{};

  /// [compact] shrinks display/headline sizes for mobile widths. [tokens]
  /// are the inspector's live overrides; those themes aren't cached.
  static ThemeData light({
    bool compact = false,
    ThemeTokens tokens = const ThemeTokens(),
  }) => tokens.isDefault
      ? _cache[(Brightness.light, compact)] ??= _build(
          AppColors.light,
          AppDecorations.light,
          compact,
          tokens,
        )
      : _build(AppColors.light, AppDecorations.light, compact, tokens);

  static ThemeData dark({
    bool compact = false,
    ThemeTokens tokens = const ThemeTokens(),
  }) => tokens.isDefault
      ? _cache[(Brightness.dark, compact)] ??= _build(
          AppColors.dark,
          AppDecorations.dark,
          compact,
          tokens,
        )
      : _build(AppColors.dark, AppDecorations.dark, compact, tokens);

  static ThemeData _build(
    ColorScheme scheme,
    AppDecorations deco,
    bool compact,
    ThemeTokens t,
  ) {
    final a = t.accent.colors(scheme.brightness);
    final s = scheme.copyWith(primary: a.text);
    final d = deco.copyWith(
      accent: a.fill,
      accentText: a.text,
      onAccent: a.on,
      space: t.space,
      typeScale: t.typeScale,
    );
    final base = AppTypography.textTheme(s, compact: compact);
    final text = t.typeScale == 1
        ? base
        : base.apply(fontSizeFactor: t.typeScale);
    final radius = BorderRadius.circular(t.radius);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.s24,
      vertical: AppSpacing.s16,
    );
    const minButton = Size(48, 48);
    final buttonShape = RoundedRectangleBorder(borderRadius: radius);
    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );
    // DESIGN.md §8: a 2px accent ring on focus, everywhere.
    final focusRing = BorderSide(color: d.accent, width: 2);
    WidgetStateProperty<BorderSide?> side(BorderSide? rest) =>
        WidgetStateProperty.resolveWith(
          (st) => st.contains(WidgetState.focused) ? focusRing : rest,
        );
    // Hover and press step the tone; nothing lifts, nothing ripples.
    WidgetStateProperty<Color?> overlay(Color on) =>
        WidgetStateProperty.resolveWith(
          (st) => st.contains(WidgetState.pressed)
              ? on.withValues(alpha: 0.14)
              : st.contains(WidgetState.hovered)
              ? on.withValues(alpha: 0.08)
              : st.contains(WidgetState.focused)
              ? on.withValues(alpha: 0.06)
              : null,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: s,
      scaffoldBackgroundColor: s.surface,
      canvasColor: s.surface,
      textTheme: text,
      extensions: [d],
      splashFactory: NoSplash.splashFactory,
      focusColor: d.accent.withValues(alpha: 0.12),
      hoverColor: s.onSurface.withValues(alpha: 0.06),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: d.accent,
        selectionColor: d.accent.withValues(alpha: 0.28),
        selectionHandleColor: d.accent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: s.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(side: BorderSide(color: d.rule)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: d.accent,
          foregroundColor: d.onAccent,
          elevation: 0,
          padding: buttonPadding,
          minimumSize: minButton,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ).copyWith(side: side(null), overlayColor: overlay(d.onAccent)),
      ),
      // Primary action: accent fill, ink text (4.7:1 light, 6.2:1 dark).
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: d.accent,
          foregroundColor: d.onAccent,
          disabledBackgroundColor: s.surfaceContainerHigh,
          padding: buttonPadding,
          minimumSize: minButton,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ).copyWith(side: side(null), overlayColor: overlay(d.onAccent)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              foregroundColor: s.onSurface,
              padding: buttonPadding,
              minimumSize: minButton,
              shape: buttonShape,
              textStyle: text.labelLarge,
            ).copyWith(
              side: side(BorderSide(color: d.ruleStrong)),
              overlayColor: overlay(s.onSurface),
            ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: d.accentText,
          minimumSize: const Size(48, 48),
          shape: buttonShape,
          textStyle: text.labelLarge,
        ).copyWith(side: side(null), overlayColor: overlay(s.onSurface)),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: s.onSurface,
          minimumSize: const Size(48, 48),
          shape: buttonShape,
        ).copyWith(side: side(null), overlayColor: overlay(s.onSurface)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.surfaceContainerLowest,
        border: inputBorder(s.outline),
        enabledBorder: inputBorder(s.outline),
        focusedBorder: inputBorder(d.accent, 2),
        errorBorder: inputBorder(s.error),
        focusedErrorBorder: inputBorder(s.error, 2),
        labelStyle: text.bodyMedium?.copyWith(color: s.onSurfaceVariant),
        hintStyle: text.bodyMedium?.copyWith(color: s.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: s.surface,
        selectedColor: s.onSurface,
        labelStyle: text.labelMedium,
        secondaryLabelStyle: text.labelMedium?.copyWith(color: s.surface),
        side: BorderSide(color: s.outline),
        shape: RoundedRectangleBorder(borderRadius: radius),
        showCheckmark: false,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: s.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: s.surface,
        indicatorColor: s.primaryContainer,
        indicatorShape: RoundedRectangleBorder(borderRadius: radius),
        surfaceTintColor: Colors.transparent,
      ),
      listTileTheme: ListTileThemeData(
        selectedColor: d.accentText,
        selectedTileColor: s.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: s.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: s.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      dividerTheme: DividerThemeData(color: d.rule, thickness: 1, space: 1),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: s.inverseSurface,
          borderRadius: radius,
        ),
        textStyle: text.labelSmall?.copyWith(color: s.onInverseSurface),
        waitDuration: const Duration(milliseconds: 400),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: s.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        thumbColor: WidgetStateProperty.resolveWith(
          (st) => st.contains(WidgetState.selected) ? d.onAccent : s.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (st) => st.contains(WidgetState.selected)
              ? d.accent
              : s.surfaceContainerHigh,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: d.accent,
        inactiveTrackColor: d.rule,
        thumbColor: d.accent,
        overlayColor: d.accent.withValues(alpha: 0.16),
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
    );
  }
}
