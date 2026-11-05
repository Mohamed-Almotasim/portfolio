import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';

/// Notes on how this portfolio itself is built (was the dev-mode-only
/// DeveloperInfo panel on the landing page).
class ArchitectureNotes extends StatelessWidget {
  const ArchitectureNotes({super.key});

  static const _notes = [
    (
      'Feature-based structure',
      'core/ holds app-wide theme, routing, state and content; shared/ holds '
          'reusable layout and widgets; each feature owns its pages, widgets '
          'and providers.',
    ),
    (
      'Content as data',
      'Profile, case studies, services and skills are const models in '
          'core/content, exposed through Riverpod providers. Widgets never '
          'hard-code copy.',
    ),
    (
      'State management',
      'Riverpod Notifiers with intent methods (toggle, setQuery, setCategory) '
          'for theme mode, developer mode and filters; plain Providers for content.',
    ),
    (
      'Navigation',
      'GoRouter with a ShellRoute, so the navbar persists across pages, path '
          'URLs on the web, custom fade-and-slide transitions and a 404 inside '
          'the shell.',
    ),
    (
      'Honest developer mode',
      'Showcase code is read from the real source files at runtime, between '
          '"#region snippet" markers, and a test fails if a marker goes missing.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes on this codebase', style: text.headlineSmall),
        const SizedBox(height: AppSpacing.s8),
        Text(
          'How the portfolio you are looking at is put together.',
          style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.s24),
        ResponsiveGrid(
          childAspectRatio: 4,
          spacing: AppSpacing.s32,
          children: [
            for (final (title, body) in _notes)
              Container(
                padding: const EdgeInsets.only(top: AppSpacing.s12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: scheme.outlineVariant)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      body,
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
