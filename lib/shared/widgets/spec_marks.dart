import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';

/// Spec-sheet marks from docs/DESIGN.md §5. Purely decorative: excluded
/// from semantics, never hit-tested.

/// Ruler ticks along a top edge: minor 4px every 8, major 8px every 64,
/// with a mono label every 128.
class Ruler extends StatelessWidget {
  const Ruler({super.key});

  static const double height = 20;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _RulerPainter(
            color: deco.inkMute,
            label: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(color: deco.inkMute, fontSize: 10),
          ),
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  _RulerPainter({required this.color, required this.label});

  final Color color;
  final TextStyle label;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = color
      ..strokeWidth = 1;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), line);
    for (var x = 0.0; x <= size.width; x += 8) {
      final major = x % 64 == 0;
      canvas.drawLine(Offset(x + 0.5, 0), Offset(x + 0.5, major ? 8 : 4), line);
      if (x % 128 == 0 && x + 40 < size.width) {
        TextPainter(
            text: TextSpan(text: '${x.toInt()}', style: label),
            textDirection: TextDirection.ltr,
          )
          ..layout()
          ..paint(canvas, Offset(x + 3, 7))
          ..dispose();
      }
    }
  }

  @override
  bool shouldRepaint(_RulerPainter old) =>
      old.color != color || old.label != label;
}

/// 10px L-shaped corner marks, 4px outside [child]'s box (inside a 16px
/// phone margin). For media and
/// demo frames only.
class CropMarks extends StatelessWidget {
  const CropMarks({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _CropPainter(AppDecorations.of(context).ruleStrong),
      child: child,
    );
  }
}

class _CropPainter extends CustomPainter {
  _CropPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 4.0, len = 10.0;
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (final (x, y, dx, dy) in [
      (0.0, 0.0, -1.0, -1.0),
      (size.width, 0.0, 1.0, -1.0),
      (0.0, size.height, -1.0, 1.0),
      (size.width, size.height, 1.0, 1.0),
    ]) {
      // A horizontal and a vertical stroke, each starting `gap` outside.
      canvas
        ..drawLine(Offset(x + dx * gap, y), Offset(x + dx * (gap + len), y), p)
        ..drawLine(Offset(x, y + dy * gap), Offset(x, y + dy * (gap + len)), p);
    }
  }

  @override
  bool shouldRepaint(_CropPainter old) => old.color != color;
}
