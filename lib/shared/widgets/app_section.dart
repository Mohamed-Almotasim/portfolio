import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.showDivider = false,
    this.action,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final bool showDivider;

  /// Optional link shown at the end of the title row, e.g. "All services".
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s64 / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    ?action,
                  ],
                ),
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
                const SizedBox(height: AppSpacing.s24),
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
