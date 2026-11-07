import 'package:flutter/material.dart';
import 'package:portfolio/features/ui_showcase/components_tab.dart';
import 'package:portfolio/shared/layout/app_page.dart';

/// Interactive components. Rebuilt as specimens in the next step.
class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(title: 'Playground', child: ComponentsTab());
  }
}
