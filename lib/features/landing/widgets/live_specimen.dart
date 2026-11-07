import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// The hero's one live element: a real button, measured live. The slider
/// changes its padding and the dimension marks follow; the button itself
/// turns Inspector mode on, so the specimen opens the whole site's drawing.
class LiveSpecimen extends ConsumerStatefulWidget {
  const LiveSpecimen({super.key});

  @override
  ConsumerState<LiveSpecimen> createState() => _LiveSpecimenState();
}

class _LiveSpecimenState extends ConsumerState<LiveSpecimen> {
  double _padding = 24;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final inspecting = ref.watch(developerModeProvider);
    final label = text.labelSmall!.copyWith(color: deco.inkMute);

    return Inspectable(
      label: 'LiveSpecimen',
      note:
          'A real button measured live: the slider sets its padding and '
          'the dimension marks follow the actual box.',
      source: 'lib/features/landing/widgets/live_specimen.dart:30',
      tokens: const ['AppSpacing.s24', 'AppDecorations.inkMute', 'labelSmall'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CropMarks(
            child: Container(
              height: 200,
              color: scheme.surfaceContainerLow,
              alignment: Alignment.center,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: _padding),
                duration: AppMotion.of(context, AppMotion.measure),
                builder: (context, p, child) => CustomPaint(
                  foregroundPainter: _DimensionPainter(
                    padding: p,
                    line: deco.inkMute,
                    hatch: deco.accent,
                    label: label,
                  ),
                  child: Container(
                    color: scheme.surface,
                    padding: EdgeInsets.all(p),
                    child: child,
                  ),
                ),
                child: OutlinedButton(
                  onPressed: () =>
                      ref.read(developerModeProvider.notifier).toggle(),
                  child: Text(
                    inspecting ? 'Stop inspecting' : 'Inspect this page',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Row(
            children: [
              Text('padding', style: label),
              Expanded(
                child: Slider(
                  value: _padding,
                  min: 8,
                  max: 48,
                  divisions: 10,
                  label: _padding.round().toString(),
                  semanticFormatterCallback: (v) => 'Padding ${v.round()}',
                  onChanged: (v) => setState(() => _padding = v),
                ),
              ),
              SizedBox(
                width: 24,
                child: Text(
                  '${_padding.round()}',
                  style: label,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          Text(
            'Fig. 1 · A live FilledButton. Drag to change its padding.',
            style: label,
          ),
        ],
      ),
    );
  }
}

/// Hatches the padding and draws a dimension line across the top (the
/// box's width) and across the left padding (its size), like a drawing.
class _DimensionPainter extends CustomPainter {
  _DimensionPainter({
    required this.padding,
    required this.line,
    required this.hatch,
    required this.label,
  });

  final double padding;
  final Color line;
  final Color hatch;
  final TextStyle label;

  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    final inner = box.deflate(padding);
    final stroke = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas
      ..save()
      ..clipPath(
        Path()
          ..fillType = PathFillType.evenOdd
          ..addRect(box)
          ..addRect(inner),
      );
    final h = Paint()
      ..color = hatch.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    for (var x = -size.height; x < size.width; x += 6) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), h);
    }
    canvas
      ..restore()
      ..drawRect(box.deflate(0.5), stroke);

    void dim(Offset a, Offset b, String text, {required bool above}) {
      _dashed(canvas, a, b, stroke);
      final vertical = a.dx == b.dx;
      for (final p in [a, b]) {
        canvas.drawLine(
          p + (vertical ? const Offset(-3, 0) : const Offset(0, -3)),
          p + (vertical ? const Offset(3, 0) : const Offset(0, 3)),
          stroke,
        );
      }
      final tp = TextPainter(
        text: TextSpan(text: text, style: label),
        textDirection: TextDirection.ltr,
      )..layout();
      final mid = Offset.lerp(a, b, 0.5)!;
      tp
        ..paint(canvas, mid - Offset(tp.width / 2, above ? tp.height + 4 : -4))
        ..dispose();
    }

    dim(
      const Offset(0, -12),
      Offset(size.width, -12),
      '${size.width.round()}',
      above: true,
    );
    dim(
      Offset(0, size.height + 12),
      Offset(padding, size.height + 12),
      'padding: ${padding.round()}',
      above: false,
    );
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint p) {
    final d = b - a;
    final len = d.distance;
    final dir = d / len;
    for (var t = 0.0; t < len; t += 7) {
      canvas.drawLine(a + dir * t, a + dir * (t + 4).clamp(0, len), p);
    }
  }

  @override
  bool shouldRepaint(_DimensionPainter old) =>
      old.padding != padding ||
      old.line != line ||
      old.hatch != hatch ||
      old.label != label;
}
