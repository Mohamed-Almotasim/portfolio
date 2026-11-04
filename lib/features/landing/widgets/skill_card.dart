import 'package:flutter/material.dart';
import 'package:portfolio/core/content/skill.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({super.key, required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    // Pull the brand color toward the text color so labels pass contrast in both themes.
    final color = Color.lerp(
      skill.color,
      Theme.of(context).colorScheme.onSurface,
      0.3,
    )!;

    return HoverCard(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(skill.icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              skill.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
