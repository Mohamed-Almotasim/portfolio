import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// A missing sheet in the drawing set: the path that was asked for, and the
/// sheets that do exist.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    return AppPage(
      child: Inspectable(
        label: 'NotFound',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Ruler(),
            const SizedBox(height: AppSpacing.s64),
            Semantics(
              header: true,
              child: Text('404', style: text.displayLarge),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              'There is no sheet at this address.',
              style: AppTypography.lead(context),
            ),
            const SizedBox(height: AppSpacing.s8),
            SelectableText(
              path,
              style: text.labelMedium?.copyWith(color: deco.inkMute),
            ),
            const SizedBox(height: AppSpacing.s32),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Back home'),
            ),
            const SizedBox(height: AppSpacing.s64),
            Container(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: deco.ruleStrong)),
              ),
              child: Wrap(
                spacing: AppSpacing.s8,
                children: [
                  for (final d in navDestinations)
                    TextButton(
                      onPressed: () => context.go(d.path),
                      child: Text('${d.label} →'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
