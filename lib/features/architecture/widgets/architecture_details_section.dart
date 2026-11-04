import 'package:flutter/material.dart';

import 'architecture_detail_card.dart';

class ArchitectureDetailsSection extends StatelessWidget {
  const ArchitectureDetailsSection({super.key});

  static const _details = [
    _ArchitectureDetail(
      title: 'Folder Structure',
      description:
          'The project is organized around clear ownership boundaries so shared systems and feature code stay easy to navigate.',
      icon: Icons.folder_rounded,
      bullets: [
        'Core holds app-wide systems like theme, routing, and state foundations.',
        'Shared contains layouts, widgets, and utilities reused across features.',
        'Features stay self-contained so pages, demos, and supporting widgets evolve independently.',
      ],
    ),
    _ArchitectureDetail(
      title: 'State Management (Riverpod)',
      description:
          'Riverpod is used to keep state explicit, reactive, and testable without coupling business logic to the widget tree.',
      icon: Icons.bolt_rounded,
      bullets: [
        'Centralized logic improves predictability across screens and demos.',
        'Reactive updates keep widgets in sync with minimal boilerplate.',
        'Provider-based boundaries make isolated testing straightforward.',
      ],
    ),
    _ArchitectureDetail(
      title: 'Routing (GoRouter)',
      description:
          'Navigation is declarative, readable, and feature-oriented so routes scale cleanly with the portfolio.',
      icon: Icons.route_rounded,
      bullets: [
        'Routes are defined in one place for clarity and maintainability.',
        'Feature pages can be composed into navigation without tight coupling.',
        'Navigation flow remains easy to trace during development and review.',
      ],
    ),
    _ArchitectureDetail(
      title: 'Reusable Components',
      description:
          'Reusable UI primitives reduce repetition and help the app present a consistent design language.',
      icon: Icons.widgets_rounded,
      bullets: [
        'Shared cards, layouts, and controls keep styling aligned across pages.',
        'Common building blocks speed up implementation of new showcase sections.',
        'Consistency improves maintainability and developer velocity.',
      ],
    ),
    _ArchitectureDetail(
      title: 'Feature-based Architecture',
      description:
          'Each feature owns its own page, widgets, and supporting logic so the codebase stays modular as the portfolio grows.',
      icon: Icons.layers_rounded,
      bullets: [
        'Feature folders localize change and reduce accidental cross-impact.',
        'New showcases can be added without restructuring unrelated areas.',
        'The project reads like a system, not a pile of screens.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Architecture Details', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'The same architectural decisions that shape the codebase also shape how the portfolio is extended and maintained.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final isSingleColumn = constraints.maxWidth < 760;

            if (isSingleColumn) {
              return Column(
                children: _details
                    .map(
                      (detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ArchitectureDetailCard(
                          title: detail.title,
                          description: detail.description,
                          bullets: detail.bullets,
                          icon: detail.icon,
                        ),
                      ),
                    )
                    .toList(),
              );
            }

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _details
                  .map(
                    (detail) => SizedBox(
                      width: (constraints.maxWidth - 16) / 2,
                      child: ArchitectureDetailCard(
                        title: detail.title,
                        description: detail.description,
                        bullets: detail.bullets,
                        icon: detail.icon,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ArchitectureDetail {
  const _ArchitectureDetail({
    required this.title,
    required this.description,
    required this.bullets,
    required this.icon,
  });

  final String title;
  final String description;
  final List<String> bullets;
  final IconData icon;
}
