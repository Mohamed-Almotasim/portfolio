import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/theme_mode_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/features/app_simulator/demo_count.dart';

/// Layered-card composition, gently floating: a code card (decorative), a
/// working theme switch and a link to the live demos. Everything shown is
/// true about this site; nothing is a made-up metric.
class HeroVisual extends StatefulWidget {
  const HeroVisual({super.key});

  static const Size size = Size(400, 340);

  @override
  State<HeroVisual> createState() => _HeroVisualState();
}

class _HeroVisualState extends State<HeroVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
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
    return RepaintBoundary(
      child: SizedBox.fromSize(
        size: HeroVisual.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value * 2 * math.pi;
            Offset float(double phase, double amp) =>
                Offset(0, amp * math.sin(t + phase));
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Transform.translate(
                    offset: float(0, 6),
                    child: Transform.rotate(
                      angle: -0.04,
                      child: const ExcludeSemantics(child: _CodeCard()),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 110,
                  child: Transform.translate(
                    offset: float(2, 8),
                    child: Transform.rotate(
                      angle: 0.03,
                      child: const _ThemeCard(),
                    ),
                  ),
                ),
                Positioned(
                  left: 36,
                  bottom: 0,
                  child: Transform.translate(
                    offset: float(4, 5),
                    child: const _DemosToast(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.width, required this.child, this.color});

  final double width;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        // Floating panels: elevation by shadow alone, no border.
        boxShadow: deco.shadowElevated,
      ),
      child: child,
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard();

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final base = AppTypography.code(deco.codeForeground).copyWith(fontSize: 12);
    TextSpan s(String text, [Color? c]) => TextSpan(
      text: text,
      style: c == null ? null : TextStyle(color: c),
    );
    final kw = scheme.brightness == Brightness.dark
        ? scheme.primary
        : scheme.inversePrimary;
    final str = deco.success;
    return _Panel(
      width: 270,
      color: deco.codeBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (final c in [scheme.error, deco.warning, deco.success]) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Text.rich(
            TextSpan(
              style: base,
              children: [
                s('class ', kw),
                s('Launch '),
                s('extends ', kw),
                s('StatelessWidget {\n'),
                s('  build(context) =>\n'),
                s('    FilledButton(\n'),
                s('      child: Text('),
                s("'Ship'", str),
                s('),\n    );\n}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A real control: flips the whole site's theme.
class _ThemeCard extends ConsumerWidget {
  const _ThemeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    return _Panel(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Try it', style: text.titleMedium),
          const SizedBox(height: AppSpacing.s4),
          Text(
            'Every screen here is a live Flutter widget.',
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              Expanded(child: Text('Dark theme', style: text.labelLarge)),
              Switch(
                value: brightness == Brightness.dark,
                onChanged: (_) =>
                    ref.read(themeModeProvider.notifier).toggle(brightness),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Count comes from the demo registry, so it can't drift from the truth.
class _DemosToast extends StatelessWidget {
  const _DemosToast();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final count = liveDemoCount;
    return _Panel(
      width: 230,
      child: InkWell(
        onTap: () => context.go(AppRoutes.appDemos),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 20,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$count live demos', style: text.labelLarge),
                  Text(
                    'Open one in a device frame',
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, size: 16, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}
