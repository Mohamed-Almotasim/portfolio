import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';

class DemoCard extends ConsumerWidget {
  final String title;
  final Widget preview;
  final String code;
  final String explanation;

  const DemoCard({
    super.key,
    required this.title,
    required this.preview,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devMode = ref.watch(developerModeProvider);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 20),

            /// UI PREVIEW
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: preview),
            ),

            const SizedBox(height: 20),

            /// Explanation
            Text(explanation),

            const SizedBox(height: 20),

            /// Developer Mode
            if (devMode) ...[
              const Divider(),
              const SizedBox(height: 10),

              Text("Code", style: Theme.of(context).textTheme.titleMedium),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.black,
                child: Text(
                  code,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
