import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/landing/widgets/hero_backdrop.dart';
import 'package:portfolio/features/landing/widgets/hero_visual.dart';

const _months = [
  'January', 'February', 'March', 'April', 'May', 'June', //
  'July', 'August', 'September', 'October', 'November', 'December',
];

class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final month = _months[DateTime.now().month - 1];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: deco.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: deco.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Flexible(
                child: Text(
                  '${profile.availability} — $month',
                  style: text.labelMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Text(profile.tagline, style: text.displayMedium),
        const SizedBox(height: AppSpacing.s16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text.rich(
            TextSpan(
              style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
              // Odd segments sat between *asterisks* and get highlighted.
              children: [
                TextSpan(
                  text: "I'm ${profile.name}. ",
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                for (final (i, part) in profile.shortBio.split('*').indexed)
                  TextSpan(
                    text: part,
                    style: i.isOdd
                        ? TextStyle(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w600,
                          )
                        : null,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s32),
        Wrap(
          spacing: AppSpacing.s12,
          runSpacing: AppSpacing.s12,
          children: [
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.contact),
              icon: const Icon(Icons.arrow_forward, size: 18),
              iconAlignment: IconAlignment.end,
              label: const Text('Start a project'),
            ),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.work),
              child: const Text('See my work'),
            ),
          ],
        ),
      ],
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Stack(
        children: [
          const Positioned.fill(child: HeroBackdrop()),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s24,
              vertical: AppSpacing.s48,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 900) {
                  return Row(
                    children: [
                      Expanded(child: content),
                      const SizedBox(width: AppSpacing.s32),
                      const HeroVisual(),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    const SizedBox(height: AppSpacing.s48),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: HeroVisual.size.width,
                        ),
                        child: const FittedBox(child: HeroVisual()),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
