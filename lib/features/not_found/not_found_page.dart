import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/theme/app_spacing.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPage(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sectionSpacing,
          ),
          child: Column(
            children: [
              Text(
                '404',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.smallSpacing),
              Text(
                'No page at $path',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.componentSpacing),
              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Back home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
