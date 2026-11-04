import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/projects/projects_provider.dart';
import 'package:portfolio/features/services/widgets/project_case_study_card.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';
import 'package:portfolio/shared/widgets/app_section.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage(
      title: 'Projects',
      child: AppSection(
        title: 'App Demos',
        subtitle:
            'Selected product case studies focused on the problem solved, the implementation approach, and the outcome delivered.',
        child: ResponsiveGrid(
          childAspectRatio: 0.78,
          children: ref
              .watch(caseStudiesProvider)
              .map((caseStudy) => ProjectCaseStudyCard(caseStudy: caseStudy))
              .toList(),
        ),
      ),
    );
  }
}
