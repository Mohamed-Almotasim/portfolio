import 'package:flutter/material.dart';
import '../../../shared/layout/responsive_grid.dart';
import 'skill_card.dart';

class TechStackGrid extends StatelessWidget {
  const TechStackGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final technologies = [
      'Flutter',
      'Dart',
      'Firebase',
      'REST APIs',
      'Riverpod',
      'GoRouter',
    ];

    return ResponsiveGrid(
      spacing: 20,
      childAspectRatio: 2.7,
      children: technologies.map((tech) => SkillCard(name: tech)).toList(),
    );
  }
}
