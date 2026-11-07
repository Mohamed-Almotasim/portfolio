import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Theme values ColorScheme has no slot for (docs/DESIGN.md §2, §5).
/// Read with [of].
@immutable
class AppDecorations extends ThemeExtension<AppDecorations> {
  const AppDecorations({
    required this.cardBorder,
    required this.rule,
    required this.ruleStrong,
    required this.inkMute,
    required this.accent,
    required this.accentText,
    required this.onAccent,
    required this.codeBackground,
    required this.codeForeground,
    required this.deviceBezel,
    required this.success,
    required this.warning,
    required this.shadowSoft,
    required this.shadowElevated,
    this.space = 1,
    this.typeScale = 1,
  });

  /// Hairline around framed things; same value as [rule].
  final Color cardBorder;

  /// 1px hairline between two real regions.
  final Color rule;

  /// Full-ink rule: title block edges, register header.
  final Color ruleStrong;

  /// Secondary metadata only, never running text.
  final Color inkMute;

  /// The one accent as a fill or a line (3:1 against the ground).
  final Color accent;

  /// The accent as text (4.5:1 against the ground).
  final Color accentText;

  /// Text and icons on an [accent] fill.
  final Color onAccent;

  final Color codeBackground;
  final Color codeForeground;
  final Color deviceBezel;
  final Color success;
  final Color warning;

  /// Shadows are only for things that really float: menus, dialogs, tags.
  final List<BoxShadow> shadowSoft;
  final List<BoxShadow> shadowElevated;

  /// Inspector token overrides (1 = as designed): section rhythm, and type
  /// sizes set outside the TextTheme, like the hero statement.
  final double space;
  final double typeScale;

  static AppDecorations of(BuildContext context) =>
      Theme.of(context).extension<AppDecorations>()!;

  static final light = AppDecorations(
    cardBorder: AppColors.paperRule,
    rule: AppColors.paperRule,
    ruleStrong: AppColors.ink,
    inkMute: AppColors.inkMute,
    accent: AppColors.orange,
    accentText: AppColors.orangeText,
    onAccent: AppColors.ink,
    codeBackground: AppColors.night,
    codeForeground: AppColors.nightInk,
    deviceBezel: AppColors.ink,
    success: AppColors.successLight,
    warning: AppColors.warningLight,
    shadowSoft: [
      BoxShadow(
        color: AppColors.ink.withValues(alpha: 0.10),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
    shadowElevated: [
      BoxShadow(
        color: AppColors.ink.withValues(alpha: 0.14),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static final dark = AppDecorations(
    cardBorder: AppColors.nightRule,
    rule: AppColors.nightRule,
    ruleStrong: AppColors.nightInk,
    inkMute: AppColors.nightMute,
    accent: AppColors.orangeNight,
    accentText: AppColors.orangeNight,
    onAccent: AppColors.night,
    codeBackground: AppColors.nightLowest,
    codeForeground: AppColors.nightInk,
    deviceBezel: AppColors.nightLowest,
    success: AppColors.successDark,
    warning: AppColors.warningDark,
    shadowSoft: [
      BoxShadow(
        color: AppColors.nightLowest.withValues(alpha: 0.6),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
    shadowElevated: [
      BoxShadow(
        color: AppColors.nightLowest.withValues(alpha: 0.7),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );

  @override
  AppDecorations copyWith({
    Color? cardBorder,
    Color? rule,
    Color? ruleStrong,
    Color? inkMute,
    Color? accent,
    Color? accentText,
    Color? onAccent,
    Color? codeBackground,
    Color? codeForeground,
    Color? deviceBezel,
    Color? success,
    Color? warning,
    List<BoxShadow>? shadowSoft,
    List<BoxShadow>? shadowElevated,
    double? space,
    double? typeScale,
  }) {
    return AppDecorations(
      cardBorder: cardBorder ?? this.cardBorder,
      rule: rule ?? this.rule,
      ruleStrong: ruleStrong ?? this.ruleStrong,
      inkMute: inkMute ?? this.inkMute,
      accent: accent ?? this.accent,
      accentText: accentText ?? this.accentText,
      onAccent: onAccent ?? this.onAccent,
      codeBackground: codeBackground ?? this.codeBackground,
      codeForeground: codeForeground ?? this.codeForeground,
      deviceBezel: deviceBezel ?? this.deviceBezel,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      shadowSoft: shadowSoft ?? this.shadowSoft,
      shadowElevated: shadowElevated ?? this.shadowElevated,
      space: space ?? this.space,
      typeScale: typeScale ?? this.typeScale,
    );
  }

  @override
  AppDecorations lerp(AppDecorations? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppDecorations(
      cardBorder: c(cardBorder, other.cardBorder),
      rule: c(rule, other.rule),
      ruleStrong: c(ruleStrong, other.ruleStrong),
      inkMute: c(inkMute, other.inkMute),
      accent: c(accent, other.accent),
      accentText: c(accentText, other.accentText),
      onAccent: c(onAccent, other.onAccent),
      codeBackground: c(codeBackground, other.codeBackground),
      codeForeground: c(codeForeground, other.codeForeground),
      deviceBezel: c(deviceBezel, other.deviceBezel),
      success: c(success, other.success),
      warning: c(warning, other.warning),
      shadowSoft: BoxShadow.lerpList(shadowSoft, other.shadowSoft, t)!,
      shadowElevated: BoxShadow.lerpList(
        shadowElevated,
        other.shadowElevated,
        t,
      )!,
      space: lerpDouble(space, other.space, t)!,
      typeScale: lerpDouble(typeScale, other.typeScale, t)!,
    );
  }
}
