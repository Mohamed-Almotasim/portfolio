import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

/// Closing call to action on a brand-gradient band.
class CtaBand extends ConsumerWidget {
  const CtaBand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s48,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.secondary],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Have an app in mind?',
            style: text.displaySmall?.copyWith(color: scheme.onPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              "Tell me what you're building. I'll reply with how I'd approach "
              'it, a rough timeline and what it would take.',
              style: text.bodyLarge?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s12,
            children: [
              FilledButton(
                onPressed: () => context.go(AppRoutes.contact),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.onPrimary,
                  foregroundColor: scheme.primary,
                ),
                child: const Text('Start a project'),
              ),
              OutlinedButton(
                onPressed: () =>
                    launchUrl(Uri(scheme: 'mailto', path: profile.email)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.onPrimary,
                  side: BorderSide(
                    color: scheme.onPrimary.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(profile.email),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
