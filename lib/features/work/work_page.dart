import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/widgets/case_study_cover.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

/// The drawing register: every project as one scannable row. Hovering or
/// focusing a row shows its preview beside the table on wide screens.
class WorkPage extends ConsumerStatefulWidget {
  const WorkPage({super.key});

  @override
  ConsumerState<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends ConsumerState<WorkPage> {
  CaseStudy? _previewed;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(caseStudiesProvider);
    final type = ref.watch(workTypeFilterProvider);
    final shown = filterByType(all, type);
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final preview = _previewed ?? (shown.isEmpty ? null : shown.first);

    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s48),
          Semantics(
            header: true,
            child: Text(l10n.navWork, style: text.displayLarge),
          ),
          const SizedBox(height: AppSpacing.s16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(l10n.workLead, style: AppTypography.lead(context)),
          ),
          const SizedBox(height: AppSpacing.s48),
          _TypeFilter(types: allTypes(all), selected: type),
          const SizedBox(height: AppSpacing.s24),
          LayoutBuilder(
            builder: (context, c) {
              final table = _Register(
                studies: shown,
                all: all,
                compact: c.maxWidth < 720,
                showType: c.maxWidth >= 900,
                onPreview: (s) => setState(() => _previewed = s),
              );
              // Always a Row, so the table keeps its place (and a selection
              // inside it) when the preview appears or goes.
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 8, child: table),
                  if (c.maxWidth >= 1024 && preview != null) ...[
                    const SizedBox(width: AppSpacing.s48),
                    Expanded(flex: 4, child: _Preview(study: preview)),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TypeFilter extends ConsumerWidget {
  const _TypeFilter({required this.types, required this.selected});

  final List<String> types;
  final String? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(workTypeFilterProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return Inspectable(
      label: 'TypeFilter',
      note:
          'Chips write workTypeFilterProvider, so the register and the '
          'preview read one state. "All" is the null type.',
      source: 'lib/features/work/work_page.dart:92',
      tokens: const ['AppSpacing.s8', 'AppRadius.sm', 'labelMedium'],
      child: Wrap(
        spacing: AppSpacing.s8,
        runSpacing: AppSpacing.s8,
        children: [
          for (final t in [null, ...types])
            ChoiceChip(
              label: Text(t ?? l10n.all),
              selected: selected == t,
              onSelected: (_) => notifier.setType(t),
            ),
        ],
      ),
    );
  }
}

class _Register extends StatelessWidget {
  const _Register({
    required this.studies,
    required this.all,
    required this.compact,
    required this.showType,
    required this.onPreview,
  });

  final List<CaseStudy> studies;
  final List<CaseStudy> all;
  final bool compact;

  /// The Type column is the first to go when the table gets narrow.
  final bool showType;
  final ValueChanged<CaseStudy> onPreview;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final l10n = AppLocalizations.of(context);
    final head = text.labelSmall?.copyWith(color: deco.inkMute);

    return Inspectable(
      label: 'Register',
      note:
          'Every project in one table: a strong rule under the header, '
          'hairlines between rows. Under 720 px the columns fold into two.',
      source: 'lib/features/work/work_page.dart:139',
      tokens: const [
        'AppDecorations.ruleStrong',
        'AppDecorations.rule',
        'labelSmall',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: deco.ruleStrong)),
            ),
            child: ExcludeSemantics(
              child: compact
                  ? Text(
                      '${l10n.colNo} · ${l10n.colTitle} · ${l10n.colYear}',
                      style: head,
                    )
                  : _Cells(
                      no: Text(l10n.colNo, style: head),
                      title: Text(l10n.colTitle, style: head),
                      type: showType ? Text(l10n.colType, style: head) : null,
                      year: Text(l10n.colYear, style: head),
                      stack: Text(l10n.stack, style: head),
                    ),
            ),
          ),
          for (final s in studies)
            RegisterRow(
              number: all.indexOf(s) + 1,
              study: s,
              compact: compact,
              showType: showType,
              onPreview: () => onPreview(s),
            ),
          if (studies.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Text(l10n.workNoRows, style: text.bodyLarge),
            ),
        ],
      ),
    );
  }
}

class _Cells extends StatelessWidget {
  const _Cells({
    required this.no,
    required this.title,
    required this.type,
    required this.year,
    required this.stack,
  });

  final Widget no, title, year, stack;
  final Widget? type;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(width: 56, child: no),
        Expanded(flex: 5, child: title),
        if (type != null) Expanded(flex: 3, child: type!),
        SizedBox(width: 64, child: year),
        Expanded(flex: 4, child: stack),
      ],
    );
  }
}

/// One project. The whole row is the link; hover and focus step its tone
/// and show its preview.
class RegisterRow extends StatefulWidget {
  const RegisterRow({
    super.key,
    required this.number,
    required this.study,
    required this.compact,
    required this.showType,
    required this.onPreview,
  });

  final int number;
  final CaseStudy study;
  final bool compact;
  final bool showType;
  final VoidCallback onPreview;

  @override
  State<RegisterRow> createState() => _RegisterRowState();
}

class _RegisterRowState extends State<RegisterRow> {
  bool _lit = false;

  void _light(bool on) {
    setState(() => _lit = on);
    if (on) widget.onPreview();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.study;
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final mono = text.labelMedium;
    final no = Text(
      widget.number.toString().padLeft(2, '0'),
      style: mono?.copyWith(color: _lit ? deco.accentText : deco.inkMute),
    );

    return Inspectable(
      label: 'RegisterRow ${s.slug}',
      note:
          'The whole row is one link. Hover and focus step its tone and '
          'drive the preview; semantics read it as "title, type, year".',
      source: 'lib/features/work/work_page.dart:262',
      tokens: const [
        'surfaceContainerLow',
        'AppMotion.snap',
        'AppSpacing.s16',
        'titleMedium',
      ],
      child: Semantics(
        link: true,
        label: '${s.title}, ${s.type}, ${s.yearLabel}',
        excludeSemantics: true,
        child: InkWell(
          onTap: () => context.go(AppRoutes.caseStudy(s.slug)),
          onHover: _light,
          onFocusChange: _light,
          child: AnimatedContainer(
            duration: AppMotion.of(context, AppMotion.snap),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.s16,
              horizontal: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: _lit ? scheme.surfaceContainerLow : null,
              border: Border(bottom: BorderSide(color: deco.rule)),
            ),
            child: widget.compact
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      SizedBox(width: 40, child: no),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.title, style: text.titleMedium),
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              s.yearLabel,
                              style: mono?.copyWith(color: deco.inkMute),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : _Cells(
                    no: no,
                    title: Text(s.title, style: text.titleMedium),
                    type: widget.showType ? Text(s.type, style: mono) : null,
                    year: Text(s.yearLabel, style: mono),
                    stack: Text(
                      s.techStack.join(' / '),
                      style: mono?.copyWith(color: deco.inkMute),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Inspectable(
      label: 'Preview',
      note:
          'Only at 1024 px and up. Cross-fades when another row is hovered '
          'or focused, so the table never moves.',
      source: 'lib/features/work/work_page.dart:338',
      tokens: const ['AppMotion.snap', 'AppSpacing.s16', 'bodyMedium'],
      child: AnimatedSwitcher(
        duration: AppMotion.of(context, AppMotion.snap),
        child: Column(
          key: ValueKey(study.slug),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.s8),
            CaseStudyCover(project: study, aspectRatio: 4 / 3),
            const SizedBox(height: AppSpacing.s16),
            Text(study.outcome, style: text.bodyMedium),
          ],
        ),
      ),
    );
  }
}
