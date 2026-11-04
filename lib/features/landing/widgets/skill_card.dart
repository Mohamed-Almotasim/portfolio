import 'package:flutter/material.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final color = _getColorForSkill(name);
    final icon = _getIconForSkill(name);

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
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              name,
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

  Color _getColorForSkill(String skill) {
    switch (skill) {
      case 'Flutter':
        return Colors.blue;
      case 'Dart':
        return Colors.cyan;
      case 'Firebase':
        return Colors.orange;
      case 'REST APIs':
        return Colors.green;
      case 'Riverpod':
        return Colors.purple;
      case 'GoRouter':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForSkill(String skill) {
    switch (skill) {
      case 'Flutter':
        return Icons.flutter_dash;
      case 'Dart':
        return Icons.code;
      case 'Firebase':
        return Icons.cloud;
      case 'REST APIs':
        return Icons.api;
      case 'Riverpod':
        return Icons.data_object;
      case 'GoRouter':
        return Icons.route;
      default:
        return Icons.star;
    }
  }
}
