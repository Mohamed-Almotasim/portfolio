import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layout/responsive_grid.dart';
import '../../projects/projects_provider.dart';
import '../../projects/project_card.dart';

class FeaturedProjectsSection extends ConsumerWidget {
  const FeaturedProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);

    return ResponsiveGrid(
      spacing: 22,
      children: projects
          .map((project) => ProjectCard(project: project))
          .toList(),
    );
  }
}
