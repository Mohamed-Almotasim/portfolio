import 'package:flutter/material.dart';

enum SkillCategory {
  language('Languages'),
  framework('Frameworks'),
  backend('Backend & APIs'),
  stateManagement('State management'),
  navigation('Navigation');

  const SkillCategory(this.label);
  final String label;
}

class Skill {
  const Skill({
    required this.name,
    required this.category,
    required this.icon,
    required this.color,
  });

  final String name;
  final SkillCategory category;
  final IconData icon;
  final Color color;
}
