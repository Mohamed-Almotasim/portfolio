import 'package:flutter/material.dart';
import 'package:portfolio/features/architecture/widgets/architecture_details_section.dart';
import 'package:portfolio/features/architecture/widgets/architecture_flow_section.dart';
import 'package:portfolio/features/architecture/widgets/architecture_overview_diagram.dart';
import 'package:portfolio/shared/layout/app_page.dart';

class ArchitecturePage extends StatelessWidget {
  const ArchitecturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(
      title: 'Architecture',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArchitectureOverviewDiagram(),
          SizedBox(height: 32),
          ArchitectureFlowSection(),
          SizedBox(height: 32),
          ArchitectureDetailsSection(),
        ],
      ),
    );
  }
}
