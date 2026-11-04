import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/developer_mode_provider.dart';

class DeveloperInfo extends ConsumerWidget {
  const DeveloperInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeveloperMode = ref.watch(developerModeProvider);

    if (!isDeveloperMode) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Developer Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'This section provides additional context for developers working on this portfolio project.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Architecture Notes',
              'The application follows a feature-based architecture with clear separation of concerns. Each feature is self-contained with its own models, providers, and widgets.',
            ),
            const SizedBox(height: 12),
            _buildSection(
              'Component Details',
              'Components are designed to be reusable and responsive. The layout uses Material 3 design principles with adaptive navigation for mobile and desktop.',
            ),
            const SizedBox(height: 12),
            _buildSection(
              'State Management',
              'Riverpod is used for state management throughout the application, providing a clean and testable way to manage application state.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(content),
      ],
    );
  }
}
