import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/landing/skills_provider.dart';
import 'package:portfolio/features/landing/widgets/skill_card.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';

class TechStackGrid extends ConsumerWidget {
  const TechStackGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveGrid(
      spacing: 20,
      childAspectRatio: 2.7,
      children: ref
          .watch(skillsProvider)
          .map((skill) => SkillCard(skill: skill))
          .toList(),
    );
  }
}
