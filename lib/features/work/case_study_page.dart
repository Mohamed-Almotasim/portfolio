import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/project_assets_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/features/not_found/not_found_page.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/widgets/case_study_cover.dart';
import 'package:portfolio/features/work/widgets/project_phone.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/utils/link_launcher.dart';
import 'package:portfolio/shared/widgets/app_section.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// A case study as a spec sheet: title block, cover, three numbered
/// sections, the figures, and the neighbouring sheets.
class CaseStudyPage extends ConsumerWidget {
  const CaseStudyPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(caseStudiesProvider);
    final study = caseStudyBySlug(all, slug);
    if (study == null) {
      return NotFoundPage(path: AppRoutes.caseStudy(slug));
    }
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= AppBreakpoints.tablet;
    final sections = [
      for (final (i, (title, body)) in [
        (l10n.csProblem, study.problem),
        (l10n.csApproach, study.solution),
        (l10n.csResult, study.result),
      ].indexed)
        _NumberedBlock(number: i + 1, title: title, body: body),
    ];

    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s24),
          TextButton(
            onPressed: () => context.go(AppRoutes.work),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(
              '${directionalArrow(context, back: true)} ${l10n.navWork}',
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          Semantics(
            header: true,
            child: Text(study.title, style: text.displayMedium),
          ),
          const SizedBox(height: AppSpacing.s16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(study.tagline, style: AppTypography.lead(context)),
          ),
          const SizedBox(height: AppSpacing.s48),
          _TitleBlock(study: study),
          if (study.realLinks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s24),
            Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              children: [
                for (final (i, l) in study.realLinks.indexed)
                  i == 0
                      ? FilledButton(
                          onPressed: () =>
                              openLink(context, ref, Uri.parse(l.url)),
                          child: Text(l.label),
                        )
                      : OutlinedButton(
                          onPressed: () =>
                              openLink(context, ref, Uri.parse(l.url)),
                          child: Text(l.label),
                        ),
              ],
            ),
          ],
          if (study.media == null) ...[
            const SizedBox(height: AppSpacing.s64),
            CaseStudyCover(project: study),
            ...sections,
          ] else if (wide) ...[
            // Desktop: the phone beside the write-up instead of alone above
            // an empty column. The storyboard follows at full width.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sections,
                  ),
                ),
                const SizedBox(width: AppSpacing.s64),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s64),
                  child: SizedBox(
                    width: 360,
                    child: ProjectPhone(study: study),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s64),
            _Storyboard(study: study),
          ] else ...[
            const SizedBox(height: AppSpacing.s64),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: ProjectPhone(study: study),
            ),
            const SizedBox(height: AppSpacing.s64),
            _Storyboard(study: study),
            ...sections,
          ],
          if (study.media == null && study.gallery.isNotEmpty) ...[
            SizedBox(height: AppSpacing.section(width) / 2),
            _Gallery(figures: study.gallery),
          ],
          SizedBox(height: AppSpacing.section(width)),
          _Neighbours(
            previous: previousCaseStudy(all, study),
            next: nextCaseStudy(all, study),
          ),
        ],
      ),
    );
  }
}

/// Type / Role / Year / Stack as ruled mono cells, like a drawing's title
/// block.
class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final l10n = AppLocalizations.of(context);
    Widget cell(String label, String value) => Container(
      width: 220,
      padding: const EdgeInsets.fromLTRB(0, AppSpacing.s12, AppSpacing.s24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.labelSmall?.copyWith(color: deco.inkMute)),
          const SizedBox(height: AppSpacing.s4),
          Text(value, style: text.labelLarge),
        ],
      ),
    );
    return Inspectable(
      label: 'TitleBlock',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: deco.ruleStrong),
          ),
        ),
        child: Wrap(
          children: [
            cell(l10n.colType, study.type),
            cell(l10n.role, study.role),
            cell(l10n.colYear, study.yearLabel),
            cell(l10n.stack, study.techStack.join(' / ')),
          ],
        ),
      ),
    );
  }
}

class _NumberedBlock extends StatelessWidget {
  const _NumberedBlock({
    required this.number,
    required this.title,
    required this.body,
  });

  final int number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final heading = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 48,
          child: Text(
            number.toString().padLeft(2, '0'),
            style: text.labelMedium?.copyWith(color: deco.inkMute),
          ),
        ),
        Flexible(
          child: Semantics(
            header: true,
            child: Text(title, style: text.headlineMedium),
          ),
        ),
      ],
    );
    final copy = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: Text(body, style: text.bodyLarge),
    );
    return Inspectable(
      label: title,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s64),
        child: Container(
          padding: const EdgeInsets.only(top: AppSpacing.s24),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: deco.rule)),
          ),
          child: LayoutBuilder(
            builder: (context, c) => c.maxWidth < 840
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heading,
                      const SizedBox(height: AppSpacing.s16),
                      copy,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: heading),
                      Expanded(flex: 8, child: copy),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Figures in pairs: the first wider than the second, so the gallery reads
/// as plates on a sheet rather than a uniform grid.
class _Gallery extends StatelessWidget {
  const _Gallery({required this.figures});

  final List<CaseStudyFigure> figures;

  @override
  Widget build(BuildContext context) {
    return Inspectable(
      label: 'Gallery',
      child: LayoutBuilder(
        builder: (context, c) {
          final items = [
            for (final (i, f) in figures.indexed)
              Figure(number: i + 1, figure: f),
          ];
          if (c.maxWidth < 720) {
            return Column(
              children: [
                for (final (i, f) in items.indexed) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.s48),
                  f,
                ],
              ],
            );
          }
          return Wrap(
            spacing: AppSpacing.s48,
            runSpacing: AppSpacing.s48,
            children: [
              for (final (i, f) in items.indexed)
                SizedBox(
                  width:
                      (c.maxWidth - AppSpacing.s48) * (i.isEven ? 0.58 : 0.42),
                  child: f,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Neighbours extends StatelessWidget {
  const _Neighbours({required this.previous, required this.next});

  final CaseStudy previous;
  final CaseStudy next;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final l10n = AppLocalizations.of(context);
    Widget cell(String label, CaseStudy s, {required bool end}) => InkWell(
      onTap: () => context.go(AppRoutes.caseStudy(s.slug)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
        child: Column(
          crossAxisAlignment: end
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(label, style: text.labelMedium?.copyWith(color: deco.inkMute)),
            const SizedBox(height: AppSpacing.s8),
            Text(
              end
                  ? '${s.title} ${directionalArrow(context)}'
                  : '${directionalArrow(context, back: true)} ${s.title}',
              style: text.titleLarge,
              textAlign: end ? TextAlign.end : TextAlign.start,
            ),
          ],
        ),
      ),
    );
    return Inspectable(
      label: 'Neighbours',
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: deco.ruleStrong)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cell(l10n.csPrevious, previous, end: false)),
            const SizedBox(width: AppSpacing.s24),
            Expanded(child: cell(l10n.csNext, next, end: true)),
          ],
        ),
      ),
    );
  }
}

/// The project's screenshots in order, each cropped and captioned: the
/// video's story as stills.
class _Storyboard extends ConsumerWidget {
  const _Storyboard({required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = Footage(
      study.media,
      ref.watch(projectAssetsProvider).value ?? const {},
    );
    final deco = AppDecorations.of(context);
    final label = Theme.of(context).textTheme.labelSmall;
    return Inspectable(
      label: 'Storyboard',
      child: LayoutBuilder(
        builder: (context, c) {
          final cols = c.maxWidth >= 840 ? 4 : 2;
          const gap = AppSpacing.s24;
          final w = (c.maxWidth - gap * (cols - 1)) / cols;
          return Wrap(
            spacing: gap,
            runSpacing: AppSpacing.s48,
            children: [
              for (var i = 0; i < f.shots.length; i++)
                SizedBox(
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CropMarks(
                        child: AspectRatio(
                          aspectRatio: 412 / 915,
                          child: FigureImage(
                            path: f.shots[i],
                            label: f.caption(i),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Text(
                        '${(i + 1).toString().padLeft(2, '0')} · '
                        '${f.caption(i)}',
                        style: label?.copyWith(color: deco.inkMute),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
