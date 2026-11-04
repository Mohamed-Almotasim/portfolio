import 'package:flutter/material.dart';

class ArchitectureFlowSection extends StatelessWidget {
  const ArchitectureFlowSection({super.key});

  static const _flows = [
    _FlowItem(
      title: 'User Action → State Update',
      description:
          'UI triggers provider logic → provider updates state → listening widgets rebuild with the new state.',
    ),
    _FlowItem(
      title: 'API Request Flow',
      description:
          'Feature intent calls a service → service talks to Firebase or an API → result is mapped back into reactive state.',
    ),
    _FlowItem(
      title: 'Navigation Flow',
      description:
          'A route intent is triggered in the UI → GoRouter resolves the destination → the target feature page renders inside the shared shell.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Interactive Flows', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Open each flow to inspect how common user and system interactions move through the application architecture.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: _flows
                  .map(
                    (flow) => ExpansionTile(
                      leading: const Icon(Icons.account_tree_rounded),
                      title: Text(flow.title),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(flow.description),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FlowItem {
  const _FlowItem({required this.title, required this.description});

  final String title;
  final String description;
}
