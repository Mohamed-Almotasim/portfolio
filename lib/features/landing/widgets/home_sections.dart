import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/portfolio_content_ar.dart' as ar;
import 'package:portfolio/core/content/process_step.dart';
import 'package:portfolio/core/content/service_offering.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/locale_provider.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

final serviceOfferingsProvider = Provider<List<ServiceOffering>>(
  (ref) => ref.watch(isArabicProvider)
      ? ar.serviceOfferings
      : content.serviceOfferings,
);
final processStepsProvider = Provider<List<ProcessStep>>(
  (ref) => ref.watch(isArabicProvider) ? ar.processSteps : content.processSteps,
);

/// Services as a numbered list: title and description on the left,
/// deliverables in mono on the right. No icons, no cards.
class ServicesList extends ConsumerWidget {
  const ServicesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceOfferingsProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final mute = text.labelMedium?.copyWith(color: deco.inkMute);

    return Column(
      children: [
        for (final (i, s) in services.indexed)
          Inspectable(
            label: 'ServiceRow',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
              decoration: BoxDecoration(
                border: Border(
                  top: i == 0 ? BorderSide.none : BorderSide(color: deco.rule),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= 720;
                  final head = Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      SizedBox(width: 40, child: Text('${i + 1}', style: mute)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.title, style: text.titleLarge),
                            const SizedBox(height: AppSpacing.s8),
                            Text(s.description, style: text.bodyLarge),
                          ],
                        ),
                      ),
                    ],
                  );
                  final deliverables = Text(
                    s.deliverables.join('\n'),
                    style: mute?.copyWith(height: 1.8),
                  );
                  return wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: head),
                            const SizedBox(width: AppSpacing.s24),
                            Expanded(flex: 4, child: deliverables),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            head,
                            const SizedBox(height: AppSpacing.s12),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 40,
                              ),
                              child: deliverables,
                            ),
                          ],
                        );
                },
              ),
            ),
          ),
      ],
    );
  }
}

/// "How I work" as one measured line with a tick per step: horizontal on
/// wide screens, vertical on phones.
class ProcessLine extends ConsumerWidget {
  const ProcessLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = ref.watch(processStepsProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final mute = text.labelMedium?.copyWith(color: deco.inkMute);

    Widget body(int i, ProcessStep s) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${i + 1}/${steps.length}', style: mute),
        const SizedBox(height: AppSpacing.s8),
        Text(s.title, style: text.titleLarge),
        const SizedBox(height: AppSpacing.s8),
        Text(s.description, style: text.bodyMedium),
      ],
    );
    final tick = Container(width: 1, height: 12, color: deco.ruleStrong);

    return Inspectable(
      label: 'ProcessLine',
      child: LayoutBuilder(
        builder: (context, c) {
          if (c.maxWidth < 720) {
            // Vertical: one continuous line down the left edge.
            return Container(
              decoration: BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(color: deco.ruleStrong),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, s) in steps.indexed)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: AppSpacing.s24,
                        bottom: AppSpacing.s32,
                      ),
                      child: body(i, s),
                    ),
                ],
              ),
            );
          }
          // Horizontal: the measuring line, with a tick where each step
          // starts and one closing the line.
          return Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: deco.ruleStrong)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, s) in steps.indexed)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tick,
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            top: AppSpacing.s12,
                            end: AppSpacing.s32,
                          ),
                          child: body(i, s),
                        ),
                      ],
                    ),
                  ),
                tick,
              ],
            ),
          );
        },
      ),
    );
  }
}

/// The minimal close of the home page: one line, the address with a copy
/// button, and the one action.
class ContactBlock extends ConsumerWidget {
  const ContactBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final l10n = AppLocalizations.of(context);

    return Inspectable(
      label: 'ContactBlock',
      child: Wrap(
        spacing: AppSpacing.s24,
        runSpacing: AppSpacing.s16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FilledButton(
            onPressed: () => context.go(AppRoutes.contact),
            child: Text(l10n.startProject),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                profile.email,
                style: text.labelLarge?.copyWith(color: deco.inkMute),
              ),
              IconButton(
                tooltip: l10n.copyEmail,
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: profile.email));
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l10n.emailCopied)));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
