import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/demo/specimen_frame.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

enum _Mode { origami, magnetic, sheet }

/// Specimen 06: three motion studies on one spring model. Stiffness,
/// damping, duration and slow-motion are live; every pointer effect also
/// works by touch, and reduced motion jumps to the final state.
class MotionLabSpecimen extends StatefulWidget {
  const MotionLabSpecimen({super.key});

  @override
  State<MotionLabSpecimen> createState() => _MotionLabSpecimenState();
}

class _MotionLabSpecimenState extends State<MotionLabSpecimen>
    with SingleTickerProviderStateMixin {
  static const _cols = 12, _rows = 8, _radius = 110.0;
  static const _snaps = [0.18, 0.5, 0.9];

  late final Ticker _ticker = createTicker(_tick);
  final _clock = Stopwatch();
  Duration _last = Duration.zero;

  _Mode _mode = _Mode.origami;
  double _stiffness = 220, _damping = 22, _durationMs = 900;
  bool _slow = false, _repel = false;
  int _settleMs = 0;
  double _speed = 0;
  bool _moving = false;

  // Origami: 0 = open, 1 = folded.
  double _fold = 0;
  bool _foldTarget = false;

  // Magnetic grid.
  final _off = List.filled(_cols * _rows, Offset.zero);
  final _vel = List.filled(_cols * _rows, Offset.zero);
  Offset? _pointer;
  Size _gridSize = Size.zero;

  // Sheet: its height in px, and where it is heading.
  double _sheetH = -1, _sheetV = 0, _sheetTarget = -1;
  double _boxH = 440;
  bool _dragging = false;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _reset() {
    _ticker.stop();
    setState(() {
      _mode = _Mode.origami;
      _stiffness = 220;
      _damping = 22;
      _durationMs = 900;
      _slow = false;
      _repel = false;
      _fold = 0;
      _foldTarget = false;
      _pointer = null;
      _off.fillRange(0, _off.length, Offset.zero);
      _vel.fillRange(0, _vel.length, Offset.zero);
      _sheetH = _boxH * _snaps[1];
      _sheetV = 0;
      _sheetTarget = _sheetH;
      _settleMs = 0;
      _speed = 0;
      _moving = false;
    });
  }

  Offset _home(int i) => Offset(
    (i % _cols + 0.5) / _cols * _gridSize.width,
    (i ~/ _cols + 0.5) / _rows * _gridSize.height,
  );

  Offset _magTarget(int i) {
    final p = _pointer;
    if (p == null) return Offset.zero;
    final home = _home(i);
    final d = (p - home).distance;
    if (d >= _radius || d == 0) return Offset.zero;
    return (p - home) * (0.35 * (1 - d / _radius) * (_repel ? -1 : 1));
  }

  void _wake() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _snapFinal();
      return;
    }
    if (_ticker.isActive) return;
    _last = Duration.zero;
    _clock
      ..reset()
      ..start();
    _moving = true;
    _ticker.start();
  }

  /// Reduced motion: no in-between frames, just the end state.
  void _snapFinal() => setState(() {
    _fold = _foldTarget ? 1 : 0;
    for (var i = 0; i < _off.length; i++) {
      _off[i] = _magTarget(i);
      _vel[i] = Offset.zero;
    }
    _sheetH = _sheetTarget;
    _sheetV = 0;
    _moving = false;
  });

  void _tick(Duration elapsed) {
    final raw = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    // Capped so a stalled frame cannot blow the spring up.
    final dt = raw.clamp(0.0, 1 / 30) * (_slow ? 0.25 : 1);
    var busy = false;
    var peak = 0.0;
    switch (_mode) {
      case _Mode.origami:
        final goal = _foldTarget ? 1.0 : 0.0;
        if (_fold != goal) {
          final step = dt / (_durationMs / 1000);
          _fold = _foldTarget
              ? math.min(1, _fold + step)
              : math.max(0, _fold - step);
          busy = _fold != goal;
          peak = 1 / (_durationMs / 1000);
        }
      case _Mode.magnetic:
        for (var i = 0; i < _off.length; i++) {
          final to = _magTarget(i);
          // Two sub-steps keep stiff springs stable.
          for (var s = 0; s < 2; s++) {
            final a = (to - _off[i]) * _stiffness - _vel[i] * _damping;
            _vel[i] += a * (dt / 2);
            _off[i] += _vel[i] * (dt / 2);
          }
          final err = (to - _off[i]).distance;
          if (err > 0.1 || _vel[i].distance > 2) busy = true;
          peak = math.max(peak, _vel[i].distance);
        }
        // A held pointer keeps the grid live even when it has settled.
        if (_pointer != null) busy = true;
      case _Mode.sheet:
        if (!_dragging) {
          final a = -_stiffness * (_sheetH - _sheetTarget) - _damping * _sheetV;
          _sheetV += a * dt;
          _sheetH += _sheetV * dt;
          peak = _sheetV.abs();
          busy = (_sheetH - _sheetTarget).abs() > 0.4 || _sheetV.abs() > 4;
          if (!busy) {
            _sheetH = _sheetTarget;
            _sheetV = 0;
          }
        }
    }
    setState(() {
      _speed = peak;
      if (!busy) {
        _moving = false;
        _settleMs = _clock.elapsedMilliseconds;
      }
    });
    if (!busy) _ticker.stop();
  }

  void _toFold() {
    setState(() => _foldTarget = !_foldTarget);
    _wake();
  }

  void _sheetTo(double fraction) {
    _sheetTarget = _boxH * fraction;
    _wake();
  }

  void _point(Offset? p) {
    _pointer = p;
    _wake();
  }

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final mute = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: deco.inkMute);

    final Widget stage = switch (_mode) {
      _Mode.origami => GestureDetector(
        onTap: _toFold,
        child: Inspectable(
          label: 'OrigamiGrid',
          note:
              'Twelve tiles, each a Transform with perspective, folding on '
              'its top edge. One progress value drives all of them with a '
              'stagger.',
          source: 'lib/features/playground/specimens/motion_lab.dart:205',
          child: _Origami(progress: _fold),
        ),
      ),
      _Mode.magnetic => LayoutBuilder(
        builder: (context, c) {
          _gridSize = c.biggest;
          return MouseRegion(
            onExit: (_) => _point(null),
            child: Listener(
              // Pointer events cover mouse hover and touch drag alike.
              onPointerHover: (e) => _point(e.localPosition),
              onPointerDown: (e) => _point(e.localPosition),
              onPointerMove: (e) => _point(e.localPosition),
              onPointerUp: (e) {
                if (e.kind != PointerDeviceKind.mouse) _point(null);
              },
              onPointerCancel: (_) => _point(null),
              child: Inspectable(
                label: 'MagneticGrid',
                note:
                    'A spring per dot, pulled toward the pointer inside a '
                    '110 px radius. The ticker runs only while something '
                    'moves.',
                source: 'lib/features/playground/specimens/motion_lab.dart:229',
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _MagneticPainter(
                    offsets: _off,
                    cols: _cols,
                    rows: _rows,
                    dot: scheme.onSurface,
                    accent: deco.accent,
                    rule: deco.rule,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      _Mode.sheet => LayoutBuilder(
        builder: (context, c) {
          _boxH = c.maxHeight;
          if (_sheetH < 0) {
            _sheetH = _boxH * _snaps[1];
            _sheetTarget = _sheetH;
          }
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Text(
                  'Map view\nDrag the sheet up and let go. It keeps the '
                  'speed of your finger.',
                  style: mute,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _sheetH.clamp(0, _boxH),
                child: Inspectable(
                  label: 'SpringSheet',
                  note:
                      'Drag sets the height directly. On release the fling '
                      'velocity feeds a spring toward the nearest of three '
                      'snap points.',
                  source:
                      'lib/features/playground/specimens/motion_lab.dart:274',
                  child: GestureDetector(
                    onVerticalDragStart: (_) {
                      _dragging = true;
                      _ticker.stop();
                    },
                    onVerticalDragUpdate: (d) => setState(
                      () => _sheetH = (_sheetH - d.delta.dy).clamp(
                        _boxH * 0.1,
                        _boxH,
                      ),
                    ),
                    onVerticalDragEnd: (d) {
                      _dragging = false;
                      _sheetV = -d.velocity.pixelsPerSecond.dy;
                      final projected = _sheetH + _sheetV * 0.15;
                      final best = _snaps.reduce(
                        (a, b) =>
                            (projected - _boxH * a).abs() <
                                (projected - _boxH * b).abs()
                            ? a
                            : b,
                      );
                      _sheetTo(best);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        border: Border(top: BorderSide(color: deco.ruleStrong)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 28,
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 3,
                              color: deco.inkMute,
                            ),
                          ),
                          Expanded(
                            child: ClipRect(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.s16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final p in [
                                      'Harbour Cafe · 120 m',
                                      'Old Library · 300 m',
                                      'Central Market · 450 m',
                                      'Riverside Park · 800 m',
                                    ])
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppSpacing.s12,
                                        ),
                                        child: Text(p),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    };

    return SpecimenFrame(
      label: 'Specimen · Motion lab',
      onReset: _reset,
      readouts: [
        ('mode', _mode.name),
        ('state', _moving ? 'moving' : 'settled'),
        (
          _mode == _Mode.origami ? 'progress' : 'peak speed',
          _mode == _Mode.origami
              ? '${(_fold * 100).round()}%'
              : '${groupDigits(_speed)} px/s',
        ),
        ('last settle', '${groupDigits(_settleMs)} ms'),
      ],
      controls: [
        SpecChoice<_Mode>(
          label: 'STUDY',
          value: _mode,
          options: const [
            (_Mode.origami, 'Origami'),
            (_Mode.magnetic, 'Magnetic'),
            (_Mode.sheet, 'Sheet'),
          ],
          onChanged: (m) {
            _ticker.stop();
            setState(() {
              _mode = m;
              _moving = false;
              _pointer = null;
            });
          },
        ),
        if (_mode != _Mode.origami) ...[
          SpecSlider(
            label: 'STIFFNESS',
            value: _stiffness,
            min: 50,
            max: 600,
            onChanged: (v) => setState(() => _stiffness = v),
          ),
          SpecSlider(
            label: 'DAMPING',
            value: _damping,
            min: 4,
            max: 60,
            onChanged: (v) => setState(() => _damping = v),
          ),
        ] else ...[
          SpecSlider(
            label: 'DURATION',
            value: _durationMs,
            min: 200,
            max: 2000,
            format: (v) => '${v.round()} ms',
            onChanged: (v) => setState(() => _durationMs = v),
          ),
          OutlinedButton(
            onPressed: _toFold,
            child: Text(_foldTarget ? 'Unfold' : 'Fold'),
          ),
        ],
        if (_mode == _Mode.magnetic)
          SpecSwitch(
            label: 'REPEL INSTEAD OF PULL',
            value: _repel,
            onChanged: (v) => setState(() => _repel = v),
          ),
        if (_mode == _Mode.sheet)
          Wrap(
            spacing: AppSpacing.s8,
            children: [
              OutlinedButton(
                onPressed: () => _sheetTo(_snaps.last),
                child: const Text('Open'),
              ),
              OutlinedButton(
                onPressed: () => _sheetTo(_snaps.first),
                child: const Text('Close'),
              ),
            ],
          ),
        SpecSwitch(
          label: 'SLOW MOTION (÷4)',
          value: _slow,
          onChanged: (v) => setState(() => _slow = v),
        ),
      ],
      demo: Semantics(label: 'Motion study: ${_mode.name}', child: stage),
    );
  }
}

class _Origami extends StatelessWidget {
  const _Origami({required this.progress});

  final double progress;
  static const _n = 12;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final mono = Theme.of(context).textTheme.labelMedium;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.s8,
        crossAxisSpacing: AppSpacing.s8,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < _n; i++)
            DecoratedBox(
              decoration: BoxDecoration(border: Border.all(color: deco.rule)),
              child: Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015)
                  ..rotateX(
                    Curves.easeInOutCubic.transform(
                          ((progress - i / _n * 0.4) / 0.6).clamp(0.0, 1.0),
                        ) *
                        math.pi /
                        2,
                  ),
                child: Container(
                  color: scheme.surface,
                  alignment: Alignment.center,
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(color: deco.ruleStrong),
                  ),
                  child: Text((i + 1).toString().padLeft(2, '0'), style: mono),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MagneticPainter extends CustomPainter {
  _MagneticPainter({
    required this.offsets,
    required this.cols,
    required this.rows,
    required this.dot,
    required this.accent,
    required this.rule,
  });

  final List<Offset> offsets;
  final int cols, rows;
  final Color dot, accent, rule;

  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()..color = dot;
    final lit = Paint()..color = accent;
    final line = Paint()
      ..color = rule
      ..strokeWidth = 1;
    for (var i = 0; i < offsets.length; i++) {
      final home = Offset(
        (i % cols + 0.5) / cols * size.width,
        (i ~/ cols + 0.5) / rows * size.height,
      );
      final o = offsets[i];
      final moved = o.distance > 1;
      if (moved) canvas.drawLine(home, home + o, line);
      canvas.drawRect(
        Rect.fromCenter(center: home + o, width: 6, height: 6),
        moved ? lit : ink,
      );
    }
  }

  // The offsets list is mutated in place, so repaint on every tick.
  @override
  bool shouldRepaint(_MagneticPainter old) => true;
}
