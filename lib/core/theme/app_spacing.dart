import 'package:flutter/widgets.dart';

/// 4px base grid (docs/DESIGN.md §4).
abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
  static const double s64 = 64;
  static const double s96 = 96;
  static const double s128 = 128;
  static const double s160 = 160;

  static const double maxContentWidth = 1280;

  /// Equal outer margin per width: 16 phone, 32 tablet, 48 desktop.
  static double margin(double width) => width < AppBreakpoints.mobile
      ? s16
      : width < AppBreakpoints.tablet
      ? s32
      : s48;

  /// Gap between page sections.
  static double section(double width) =>
      width < AppBreakpoints.mobile ? 80 : s128;
}

/// Mostly sharp: 0 for frames and images, 2 for controls, 4 at most.
abstract final class AppRadius {
  static const double none = 0;
  static const double sm = 2;
  static const double md = 2;
  static const double lg = 4;
  static const double xl = 4;

  /// Kept for older call sites; the system has no pills.
  static const double pill = 4;
}

/// mobile < 600 <= tablet < 1024 <= desktop.
abstract final class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}

/// Motion tokens (docs/DESIGN.md §6). Use [of] so reduced motion zeroes them.
abstract final class AppMotion {
  static const snap = Duration(milliseconds: 120);
  static const measure = Duration(milliseconds: 200);
  static const settle = Duration(milliseconds: 240);
  static const curve = Cubic(0.2, 0, 0, 1);

  static Duration of(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;
}
