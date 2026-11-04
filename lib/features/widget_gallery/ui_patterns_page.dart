import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/widget_gallery/pattern_card.dart';
import 'package:portfolio/features/widget_gallery/ui_pattern.dart';
import 'package:portfolio/features/widget_gallery/widget_gallery_search_provider.dart';
import 'package:portfolio/shared/layout/app_page.dart';

class UIPatternsPage extends ConsumerWidget {
  const UIPatternsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(uiPatternsSearchProvider);
    final selectedCategory = ref.watch(uiPatternsCategoryProvider);

    final filteredPatterns = uiPatterns
        .where(
          (p) =>
              (selectedCategory == null || p.category == selectedCategory) &&
              p.matches(searchQuery),
        )
        .toList();

    return AppPage(
      title: 'UI Patterns',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Production-oriented interface patterns that reflect real product needs rather than basic widget demos.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [null, ...UiPatternCategory.values].map((category) {
              return ChoiceChip(
                label: Text(category?.label ?? 'All'),
                selected: selectedCategory == category,
                onSelected: (_) {
                  ref
                      .read(uiPatternsCategoryProvider.notifier)
                      .setCategory(category);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search UI patterns (dashboard, auth, loading...)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(uiPatternsSearchProvider.notifier).setQuery(value);
              },
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 16.0;
              final columnCount = constraints.maxWidth >= 560 ? 2 : 1;
              final cardWidth =
                  (constraints.maxWidth - (spacing * (columnCount - 1))) /
                  columnCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: filteredPatterns.map((pattern) {
                  return SizedBox(
                    width: cardWidth,
                    child: PatternCard(
                      name: pattern.name,
                      description: pattern.description,
                      category: pattern.category.label,
                      preview: pattern.preview,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
