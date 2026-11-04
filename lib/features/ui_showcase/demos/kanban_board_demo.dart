import 'package:flutter/material.dart';
import '../../../shared/demo/demo_component.dart';
import '../widgets/analytics_dashboard_demo.dart';

class KanbanBoardDemo extends StatelessWidget {
  const KanbanBoardDemo({super.key});

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
