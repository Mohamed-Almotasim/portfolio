import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// 12345 → `12,345`.
String groupDigits(num n) {
  final s = n.round().abs().toString();
  final out = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) out.write(',');
    out.write(s[i]);
  }
  return out.toString();
}

/// `online` → `Online`, for a choice that shares its word with a readout.
String capitalized(String s) => s[0].toUpperCase() + s.substring(1);

/// The one frame every specimen sits in: the live specimen in a crop-mark
/// well, and beside it (below it on compact screens) a CONTROLS panel with a
/// reset button and the live READOUTS in mono.
class SpecimenFrame extends StatefulWidget {
  const SpecimenFrame({
    super.key,
    required this.label,
    required this.demo,
    required this.controls,
    required this.readouts,
    required this.onReset,
    this.demoHeight = 440,
  });

  /// Inspector tag, e.g. `Specimen · Role-based UI`.
  final String label;
  final Widget demo;
  final List<Widget> controls;

  /// `(name, value)` pairs, shown as mono rows.
  final List<(String, String)> readouts;
  final VoidCallback onReset;
  final double demoHeight;

  @override
  State<SpecimenFrame> createState() => _SpecimenFrameState();
}

class _SpecimenFrameState extends State<SpecimenFrame> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final mute = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: deco.inkMute);
    final l10n = AppLocalizations.of(context);

    return Inspectable(
      label: widget.label,
      note:
          'Every specimen sits in this frame: a crop-mark well, a controls '
          'panel with reset, and readouts that update as you touch it.',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final well = Padding(
            padding: const EdgeInsets.all(AppSpacing.s8),
            child: CropMarks(
              child: Container(
                // Larger text needs a taller well, or the specimen overflows.
                height:
                    widget.demoHeight *
                    math.max(1.0, MediaQuery.textScalerOf(context).scale(1)),
                color: scheme.surfaceContainerLow,
                // Heavy specimens repaint on their own layer.
                child: RepaintBoundary(child: ClipRect(child: widget.demo)),
              ),
            ),
          );

          final controls = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final w in widget.controls) ...[
                w,
                const SizedBox(height: AppSpacing.s12),
              ],
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton(
                  key: const Key('specimen-reset'),
                  onPressed: widget.onReset,
                  child: Text(l10n.reset),
                ),
              ),
            ],
          );

          Widget head(String t, {Widget? trailing}) => Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: deco.ruleStrong)),
            ),
            child: Row(
              children: [
                Expanded(child: Text(t, style: mute)),
                ?trailing,
              ],
            ),
          );

          final readouts = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              head(l10n.readouts),
              for (final (name, value) in widget.readouts)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: deco.rule)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(name, style: mute)),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
            ],
          );

          final panel = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Compact screens can fold the controls away.
              Semantics(
                button: !wide,
                expanded: wide ? null : _open,
                child: InkWell(
                  onTap: wide ? null : () => setState(() => _open = !_open),
                  child: head(
                    l10n.controls,
                    trailing: wide
                        ? null
                        : Text(_open ? l10n.hide : l10n.show, style: mute),
                  ),
                ),
              ),
              if (wide || _open) ...[
                const SizedBox(height: AppSpacing.s16),
                controls,
              ],
              const SizedBox(height: AppSpacing.s24),
              readouts,
            ],
          );

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                well,
                const SizedBox(height: AppSpacing.s24),
                panel,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 8, child: well),
              const SizedBox(width: AppSpacing.s48),
              Expanded(flex: 4, child: panel),
            ],
          );
        },
      ),
    );
  }
}

/// A labelled slider row: `label ----o---- value`.
class SpecSlider extends StatelessWidget {
  const SpecSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.format,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String Function(double)? format;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppDecorations.of(context).inkMute,
    );
    final shown = format?.call(value) ?? value.toStringAsFixed(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: style)),
            Text(shown, style: style),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          semanticFormatterCallback: (v) =>
              '$label ${format?.call(v) ?? v.round()}',
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// A labelled segmented choice.
class SpecChoice<T> extends StatelessWidget {
  const SpecChoice({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;

  /// `(value, text)` per segment.
  final List<(T, String)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppDecorations.of(context).inkMute,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style),
        const SizedBox(height: AppSpacing.s8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<T>(
            showSelectedIcon: false,
            segments: [
              for (final (v, t) in options)
                ButtonSegment(value: v, label: Text(t)),
            ],
            selected: {value},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ),
      ],
    );
  }
}

/// A labelled on/off switch.
class SpecSwitch extends StatelessWidget {
  const SpecSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppDecorations.of(context).inkMute,
    );
    return MergeSemantics(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            children: [
              Expanded(child: Text(label, style: style)),
              ExcludeFocus(
                child: Switch(value: value, onChanged: onChanged),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
