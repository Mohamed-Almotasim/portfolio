import 'package:flutter/material.dart';

class DashboardPreview extends StatelessWidget {
  const DashboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 300;
        final box = _StatBox(compact: compact);
        final chart = Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(5, (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  height: compact ? 20.0 + (index * 4) : 30.0 + (index * 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          }),
        );

        return Column(
          children: [
            // Flexible only works in the Row; the Column has unbounded height.
            compact
                ? Column(children: [box, const SizedBox(height: 8), box])
                : Row(
                    children: [
                      Flexible(child: box),
                      const SizedBox(width: 8),
                      Flexible(child: box),
                    ],
                  ),
            const SizedBox(height: 12),
            SizedBox(height: compact ? 60 : 90, child: chart),
          ],
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 40 : 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      // Horizontal-only: vertical padding left too little room for two lines.
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '123',
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Stats',
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
