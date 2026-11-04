import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/skill.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/landing/proof_stats_provider.dart';
import 'package:portfolio/features/landing/skills_provider.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';

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
