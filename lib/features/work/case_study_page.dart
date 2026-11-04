import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/not_found/not_found_page.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/widgets/case_study_cover.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';
import 'package:portfolio/shared/widgets/tech_badge.dart';
import 'package:url_launcher/url_launcher.dart';

class CaseStudyPage extends ConsumerWidget {
  const CaseStudyPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(caseStudiesProvider);
    final study = caseStudyBySlug(all, slug);
    if (study == null) return NotFoundPage(path: AppRoutes.caseStudy(slug));

    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final links = study.links.where((l) => l.url.isNotEmpty).toList();

    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => context.go(AppRoutes.work),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('All work'),
          ),
          const SizedBox(height: AppSpacing.s16),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: CaseStudyCover(project: study, height: 280),
          ),
          const SizedBox(height: AppSpacing.s32),
          Text(study.title, style: text.displaySmall),
          const SizedBox(height: AppSpacing.s12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              study.tagline,
              style: text.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          _Meta(study: study),
          const SizedBox(height: AppSpacing.s48),
          _Story(label: 'Problem', body: study.problem),
          _Story(label: 'Solution', body: study.solution),
          _Story(label: 'Result', body: study.result),
          const SizedBox(height: AppSpacing.s32),
          Text('Screenshots', style: text.headlineSmall),
          const SizedBox(height: AppSpacing.s16),
          _Gallery(study: study),
          if (links.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s32),
            Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              children: [
                for (final (i, link) in links.indexed)
                  i == 0
                      ? FilledButton.icon(
                          onPressed: () => launchUrl(Uri.parse(link.url)),
                          icon: Icon(link.icon, size: 18),
                          label: Text(link.label),
                        )
                      : OutlinedButton.icon(
                          onPressed: () => launchUrl(Uri.parse(link.url)),
                          icon: Icon(link.icon, size: 18),
                          label: Text(link.label),
                        ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.s64),
          _NextProject(next: nextCaseStudy(all, study)),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    Widget item(String label, Widget value) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.s8),
        value,
      ],
    );
    return Wrap(
      spacing: AppSpacing.s48,
      runSpacing: AppSpacing.s24,
      children: [
        item('Role', Text(study.role, style: text.titleSmall)),
        item('Year', Text('${study.year}', style: text.titleSmall)),
        item(
          'Stack',
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [for (final t in study.techStack) TechBadge(label: t)],
          ),
        ),
      ],
    );
  }
}

/// Label beside text on wide screens, stacked on narrow ones.
class _Story extends StatelessWidget {
  const _Story({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final title = Text(
      label,
      style: text.titleLarge?.copyWith(color: scheme.primary),
    );
    final copy = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: Text(body, style: text.bodyLarge),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: LayoutBuilder(
        builder: (context, c) => c.maxWidth >= 720
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 220, child: title),
                  Expanded(child: copy),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: AppSpacing.s8),
                  copy,
                ],
              ),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final deco = AppDecorations.of(context);
    // TODO(me): add screenshots to assets/images/ and list them on the case study.
    return ResponsiveGrid(
      childAspectRatio: 1.6,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            margin: const EdgeInsets.all(AppSpacing.s8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: deco.cardBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_outlined, color: scheme.onSurfaceVariant),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  'Screenshot coming soon',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

class _NextProject extends StatelessWidget {
  const _NextProject({required this.next});

  final CaseStudy next;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => context.go(AppRoutes.caseStudy(next.slug)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.s24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppDecorations.of(context).cardBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next project',
                    style: text.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(next.title, style: text.headlineSmall),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}
