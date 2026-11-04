import 'package:flutter/material.dart';
import 'package:portfolio/features/ui_showcase/widgets/analytics_dashboard_demo.dart';
import 'package:portfolio/shared/demo/demo_component.dart';

class AnalyticsDashboardDemoCard extends StatelessWidget {
  const AnalyticsDashboardDemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoComponent(
      title: 'Analytics Dashboard',
      description:
          'Responsive dashboard widget with animated metrics and chart visualization.',
      label: 'UI Pattern',
      demoWidget: AnalyticsDashboardDemo(),
      codeSnippet: '''
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 350) {
      return Column(children: statCards);
    }

    return Row(
      children: [
        for (final card in statCards) Expanded(child: card),
      ],
    );
  },
)
''',
    );
  }
}
