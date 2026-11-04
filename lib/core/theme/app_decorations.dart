import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Theme values ColorScheme has no slot for.
/// Read with `Theme.of(context).extension<AppDecorations>()!` or [of].
@immutable
class AppDecorations extends ThemeExtension<AppDecorations> {
  const AppDecorations({
    required this.cardBorder,
    required this.subtleGradient,
    required this.glassSurface,
    required this.codeBackground,
    required this.codeForeground,
    required this.deviceBezel,
    required this.success,
    required this.warning,
    required this.shadowSoft,
    required this.shadowElevated,
  });

  final Color cardBorder;
  final Gradient subtleGradient;
  final Color glassSurface;
  final Color codeBackground;
  final Color codeForeground;
  final Color deviceBezel;
  final Color success;
  final Color warning;
  final List<BoxShadow> shadowSoft;
  final List<BoxShadow> shadowElevated;

  static AppDecorations of(BuildContext context) =>
      Theme.of(context).extension<AppDecorations>()!;

  static final light = AppDecorations(
    cardBorder: AppColors.slate200,
    subtleGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.indigo600.withValues(alpha: 0.06),
        AppColors.cyan700.withValues(alpha: 0.04),
      ],
    ),
    glassSurface: AppColors.slate0.withValues(alpha: 0.72),
    codeBackground: AppColors.slate800,
    codeForeground: AppColors.slate200,
    deviceBezel: AppColors.slate800,
    success: AppColors.successLight,
    warning: AppColors.warningLight,
    shadowSoft: [
      BoxShadow(
        color: AppColors.text.withValues(alpha: 0.06),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
    shadowElevated: [
      BoxShadow(
        color: AppColors.text.withValues(alpha: 0.12),
        blurRadius: 32,
        offset: const Offset(0, 16),
      ),
    ],
  );

  static final dark = AppDecorations(
    cardBorder: AppColors.slate800,
    subtleGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.indigo400.withValues(alpha: 0.10),
        AppColors.cyan400.withValues(alpha: 0.05),
      ],
    ),
    glassSurface: AppColors.ink.withValues(alpha: 0.72),
    codeBackground: AppColors.inkDeep,
    codeForeground: AppColors.slate200,
    deviceBezel: AppColors.inkDeep,
    success: AppColors.successDark,
    warning: AppColors.warningDark,
    shadowSoft: [
      BoxShadow(
        color: AppColors.inkDeep.withValues(alpha: 0.5),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
    shadowElevated: [
      BoxShadow(
        color: AppColors.inkDeep.withValues(alpha: 0.7),
        blurRadius: 32,
        offset: const Offset(0, 16),
      ),
    ],
  );

  @override
  AppDecorations copyWith({
    Color? cardBorder,
    Gradient? subtleGradient,
    Color? glassSurface,
    Color? codeBackground,
    Color? codeForeground,
    Color? deviceBezel,
    Color? success,
    Color? warning,
    List<BoxShadow>? shadowSoft,
    List<BoxShadow>? shadowElevated,
  }) {
    return AppDecorations(
      cardBorder: cardBorder ?? this.cardBorder,
      subtleGradient: subtleGradient ?? this.subtleGradient,
      glassSurface: glassSurface ?? this.glassSurface,
      codeBackground: codeBackground ?? this.codeBackground,
      codeForeground: codeForeground ?? this.codeForeground,
      deviceBezel: deviceBezel ?? this.deviceBezel,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      shadowSoft: shadowSoft ?? this.shadowSoft,
      shadowElevated: shadowElevated ?? this.shadowElevated,
    );
  }

  @override
  AppDecorations lerp(AppDecorations? other, double t) {
    if (other == null) return this;
    return AppDecorations(
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      subtleGradient: Gradient.lerp(subtleGradient, other.subtleGradient, t)!,
      glassSurface: Color.lerp(glassSurface, other.glassSurface, t)!,
      codeBackground: Color.lerp(codeBackground, other.codeBackground, t)!,
      codeForeground: Color.lerp(codeForeground, other.codeForeground, t)!,
      deviceBezel: Color.lerp(deviceBezel, other.deviceBezel, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      shadowSoft: BoxShadow.lerpList(shadowSoft, other.shadowSoft, t)!,
      shadowElevated: BoxShadow.lerpList(
        shadowElevated,
        other.shadowElevated,
        t,
      )!,
    );
  }
}
