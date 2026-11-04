import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/services/services_provider.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';

class _IconBadge extends StatelessWidget {
  const _IconBadge(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, color: scheme.onPrimaryContainer, size: 22),
    );
  }
}

/// Offerings as open columns under a primary rule, each with what you
/// actually get. Deliberately not cards: the work below is where cards live.
class ServiceOfferingsList extends ConsumerWidget {
  const ServiceOfferingsList({super.key, this.limit});

  /// Show only the first [limit] offerings, e.g. 3 on the landing page.
  final int? limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceOfferingsProvider).take(limit ?? 99);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return ResponsiveGrid(
      childAspectRatio: 4,
      spacing: AppSpacing.s32,
      children: [
        for (final s in services)
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.s16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: scheme.primary, width: 2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.title, style: text.titleLarge),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  s.description,
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                for (final d in s.deliverables)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s4),
                    child: Row(
                      children: [
                        Icon(Icons.check, size: 16, color: scheme.primary),
                        const SizedBox(width: AppSpacing.s8),
                        Expanded(child: Text(d, style: text.bodyMedium)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Discover → Design → Build → Ship.
class ProcessSection extends ConsumerWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = ref.watch(processStepsProvider);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return ResponsiveGrid(
      childAspectRatio: 3,
      wideColumns: 4,
      children: [
        for (final (i, step) in steps.indexed)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconBadge(step.icon),
                    const SizedBox(width: AppSpacing.s12),
                    Text(
                      '0${i + 1}',
                      style: text.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(step.title, style: text.titleLarge),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  step.description,
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
