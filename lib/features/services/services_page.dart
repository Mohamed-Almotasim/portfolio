import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/engagement_model.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/services/services_provider.dart';
import 'package:portfolio/features/services/widgets/service_sections.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';
import 'package:portfolio/shared/widgets/app_section.dart';
import 'package:portfolio/shared/widgets/cta_band.dart';
import 'package:portfolio/shared/widgets/faq_accordion.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return AppPage(
      title: 'Services',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              'I design and build Flutter apps for mobile and the web, and '
              'help teams get existing Flutter codebases into shape.',
              style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          const AppSection(
            title: 'What I offer',
            subtitle: 'And exactly what you get at the end.',
            child: ServiceOfferingsList(),
          ),
          const AppSection(
            title: 'How I work',
            subtitle: 'A simple process that keeps you in the loop.',
            child: ProcessSection(),
          ),
          AppSection(
            title: 'Ways to work together',
            subtitle: 'Pick what fits the shape of your project.',
            child: ResponsiveGrid(
              childAspectRatio: 3,
              children: [
                for (final m in ref.watch(engagementModelsProvider))
                  _EngagementTile(model: m),
              ],
            ),
          ),
          AppSection(
            title: 'Questions',
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: FaqAccordion(items: ref.watch(faqsProvider)),
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          const CtaBand(),
        ],
      ),
    );
  }
}

class _EngagementTile extends StatelessWidget {
  const _EngagementTile({required this.model});

  final EngagementModel model;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(AppSpacing.s8),
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppDecorations.of(context).cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(model.icon, color: scheme.primary),
          const SizedBox(height: AppSpacing.s16),
          Text(model.title, style: text.titleLarge),
          if (model.price != null) ...[
            const SizedBox(height: AppSpacing.s4),
            Text(model.price!, style: text.titleMedium),
          ],
          const SizedBox(height: AppSpacing.s8),
          Text(
            model.description,
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text.rich(
            TextSpan(
              style: text.bodySmall,
              children: [
                TextSpan(
                  text: 'Best for: ',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
                TextSpan(text: model.bestFor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
