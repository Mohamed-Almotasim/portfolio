import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/features/not_found/not_found_page.dart';
import 'package:portfolio/features/playground/specimen_info.dart';
import 'package:portfolio/features/playground/specimens/data_at_scale.dart';
import 'package:portfolio/features/playground/specimens/motion_lab.dart';
import 'package:portfolio/features/playground/specimens/offline_sync.dart';
import 'package:portfolio/features/playground/specimens/one_codebase.dart';
import 'package:portfolio/features/playground/specimens/role_based_ui.dart';
import 'package:portfolio/features/playground/specimens/rtl_localization.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

/// The live widget for each [SpecimenInfo.slug].
const specimenBuilders = <String, Widget Function()>{
  'one-codebase': OneCodebaseSpecimen.new,
  'role-based-ui': RoleBasedUiSpecimen.new,
  'data-at-scale': DataAtScaleSpecimen.new,
  'offline-sync': OfflineSyncSpecimen.new,
  'rtl-localization': RtlLocalizationSpecimen.new,
  'motion-lab': MotionLabSpecimen.new,
};

/// One specimen as a spec sheet: header, the live frame, what to try, why
/// it is hard, and the neighbouring specimens.
class SpecimenPage extends StatelessWidget {
  const SpecimenPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final i = specimens.indexWhere((s) => s.slug == slug);
    if (i < 0) return NotFoundPage(path: AppRoutes.specimen(slug));
    final info = specimens[i];
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final mute = text.labelMedium?.copyWith(color: deco.inkMute);
    final number = (i + 1).toString().padLeft(2, '0');

    Widget block(String title, Widget body) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: deco.ruleStrong)),
          ),
          child: Text(title, style: mute),
        ),
        const SizedBox(height: AppSpacing.s16),
        body,
      ],
    );

    final tryThis = block(
      'TRY THIS',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (n, t) in info.tryThis.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 32, child: Text('${n + 1}.', style: mute)),
                  Expanded(child: Text(t, style: text.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
    final hard = block(
      "WHY IT'S HARD",
      Text(info.whyHard, style: text.bodyMedium),
    );

    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s24),
          TextButton(
            onPressed: () => context.go(AppRoutes.playground),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text('← Playground'),
          ),
          const SizedBox(height: AppSpacing.s24),
          Semantics(
            header: true,
            child: Text(info.name, style: text.displayMedium),
          ),
          const SizedBox(height: AppSpacing.s16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(info.claim, style: AppTypography.lead(context)),
          ),
          const SizedBox(height: AppSpacing.s16),
          // Metadata after the title, never an eyebrow above it.
          Text(
            '$number / ${specimens.length.toString().padLeft(2, '0')}   '
            '${info.techniques}',
            style: mute,
          ),
          const SizedBox(height: AppSpacing.s48),
          specimenBuilders[info.slug]!(),
          const SizedBox(height: AppSpacing.s64),
          LayoutBuilder(
            builder: (context, c) => Inspectable(
              label: 'TryAndWhy',
              note: 'Two short blocks: what to do, and why it is hard.',
              source: 'lib/features/playground/specimen_page.dart:116',
              child: c.maxWidth < 720
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        tryThis,
                        const SizedBox(height: AppSpacing.s32),
                        hard,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: tryThis),
                        const SizedBox(width: AppSpacing.s48),
                        Expanded(child: hard),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.s64),
          _Neighbours(index: i),
        ],
      ),
    );
  }
}

class _Neighbours extends StatelessWidget {
  const _Neighbours({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final prev = index > 0 ? specimens[index - 1] : null;
    final next = index < specimens.length - 1 ? specimens[index + 1] : null;

    Widget link(SpecimenInfo? s, {required bool back}) {
      if (s == null) return const SizedBox.shrink();
      return TextButton(
        onPressed: () => context.go(AppRoutes.specimen(s.slug)),
        child: Text(back ? '← ${s.name}' : '${s.name} →'),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.s12),
      margin: const EdgeInsets.only(bottom: AppSpacing.s32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: deco.rule)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: link(prev, back: true)),
          Flexible(child: link(next, back: false)),
        ],
      ),
    );
  }
}
