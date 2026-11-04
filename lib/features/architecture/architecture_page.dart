import 'package:flutter/material.dart';

import '../../shared/layout/app_page.dart';
import 'widgets/architecture_details_section.dart';
import 'widgets/architecture_flow_section.dart';
import 'widgets/architecture_overview_diagram.dart';

class ArchitecturePage extends StatelessWidget {
  const ArchitecturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Architecture',
      child: const Column(
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
