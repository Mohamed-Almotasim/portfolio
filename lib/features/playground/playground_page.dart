import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/ui_showcase/components_tab.dart';
import 'package:portfolio/features/widget_gallery/patterns_tab.dart';
import 'package:portfolio/shared/layout/app_page.dart';

/// One home for live UI work: interactive components and product patterns.
/// The tab lives in the URL (`?tab=patterns`) so it can be linked and shared.
class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key, this.showPatterns = false});

  final bool showPatterns;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Playground',
      child: DefaultTabController(
        // Keyed so a URL change (back/forward) resets the selected tab.
        key: ValueKey(showPatterns),
        length: 2,
        initialIndex: showPatterns ? 1 : 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              onTap: (i) => context.go(
                i == 1 ? AppRoutes.playgroundPatterns : AppRoutes.playground,
              ),
              tabs: const [
                Tab(text: 'Components'),
                Tab(text: 'Patterns'),
              ],
            ),
            const SizedBox(height: AppSpacing.s32),
            if (showPatterns) const PatternsTab() else const ComponentsTab(),
          ],
        ),
      ),
    );
  }
}
