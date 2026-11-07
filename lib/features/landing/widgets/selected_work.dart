import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/widgets/case_study_cover.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

/// Featured case studies as spec sheets. Each alternates side and width
/// (7/5, then 5/7), so the section reads as a set of drawings, not a grid.
class SelectedWork extends ConsumerWidget {
  const SelectedWork({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredCaseStudiesProvider).take(3).toList();
    return Column(
      children: [
        for (final (i, study) in featured.indexed) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s96),
          _SpecSheet(index: i, study: study),
        ],
      ],
    );
  }
}

/// `Mobile app · Flutter Developer · 2024` and the stack, in mono.
class CaseStudyMeta extends StatelessWidget {
  const CaseStudyMeta({super.key, required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppDecorations.of(context).inkMute,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${study.type} · ${study.role} · ${study.year}', style: style),
        const SizedBox(height: AppSpacing.s4),
        Text(study.techStack.join(' / '), style: style),
      ],
    );
  }
}

class _SpecSheet extends StatelessWidget {
  const _SpecSheet({required this.index, required this.study});

  final int index;
  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    void open() => context.go(AppRoutes.caseStudy(study.slug));

    final sheet = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'W-${(index + 1).toString().padLeft(2, '0')}',
          style: text.labelMedium?.copyWith(color: deco.accentText),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(study.title, style: text.headlineMedium),
        const SizedBox(height: AppSpacing.s16),
        CaseStudyMeta(study: study),
        const SizedBox(height: AppSpacing.s24),
        Container(
          padding: const EdgeInsets.only(top: AppSpacing.s16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: deco.rule)),
          ),
          child: Text(study.outcome, style: text.bodyLarge),
        ),
        const SizedBox(height: AppSpacing.s16),
        TextButton(
          onPressed: open,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            'Read the case study →',
            semanticsLabel: 'Read the ${study.title} case study',
          ),
        ),
      ],
    );

    // The cover is a link too, but hidden from the tab order (the text
    // button is the one stop per project).
    final cover = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: open,
        child: CaseStudyCover(project: study),
      ),
    );

    return Inspectable(
      label: 'SpecSheet ${study.slug}',
      note:
          'Cover 7, sheet 4, swapping sides every other row so the list '
          'reads as drawings, not a grid. The text link is the one tab stop.',
      source: 'lib/features/landing/widgets/selected_work.dart:106',
      tokens: const [
        'AppSpacing.s48',
        'AppSpacing.s96',
        'headlineMedium',
        'AppDecorations.accentText',
      ],
      child: LayoutBuilder(
        builder: (context, c) {
          if (c.maxWidth < 840) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cover,
                const SizedBox(height: AppSpacing.s32),
                sheet,
              ],
            );
          }
          final flip = index.isOdd;
          final big = Expanded(flex: 7, child: cover);
          final small = Expanded(flex: 4, child: sheet);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: flip
                ? [small, const Spacer(), big]
                : [big, const SizedBox(width: AppSpacing.s48), small],
          );
        },
      ),
    );
  }
}
