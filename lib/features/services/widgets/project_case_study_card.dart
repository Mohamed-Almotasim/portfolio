import 'package:flutter/material.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';
import 'package:portfolio/shared/widgets/tech_badge.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCaseStudyCard extends StatelessWidget {
  const ProjectCaseStudyCard({super.key, required this.caseStudy});

  final CaseStudy caseStudy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return HoverCard(
      hoverElevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                caseStudy.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                caseStudy.tagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _CaseStudySection(label: 'Problem', content: caseStudy.problem),
              const SizedBox(height: 12),
              _CaseStudySection(label: 'Solution', content: caseStudy.solution),
              const SizedBox(height: 16),
              Text(
                'Tech Stack',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: caseStudy.techStack
                    .map((tech) => TechBadge(label: tech))
                    .toList(),
              ),
              const SizedBox(height: 16),
              _CaseStudySection(label: 'Result', content: caseStudy.result),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final (i, link) in caseStudy.links.indexed)
                    i == 0
                        ? ElevatedButton.icon(
                            onPressed: () => _openUrl(link.url),
                            icon: Icon(link.icon, size: 18),
                            label: Text(link.label),
                          )
                        : OutlinedButton.icon(
                            onPressed: () => _openUrl(link.url),
                            icon: Icon(link.icon, size: 18),
                            label: Text(link.label),
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) {
    return launchUrl(Uri.parse(url));
  }
}

class _CaseStudySection extends StatelessWidget {
  const _CaseStudySection({required this.label, required this.content});

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.82),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
