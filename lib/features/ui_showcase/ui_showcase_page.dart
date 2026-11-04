import 'package:flutter/material.dart';
import '../../shared/layout/app_page.dart';
import 'demo_registry.dart';
import 'demos/kanban_board_demo.dart';

class UIShowcasePage extends StatelessWidget {
  const UIShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = DemoRegistry.getDemos();

    return AppPage(
      title: 'UI Showcase',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interactive UI Components',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'A collection of UI patterns and micro-interactions I frequently use when building modern web apps. These components demonstrate interactivity, motion, and professional frontend skills.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 24.0;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: demos.map((demo) {
                  return SizedBox(
                    width: _cardWidthFor(
                      demo: demo,
                      availableWidth: constraints.maxWidth,
                      spacing: spacing,
                    ),
                    child: demo,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  double _cardWidthFor({
    required Widget demo,
    required double availableWidth,
    required double spacing,
  }) {
    if (availableWidth < 720) {
      return availableWidth;
    }

    final twoUpWidth = (availableWidth - spacing) / 2;
    final minimumComfortableWidth = switch (demo) {
      KanbanBoardDemo() => 500.0,
      _ => 320.0,
    };

    return twoUpWidth >= minimumComfortableWidth ? twoUpWidth : availableWidth;
  }
}
