import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/widgets/case_study_card.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';

class WorkPage extends ConsumerWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(caseStudiesProvider);
    final selected = ref.watch(workTechFilterProvider);
    final shown = filterByTech(all, selected);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return AppPage(
      title: 'Work',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              'Case studies: the problem, how it was solved and what changed. '
              'Filter by technology to see where each tool earned its place.',
              style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              for (final tech in [null, ...allTech(all)])
                ChoiceChip(
                  label: Text(tech ?? 'All'),
                  selected: selected == tech,
                  onSelected: (_) =>
                      ref.read(workTechFilterProvider.notifier).setTech(tech),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          ResponsiveGrid(
            // Small ratio = tiny minimum; cards grow to their content.
            childAspectRatio: 4,
            children: [for (final c in shown) CaseStudyCard(project: c)],
          ),
        ],
      ),
    );
  }
}
