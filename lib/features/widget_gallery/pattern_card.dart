import 'package:flutter/material.dart';

import '../../shared/widgets/hover_card.dart';

class PatternCard extends StatelessWidget {
  const PatternCard({
    super.key,
    required this.name,
    required this.description,
    required this.category,
    required this.preview,
  });

  final String name;
  final String description;
  final String category;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverCard(
      hoverElevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    category,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(
                minHeight: 140,
                maxHeight: 220,
              ),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.transparent,
                  child: preview,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
