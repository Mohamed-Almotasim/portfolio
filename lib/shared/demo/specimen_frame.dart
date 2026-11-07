import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/demo/source_snippet.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/code_viewer.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// One showcase in one consistent frame: a line on why it is hard, the live
/// demo in a cropped well, a small controls panel, and (in Inspector mode)
/// the real source between `// #region snippet` markers in [sourcePath].
class SpecimenFrame extends ConsumerStatefulWidget {
  const SpecimenFrame({
    super.key,
    required this.title,
    required this.why,
    required this.demo,
    required this.sourcePath,
    this.controls,
    this.demoHeight = 420,
  });

  final String title;

  /// One line: what makes this hard to build.
  final String why;
  final Widget demo;
  final Widget? controls;
  final double demoHeight;

  /// Bundled source file (pubspec assets + `showcaseSnippetSources`).
  final String sourcePath;

  @override
  ConsumerState<SpecimenFrame> createState() => _SpecimenFrameState();
}

class _SpecimenFrameState extends ConsumerState<SpecimenFrame> {
  Future<String>? _snippet;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final inspecting = ref.watch(developerModeProvider);
    // Load the source the first time it is asked for.
    if (inspecting) _snippet ??= loadSnippet(widget.sourcePath);

    final well = CropMarks(
      child: Container(
        height: widget.demoHeight,
        color: scheme.surfaceContainerLow,
        child: ClipRect(child: widget.demo),
      ),
    );

    final controls = widget.controls == null
        ? null
        : Container(
            padding: const EdgeInsets.only(top: AppSpacing.s12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: deco.ruleStrong)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Controls',
                  style: text.labelMedium?.copyWith(color: deco.inkMute),
                ),
                const SizedBox(height: AppSpacing.s12),
                widget.controls!,
              ],
            ),
          );

    return Inspectable(
      label: 'Specimen · ${widget.title}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(widget.why, style: text.bodyLarge),
          ),
          const SizedBox(height: AppSpacing.s32),
          LayoutBuilder(
            builder: (context, c) {
              if (controls == null) return well;
              if (c.maxWidth < 900) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    well,
                    const SizedBox(height: AppSpacing.s32),
                    controls,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 8, child: well),
                  const SizedBox(width: AppSpacing.s48),
                  Expanded(flex: 3, child: controls),
                ],
              );
            },
          ),
          if (inspecting)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s32),
              child: FutureBuilder<String>(
                future: _snippet,
                builder: (context, s) => switch (s) {
                  AsyncSnapshot(:final data?) => CodeViewer(
                    code: data,
                    filename: widget.sourcePath.split('/').last,
                  ),
                  AsyncSnapshot(hasError: true) => Text(
                    'Source not bundled: ${widget.sourcePath}',
                    style: text.labelMedium?.copyWith(color: scheme.error),
                  ),
                  _ => const SizedBox(height: 48),
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// A labelled slider row for a controls panel: `label ----o---- value`.
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
    final style = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: AppDecorations.of(context).inkMute);
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
          value: value,
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
