import 'package:flutter/material.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';
import 'package:portfolio/shared/widgets/tech_badge.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final CaseStudy project;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  project.tagline,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: project.techStack
                      .map((tech) => TechBadge(label: tech))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final (i, link) in project.links.indexed) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _LinkButton(link: link, primary: i == 0),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({required this.link, required this.primary});

  final CaseStudyLink link;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    void open() => launchUrl(Uri.parse(link.url));
    final icon = Icon(link.icon, size: 18);
    final label = Text(link.label);
    const padding = EdgeInsets.symmetric(vertical: 12);
    return primary
        ? ElevatedButton.icon(
            onPressed: open,
            icon: icon,
            label: label,
            style: ElevatedButton.styleFrom(padding: padding),
          )
        : OutlinedButton.icon(
            onPressed: open,
            icon: icon,
            label: label,
            style: OutlinedButton.styleFrom(padding: padding),
          );
  }
}
