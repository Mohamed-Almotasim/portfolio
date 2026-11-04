import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Slow-drifting gradient mesh: three soft colour blobs on a faint dot grid.
/// One CustomPainter repaint per frame inside a RepaintBoundary, so it stays
/// cheap. Static when the platform asks for reduced motion.
class HeroBackdrop extends StatefulWidget {
  const HeroBackdrop({super.key});

  @override
  State<HeroBackdrop> createState() => _HeroBackdropState();
}

class _HeroBackdropState extends State<HeroBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = scheme.brightness == Brightness.dark;
    return RepaintBoundary(
      child: CustomPaint(
        painter: _MeshPainter(
          animation: _controller,
          colors: [scheme.primary, scheme.secondary, scheme.tertiary],
          strength: dark ? 0.22 : 0.14,
          dotColor: scheme.onSurface.withValues(alpha: dark ? 0.07 : 0.06),
        ),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  _MeshPainter({
    required this.animation,
    required this.colors,
    required this.strength,
    required this.dotColor,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final List<Color> colors;
  final double strength;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value * 2 * math.pi;
    // Each blob orbits its anchor on a slow Lissajous path.
    const anchors = [Offset(0.2, 0.35), Offset(0.8, 0.3), Offset(0.6, 0.85)];
    for (var i = 0; i < anchors.length; i++) {
      final phase = t + i * 2.1;
      final center = Offset(
        (anchors[i].dx + 0.08 * math.sin(phase)) * size.width,
        (anchors[i].dy + 0.10 * math.cos(phase * 0.8)) * size.height,
      );
      final radius = size.shortestSide * (0.55 + 0.08 * math.sin(phase * 1.3));
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i].withValues(alpha: strength),
            colors[i].withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    final dot = Paint()..color = dotColor;
    const gap = 28.0;
    for (var x = gap / 2; x < size.width; x += gap) {
      for (var y = gap / 2; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_MeshPainter old) =>
      old.colors != colors ||
      old.strength != strength ||
      old.dotColor != dotColor;
}
