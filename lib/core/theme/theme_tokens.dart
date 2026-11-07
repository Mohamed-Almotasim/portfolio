import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// The three accent options from docs/DESIGN.md §2 (as briefed), each as
/// (fill/line, text, on-fill) per theme.
enum AccentOption {
  orange('Signal orange'),
  chartreuse('Acid chartreuse'),
  red('Signal red');

  const AccentOption(this.label);

  final String label;

  ({Color fill, Color text, Color on}) colors(Brightness b) =>
      switch ((this, b)) {
        (orange, Brightness.light) => (
          fill: AppColors.orange,
          text: AppColors.orangeText,
          on: AppColors.ink,
        ),
        (orange, Brightness.dark) => (
          fill: AppColors.orangeNight,
          text: AppColors.orangeNight,
          on: AppColors.night,
        ),
        // Chartreuse can't draw a 3:1 line on paper, so paper uses its olive.
        (chartreuse, Brightness.light) => (
          fill: AppColors.olive,
          text: AppColors.olive,
          on: AppColors.paperRaised,
        ),
        (chartreuse, Brightness.dark) => (
          fill: AppColors.chartreuse,
          text: AppColors.chartreuse,
          on: AppColors.night,
        ),
        (red, Brightness.light) => (
          fill: AppColors.red,
          text: AppColors.redText,
          on: AppColors.paperRaised,
        ),
        (red, Brightness.dark) => (
          fill: AppColors.redNight,
          text: AppColors.redNight,
          on: AppColors.night,
        ),
      };
}

/// Live token overrides from the inspector's Tokens tab. Never saved.
@immutable
class ThemeTokens {
  const ThemeTokens({
    this.accent = AccentOption.orange,
    this.space = 1,
    this.radius = AppRadius.sm,
    this.typeScale = 1,
  });

  final AccentOption accent;

  /// Multiplies section rhythm.
  final double space;

  /// Control radius (buttons, inputs, chips).
  final double radius;

  /// Multiplies every type size.
  final double typeScale;

  bool get isDefault => this == const ThemeTokens();

  ThemeTokens copyWith({
    AccentOption? accent,
    double? space,
    double? radius,
    double? typeScale,
  }) => ThemeTokens(
    accent: accent ?? this.accent,
    space: space ?? this.space,
    radius: radius ?? this.radius,
    typeScale: typeScale ?? this.typeScale,
  );

  (AccentOption, double, double, double) get _key =>
      (accent, space, radius, typeScale);

  @override
  bool operator ==(Object other) => other is ThemeTokens && other._key == _key;

  @override
  int get hashCode => _key.hashCode;
}
