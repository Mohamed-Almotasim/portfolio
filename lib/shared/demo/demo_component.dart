import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/demo/source_snippet.dart';
import 'package:portfolio/shared/widgets/code_viewer.dart';

/// Showcase card: live preview always; in developer mode, the real code
/// excerpt from [sourcePath] (between `// #region snippet` markers).
class DemoComponent extends ConsumerStatefulWidget {
  const DemoComponent({
    super.key,
    required this.title,
    required this.description,
    required this.demoWidget,
    required this.sourcePath,
    this.label,
  });

  final String title;
  final String description;
  final Widget demoWidget;

  /// Asset path of the demo's own source file, listed in pubspec.yaml.
  final String sourcePath;
  final String? label;

  @override
  ConsumerState<DemoComponent> createState() => _DemoComponentState();
}

class _DemoComponentState extends ConsumerState<DemoComponent> {
  bool _showCode = false;
  late final Future<String> _snippet = loadSnippet(widget.sourcePath);

  @override
  Widget build(BuildContext context) {
    final isDeveloperMode = ref.watch(developerModeProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: deco.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: text.labelMedium?.copyWith(color: scheme.primary),
            ),
            const SizedBox(height: AppSpacing.s8),
          ],
          Text(widget.title, style: text.titleLarge),
          const SizedBox(height: AppSpacing.s16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: widget.demoWidget,
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            widget.description,
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: !isDeveloperMode
                ? const SizedBox(width: double.infinity)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.s12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () =>
                              setState(() => _showCode = !_showCode),
                          icon: const Icon(Icons.code, size: 18),
                          label: Text(_showCode ? 'Hide code' : 'Show code'),
                        ),
                      ),
                      if (_showCode)
                        FutureBuilder<String>(
                          future: _snippet,
                          builder: (context, snap) => snap.hasData
                              ? CodeViewer(
                                  code: snap.data!,
                                  filename: widget.sourcePath.split('/').last,
                                )
                              : snap.hasError
                              ? Text(
                                  'Source unavailable',
                                  style: text.bodySmall,
                                )
                              : const LinearProgressIndicator(),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
