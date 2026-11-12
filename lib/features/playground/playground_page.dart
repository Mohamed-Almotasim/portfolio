import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/features/playground/specimen_info.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

/// The specimen register: one row per experiment, same pattern as Work.
class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final head = text.labelSmall?.copyWith(color: deco.inkMute);
    final l10n = AppLocalizations.of(context);

    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s48),
          Semantics(
            header: true,
            child: Text(l10n.navPlayground, style: text.displayLarge),
          ),
          const SizedBox(height: AppSpacing.s16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(l10n.pgLead, style: AppTypography.lead(context)),
          ),
          const SizedBox(height: AppSpacing.s48),
          LayoutBuilder(
            builder: (context, c) {
              final compact = c.maxWidth < 720;
              return Inspectable(
                label: 'SpecimenRegister',
                note:
                    'Same table as Work: a strong rule under the header, '
                    'hairlines between rows. Under 720 px the tags fold away.',
                source: 'lib/features/playground/playground_page.dart:41',
                tokens: const [
                  'AppDecorations.ruleStrong',
                  'AppDecorations.rule',
                  'labelSmall',
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.s8,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: deco.ruleStrong),
                        ),
                      ),
                      child: ExcludeSemantics(
                        child: compact
                            ? Text(
                                '${l10n.colNo} · ${l10n.pgColSpecimen}',
                                style: head,
                              )
                            : _Cells(
                                no: Text(l10n.colNo, style: head),
                                name: Text(l10n.pgColSpecimen, style: head),
                                proves: Text(l10n.pgColProves, style: head),
                                tags: Text(l10n.pgColTags, style: head),
                              ),
                      ),
                    ),
                    for (final (i, s) in specimensOf(context).indexed)
                      _Row(number: i + 1, info: s, compact: compact),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Cells extends StatelessWidget {
  const _Cells({
    required this.no,
    required this.name,
    required this.proves,
    required this.tags,
  });

  final Widget no, name, proves, tags;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(width: 56, child: no),
        Expanded(flex: 4, child: name),
        Expanded(flex: 6, child: proves),
        Expanded(flex: 3, child: tags),
      ],
    );
  }
}

class _Row extends StatefulWidget {
  const _Row({required this.number, required this.info, required this.compact});

  final int number;
  final SpecimenInfo info;
  final bool compact;

  @override
  State<_Row> createState() => _RowState();
}

class _RowState extends State<_Row> {
  bool _lit = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.info;
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final mono = text.labelMedium;
    final no = Text(
      widget.number.toString().padLeft(2, '0'),
      style: mono?.copyWith(color: _lit ? deco.accentText : deco.inkMute),
    );

    return Semantics(
      link: true,
      label: '${s.name}. ${s.claim}',
      excludeSemantics: true,
      child: InkWell(
        onTap: () => context.go(AppRoutes.specimen(s.slug)),
        onHover: (v) => setState(() => _lit = v),
        onFocusChange: (v) => setState(() => _lit = v),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 40, child: no),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name, style: text.titleMedium),
                          const SizedBox(height: AppSpacing.s4),
                          Text(s.claim, style: text.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                )
              : _Cells(
                  no: no,
                  name: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.s16,
                    ),
                    child: Text(s.name, style: text.titleMedium),
                  ),
                  proves: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.s16,
                    ),
                    child: Text(s.claim, style: text.bodyMedium),
                  ),
                  tags: Text(
                    s.tags.join(' / '),
                    style: mono?.copyWith(color: deco.inkMute),
                  ),
                ),
        ),
      ),
    );
  }
}
