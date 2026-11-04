import 'package:flutter/material.dart';

enum SkillCategory { language, framework, backend, stateManagement, navigation }

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
