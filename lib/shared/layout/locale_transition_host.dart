import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' as intl;

/// How the old screen leaves when the language changes.
enum LocaleTransitionStyle {
  /// The old screen breaks into dust that drifts up and away.
  disintegrate,
}

/// Wraps the app and plays a transition when the language changes: it takes
/// a picture of the current screen, lets [onLocaleChanged] switch the locale
/// underneath, then removes the picture with [style], sweeping in the new
/// language's reading direction. It knows nothing about how the locale is
/// stored. Reach it with [LocaleTransitionHost.of] and call `switchLocale`.
class LocaleTransitionHost extends StatefulWidget {
  const LocaleTransitionHost({
    super.key,
    required this.onLocaleChanged,
    required this.child,
    this.style = LocaleTransitionStyle.disintegrate,
    this.duration = const Duration(milliseconds: 4400),
    this.particleSize = 6,
    this.maxParticles = 14000,
  });

  /// Called once per switch, while the picture already covers the screen.
  final ValueChanged<Locale> onLocaleChanged;
  final Widget child;
  final LocaleTransitionStyle style;
  final Duration duration;

  /// Smallest dust tile, in logical pixels. Phones use 1.5x this.
  final double particleSize;

  /// Tiles grow past [particleSize] to stay under this. Phones use half.
  final int maxParticles;

  static LocaleTransitionHostState of(BuildContext context) =>
      context.findAncestorStateOfType<LocaleTransitionHostState>()!;

  @override
  State<LocaleTransitionHost> createState() => LocaleTransitionHostState();
}

class LocaleTransitionHostState extends State<LocaleTransitionHost>
    with SingleTickerProviderStateMixin {
  final _boundary = GlobalKey();
  late final _controller = AnimationController(vsync: this)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) _finish();
    });

  /// True from [switchLocale] until the transition ends. Toggles listen to
  /// this and disable themselves.
  final running = ValueNotifier(false);

  ui.Image? _snapshot;
  _Dust? _dust;

  /// Switches to [locale] with the transition. Ignored while one is running.
  void switchLocale(Locale locale) {
    if (running.value) return;
    running.value = true;
    // After the next paint, so the picture is never of a half-updated frame.
    WidgetsBinding.instance
      ..addPostFrameCallback((_) => _start(locale))
      ..ensureVisualUpdate();
  }

  void _start(Locale locale) {
    if (!mounted) return;
    final box =
        _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final size = box.size;
    // Capped: a 4K screen at 3x would be a needlessly large texture.
    final image = box.toImageSync(
      pixelRatio: math.min(MediaQuery.devicePixelRatioOf(context), 2),
    );
    final reduced = MediaQuery.disableAnimationsOf(context);
    final phone = size.shortestSide < 600;
    setState(() {
      _snapshot = image;
      // Reduced motion: no dust, the painter crossfades instead.
      _dust = reduced
          ? null
          : _Dust(
              image: image,
              size: size,
              rtl: intl.Bidi.isRtlLanguage(locale.languageCode),
              particleSize: widget.particleSize * (phone ? 1.5 : 1),
              maxParticles: widget.maxParticles ~/ (phone ? 2 : 1),
            );
    });
    widget.onLocaleChanged(locale);
    _controller
      ..duration = reduced ? const Duration(milliseconds: 250) : widget.duration
      ..forward(from: 0);
  }

  void _finish() {
    setState(() {
      _snapshot?.dispose();
      _snapshot = null;
      _dust = null;
    });
    running.value = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _snapshot?.dispose();
    running.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    return Stack(
      alignment: Alignment.topLeft,
      fit: StackFit.expand,
      children: [
        RepaintBoundary(key: _boundary, child: widget.child),
        if (snapshot != null)
          // The page can't be used while its old picture still covers it.
          AbsorbPointer(
            child: CustomPaint(
              size: Size.infinite,
              painter: _SnapshotPainter(snapshot, _dust, _controller),
            ),
          ),
      ],
    );
  }
}

class _SnapshotPainter extends CustomPainter {
  _SnapshotPainter(this.image, this.dust, this.progress)
    : super(repaint: progress);

  final ui.Image image;
  final _Dust? dust;
  final Animation<double> progress;

  static final _paint = Paint()
    ..isAntiAlias = false
    ..filterQuality = FilterQuality.low;

  @override
  void paint(Canvas canvas, Size size) {
    final dust = this.dust;
    if (dust == null) {
      paintImage(
        canvas: canvas,
        rect: Offset.zero & size,
        image: image,
        fit: BoxFit.fill,
        opacity: 1 - progress.value,
      );
      return;
    }
    dust.update(Curves.easeInOut.transform(progress.value));
    // One call for every tile.
    canvas.drawRawAtlas(
      image,
      dust.transforms,
      dust.rects,
      dust.colors,
      BlendMode.modulate,
      null,
      _paint,
    );
  }

  @override
  bool shouldRepaint(_SnapshotPainter old) =>
      old.image != image || old.dust != dust;
}

/// The snapshot cut into a grid of tiles. Each tile waits for the sweep to
/// reach it, then drifts up and along the sweep, spins, shrinks and fades.
class _Dust {
  _Dust({
    required ui.Image image,
    required Size size,
    required bool rtl,
    required double particleSize,
    required int maxParticles,
  }) : _scale = size.width / image.width {
    final logical = math.max(
      particleSize,
      math.sqrt(size.width * size.height / maxParticles),
    );
    // A whole number of image pixels, so resting tiles meet without seams.
    final tile = math.max(1, (logical / _scale).ceil());
    final cols = (image.width / tile).ceil();
    final rows = (image.height / tile).ceil();
    final count = cols * rows;
    rects = Float32List(count * 4);
    transforms = Float32List(count * 4);
    colors = Int32List(count);
    _delay = Float32List(count);
    _dx = Float32List(count);
    _dy = Float32List(count);
    _spin = Float32List(count);

    final random = math.Random();
    final along = rtl ? -1.0 : 1.0;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final i = r * cols + c;
        final left = (c * tile).toDouble();
        final top = (r * tile).toDouble();
        final right = math.min(left + tile, image.width.toDouble());
        rects[i * 4] = left;
        rects[i * 4 + 1] = top;
        rects[i * 4 + 2] = right;
        rects[i * 4 + 3] = math.min(top + tile, image.height.toDouble());
        // The sweep starts on the edge the new language reads from. The
        // jitter keeps its front ragged instead of a straight line.
        final x = (left + right) / 2 / image.width;
        _delay[i] = (rtl ? 1 - x : x) * _sweep + random.nextDouble() * _jitter;
        _dx[i] =
            along * (20 + random.nextDouble() * 70) +
            (random.nextDouble() - 0.5) * 40;
        _dy[i] = -(30 + random.nextDouble() * 90);
        _spin[i] = (random.nextDouble() - 0.5) * 3;
      }
    }
  }

  // Shares of the whole run; they add up to 1. A longer [_sweep] makes the
  // front cross the screen more slowly, a longer [_life] makes each tile
  // linger.
  static const _sweep = 0.55;
  static const _jitter = 0.1;
  static const _life = 0.35;

  /// Logical pixels per image pixel.
  final double _scale;

  /// Tile source rects in image pixels (left, top, right, bottom).
  late final Float32List rects;

  /// One RSTransform per tile (scos, ssin, tx, ty), rewritten every frame.
  late final Float32List transforms;

  /// White at the tile's opacity; modulated with the image.
  late final Int32List colors;

  late final Float32List _delay, _dx, _dy, _spin;

  /// [t] is 0..1 through the whole transition.
  void update(double t) {
    for (var i = 0, o = 0; i < colors.length; i++, o += 4) {
      final p = ((t - _delay[i]) / _life).clamp(0.0, 1.0);
      if (p == 0) {
        transforms[o] = _scale;
        transforms[o + 1] = 0;
        transforms[o + 2] = rects[o] * _scale;
        transforms[o + 3] = rects[o + 1] * _scale;
        colors[i] = 0xFFFFFFFF;
        continue;
      }
      final e = 1 - (1 - p) * (1 - p) * (1 - p); // ease out
      final halfW = (rects[o + 2] - rects[o]) / 2;
      final halfH = (rects[o + 3] - rects[o + 1]) / 2;
      final s = _scale * (1 - 0.6 * e);
      final scos = math.cos(_spin[i] * e) * s;
      final ssin = math.sin(_spin[i] * e) * s;
      // Where the tile's centre is now.
      final x = (rects[o] + halfW) * _scale + _dx[i] * e;
      final y = (rects[o + 1] + halfH) * _scale + _dy[i] * e;
      transforms[o] = scos;
      transforms[o + 1] = ssin;
      transforms[o + 2] = x - scos * halfW + ssin * halfH;
      transforms[o + 3] = y - ssin * halfW - scos * halfH;
      colors[i] = (((1 - p * p) * 255).round() << 24) | 0xFFFFFF;
    }
  }
}
