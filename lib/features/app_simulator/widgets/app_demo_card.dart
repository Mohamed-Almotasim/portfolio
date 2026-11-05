import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/app_simulator/demo_app_registry.dart';
import 'package:portfolio/shared/widgets/device_frame.dart';
import 'package:portfolio/shared/widgets/lazy_in_view.dart';

class AppDemoCard extends ConsumerWidget {
  const AppDemoCard({super.key, required this.demo});

  final DemoApp demo;

  Widget _framed(Widget child) =>
      demo.useDeviceFrame ? DeviceFrame(child: child) : child;

  void _launch(BuildContext context) {
    final mobile = AppBreakpoints.isMobile(context);
    final content = _DemoDialogBody(
      demo: demo,
      // RepaintBoundary keeps the demo's animation repaints to itself.
      child: RepaintBoundary(child: Center(child: _framed(demo.demoWidget))),
    );
    showDialog<void>(
      context: context,
      builder: (context) => mobile
          ? Dialog.fullscreen(child: content)
          : Dialog(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 1000,
                  maxHeight: MediaQuery.sizeOf(context).height * 0.9,
                ),
                child: content,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeveloperMode = ref.watch(developerModeProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Frozen, non-interactive live preview, built only once in view.
          InkWell(
            onTap: () => _launch(context),
            child: Container(
              height: 200,
              color: scheme.surfaceContainer,
              padding: const EdgeInsets.all(AppSpacing.s12),
              child: LazyInView(
                placeholder: const SizedBox.expand(),
                builder: (_) => ExcludeSemantics(
                  child: IgnorePointer(
                    child: TickerMode(
                      enabled: false,
                      child: RepaintBoundary(
                        child: demo.useDeviceFrame
                            ? _framed(demo.demoWidget)
                            : FittedBox(
                                child: SizedBox(
                                  width: 960,
                                  height: 600,
                                  child: demo.demoWidget,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(demo.title, style: text.titleLarge),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  demo.description,
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                FilledButton.icon(
                  onPressed: () => _launch(context),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text('Launch demo'),
                ),
                if (isDeveloperMode) ...[
                  const SizedBox(height: AppSpacing.s16),
                  DeveloperInfoPanel(
                    uiPatterns: demo.uiPatterns,
                    layoutStructure: demo.layoutStructure,
                    widgetsUsed: demo.widgetsUsed,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoDialogBody extends StatelessWidget {
  const _DemoDialogBody({required this.demo, required this.child});

  final DemoApp demo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(demo.title, style: text.headlineSmall),
                    const SizedBox(height: AppSpacing.s4),
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 16,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Expanded(
                          child: Text(
                            demo.tryHint,
                            style: text.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Close demo',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class DeveloperInfoPanel extends StatelessWidget {
  const DeveloperInfoPanel({
    super.key,
    required this.uiPatterns,
    required this.layoutStructure,
    required this.widgetsUsed,
  });

  final String uiPatterns;
  final String layoutStructure;
  final String widgetsUsed;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    Widget section(String title, String body) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.labelLarge),
          const SizedBox(height: AppSpacing.s4),
          Text(
            body,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppDecorations.of(context).cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, size: 16, color: scheme.primary),
              const SizedBox(width: AppSpacing.s8),
              Text('Developer info', style: text.titleSmall),
            ],
          ),
          section('UI patterns', uiPatterns),
          section('Layout structure', layoutStructure),
          section('Widgets used', widgetsUsed),
        ],
      ),
    );
  }
}
