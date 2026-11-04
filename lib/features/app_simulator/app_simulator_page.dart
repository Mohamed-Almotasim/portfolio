import 'package:flutter/material.dart';
import 'package:portfolio/features/app_simulator/demo_app_registry.dart';
import 'package:portfolio/features/app_simulator/widgets/app_demo_card.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';

class AppSimulatorPage extends StatelessWidget {
  const AppSimulatorPage({super.key});

  static Widget _card(DemoApp demo) => AppDemoCard(
    title: demo.title,
    description: demo.description,
    demoWidget: demo.demoWidget,
    uiPatterns: demo.uiPatterns,
    layoutStructure: demo.layoutStructure,
    widgetsUsed: demo.widgetsUsed,
    useDeviceFrame: demo.useDeviceFrame,
  );

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Interactive App Demos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore interactive mini Flutter applications embedded right in this portfolio. Click "Launch Demo" to interact with real Flutter UI components.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          ResponsiveGrid(
            childAspectRatio: 1.58,
            children: DemoAppRegistry.demos.map(_card).toList(),
          ),
          const SizedBox(height: 40),
          Text(
            'My Animations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'A space for custom motion studies and reusable animation widgets.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ResponsiveGrid(
            childAspectRatio: 1.7,
            children: DemoAppRegistry.animations.map(_card).toList(),
          ),
        ],
      ),
    );
  }
}
