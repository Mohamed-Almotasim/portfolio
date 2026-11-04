import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/skill.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/landing/proof_stats_provider.dart';
import 'package:portfolio/features/landing/skills_provider.dart';
import 'package:portfolio/features/services/services_provider.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';

/// Facts as one quiet line between hairlines: "iOS · Android · Web from one
/// codebase · 4 case studies · 6 live demos". Values carry weight, not size.
class ProofStrip extends ConsumerWidget {
  const ProofStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(proofStatsProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final hairline = BorderSide(color: scheme.outlineVariant);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
      decoration: BoxDecoration(
        border: Border(top: hairline, bottom: hairline),
      ),
      child: Wrap(
        spacing: AppSpacing.s32,
        runSpacing: AppSpacing.s8,
        children: [
          for (final s in stats)
            Text.rich(
              TextSpan(
                style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
                children: [
                  TextSpan(
                    text: '${s.value} ',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: s.label.toLowerCase()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

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

/// Three offerings as open columns under a primary rule, each with what you
/// actually get. Deliberately not cards: the work below is where cards live.
class ServicesTeaser extends ConsumerWidget {
  const ServicesTeaser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceOfferingsProvider).take(3);
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

/// Skills grouped by category, one card per group.
class SkillsByCategory extends ConsumerWidget {
  const SkillsByCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final groups = {
      for (final c in SkillCategory.values)
        c: skills.where((s) => s.category == c).toList(),
    }..removeWhere((_, v) => v.isEmpty);

    return ResponsiveGrid(
      childAspectRatio: 4,
      children: [
        for (final MapEntry(key: category, value: items) in groups.entries)
          Container(
            margin: const EdgeInsets.all(AppSpacing.s8),
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppDecorations.of(context).cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.label.toUpperCase(),
                  style: text.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s8,
                  children: [
                    for (final s in items)
                      Chip(
                        avatar: Icon(s.icon, size: 16, color: s.color),
                        label: Text(s.name),
                      ),
                  ],
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

/// Closing call to action on a brand-gradient band.
class FinalCtaBand extends ConsumerWidget {
  const FinalCtaBand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s48,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.secondary],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Have an app in mind?',
            style: text.displaySmall?.copyWith(color: scheme.onPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              "Tell me what you're building. I'll reply with how I'd approach "
              'it, a rough timeline and what it would take.',
              style: text.bodyLarge?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s12,
            children: [
              FilledButton(
                onPressed: () => context.go(AppRoutes.contact),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.onPrimary,
                  foregroundColor: scheme.primary,
                ),
                child: const Text('Start a project'),
              ),
              OutlinedButton(
                onPressed: () =>
                    launchUrl(Uri(scheme: 'mailto', path: profile.email)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.onPrimary,
                  side: BorderSide(
                    color: scheme.onPrimary.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(profile.email),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
