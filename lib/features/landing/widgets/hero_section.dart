import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/features/landing/widgets/live_specimen.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// Title block of the drawing set: ruler, one statement across the full
/// width, then the supporting sentence and two actions beside the live
/// specimen (docs/DESIGN.md §1).
class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final l10n = AppLocalizations.of(context);

    // Fluid display size; the measure (~9em, about 14 characters of this
    // wide face) keeps a short statement on two balanced lines.
    Widget statement(double width) {
      final size = (width / 7.6).clamp(36.0, 88.0) * deco.typeScale;
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size * 9.2),
        child: Semantics(
          header: true,
          child: Text(
            profile.tagline,
            style: text.displayLarge?.copyWith(
              fontSize: size,
              // Arabic is a joined script: tracking would break the words.
              letterSpacing: text.displayLarge?.letterSpacing == null
                  ? null
                  : -0.03 * size,
            ),
          ),
        ),
      );
    }

    final pitch = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(profile.shortBio, style: AppTypography.lead(context)),
        ),
        const SizedBox(height: AppSpacing.s32),
        Wrap(
          spacing: AppSpacing.s12,
          runSpacing: AppSpacing.s12,
          children: [
            FilledButton(
              onPressed: () => context.go(AppRoutes.contact),
              child: Text(l10n.startProject),
            ),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.work),
              child: Text(l10n.seeTheWork),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s32),
        Container(
          padding: const EdgeInsets.only(top: AppSpacing.s12),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: deco.rule)),
          ),
          // Wraps between items, never inside one.
          child: Wrap(
            spacing: AppSpacing.s24,
            runSpacing: AppSpacing.s4,
            children: [
              for (final item in [
                profile.title,
                profile.location,
                profile.availability,
              ])
                Text(
                  item,
                  style: text.labelMedium?.copyWith(color: deco.inkMute),
                ),
            ],
          ),
        ),
      ],
    );

    return Inspectable(
      label: 'HeroSection',
      note:
          'Ruler, one full-width statement, then pitch and specimen split '
          '5/6. Under 900 px they stack, so neither column gets squeezed.',
      source: 'lib/features/landing/widgets/hero_section.dart:97',
      tokens: const ['AppSpacing.s64', 'AppSpacing.s48', 'AppSpacing.s32'],
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Ruler(),
              SizedBox(height: wide ? AppSpacing.s64 : AppSpacing.s32),
              Inspectable(
                label: 'Text · h1',
                note:
                    'Size is width / 7.6, clamped 36–88, with a 9.2em '
                    'measure: the tagline holds two balanced lines at any '
                    'width.',
                source: 'lib/features/landing/widgets/hero_section.dart:112',
                tokens: const ['displayLarge', 'AppDecorations.typeScale'],
                child: statement(c.maxWidth),
              ),
              SizedBox(height: wide ? AppSpacing.s64 : AppSpacing.s32),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: pitch),
                    const SizedBox(width: AppSpacing.s48),
                    // Room above and below for the dimension marks.
                    const Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(top: AppSpacing.s8),
                        child: LiveSpecimen(),
                      ),
                    ),
                  ],
                )
              else ...[
                pitch,
                const SizedBox(height: AppSpacing.s64),
                const LiveSpecimen(),
              ],
            ],
          );
        },
      ),
    );
  }
}
