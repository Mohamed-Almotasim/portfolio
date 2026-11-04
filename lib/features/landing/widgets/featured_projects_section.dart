import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/projects/project_card.dart';
import 'package:portfolio/features/projects/projects_provider.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';

class FeaturedProjectsSection extends ConsumerWidget {
  const FeaturedProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(featuredCaseStudiesProvider);

    return ResponsiveGrid(
      spacing: 22,
      children: projects
          .map((project) => ProjectCard(project: project))
          .toList(),
    );
  }
}
