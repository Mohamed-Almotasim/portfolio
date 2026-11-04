import 'package:flutter/material.dart';

class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

  @override
  Widget build(BuildContext context) {
    final technologies = [
      {
        'name': 'Flutter',
        'description': 'UI toolkit for building natively compiled applications',
      },
      {
        'name': 'Dart',
        'description':
            'Programming language optimized for building mobile, desktop, and web apps',
      },
      {
        'name': 'Riverpod',
        'description': 'State management library for Flutter',
      },
      {
        'name': 'GoRouter',
        'description': 'Declarative routing library for Flutter',
      },
      {'name': 'Material 3', 'description': 'Latest Material Design system'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technology Stack',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: technologies
              .map(
                (tech) => _TechCard(
                  name: tech['name']!,
                  description: tech['description']!,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _TechCard extends StatelessWidget {
  final String name;
  final String description;

  const _TechCard({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
