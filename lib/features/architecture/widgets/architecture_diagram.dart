import 'package:flutter/material.dart';

class ArchitectureDiagram extends StatelessWidget {
  const ArchitectureDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application Architecture',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              // Core Layer
              _ArchitectureCard(
                title: 'Core',
                description:
                    'Foundation layer containing state management, routing, theming, and development utilities.',
                color: Colors.blue.shade100,
              ),
              const SizedBox(height: 16),
              // Arrow down
              Icon(Icons.arrow_downward, size: 32, color: Colors.grey),
              const SizedBox(height: 16),
              // Shared Layer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ArchitectureCard(
                    title: 'Shared',
                    description:
                        'Reusable components, layouts, and widgets used across features.',
                    color: Colors.green.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Arrow down
              Icon(Icons.arrow_downward, size: 32, color: Colors.grey),
              const SizedBox(height: 16),
              // Features Layer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ArchitectureCard(
                    title: 'Features',
                    description:
                        'Feature-specific modules (UI Showcase, Widget Gallery, Architecture, etc.)',
                    color: Colors.orange.shade100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _ArchitectureCard({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
