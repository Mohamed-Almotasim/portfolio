import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/utils/link_launcher.dart';

/// The closing title block: the name at full width, then one mono row of
/// contact links and the colophon. Not a sitemap (the nav already is one).
class AppFooter extends ConsumerWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final mute = text.labelMedium?.copyWith(color: deco.inkMute);

    return Semantics(
      container: true,
      label: 'Footer',
      child: Container(
        padding: const EdgeInsets.only(top: AppSpacing.s24),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: deco.ruleStrong)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile.name, style: text.displaySmall),
            const SizedBox(height: AppSpacing.s24),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final l in profile.contactLinks)
                  TextButton(
                    onPressed: () => openLink(context, ref, Uri.parse(l.url)),
                    child: Text(l.label),
                  ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.aboutBuilt),
                  child: const Text('How this site is built'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              '© ${DateTime.now().year} ${profile.name} · '
              'Built in Flutter, every pixel a widget.',
              style: mute,
            ),
          ],
        ),
      ),
    );
  }
}
