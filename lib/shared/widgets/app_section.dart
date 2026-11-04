import 'package:flutter/material.dart';
import 'package:portfolio/shared/theme/app_spacing.dart';

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.showDivider = false,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sectionSpacing / 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(title!, style: Theme.of(context).textTheme.headlineLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.componentSpacing),
              ],
              child,
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            thickness: 1,
            height: 1,
          ),
      ],
    );
  }
}
