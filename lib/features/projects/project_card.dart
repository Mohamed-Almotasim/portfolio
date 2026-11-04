import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';
import 'package:portfolio/shared/widgets/tech_badge.dart';

/// Featured case-study card: preview area, tags, title, tagline, link.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final CaseStudy project;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return HoverCard(
      hoverScale: 1.015,
      child: InkWell(
        onTap: () => context.go(AppRoutes.services),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 168,
              child: project.imagePath == null
                  ? _Placeholder(project: project)
                  : Image.asset(
                      project.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _Placeholder(project: project),
                    ),
            ),
            // The grid gives every card in a row the same height; the link
            // sits at the bottom so the cards line up.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s8,
                      children: [
                        for (final tech in project.techStack)
                          TechBadge(label: tech),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(project.title, style: text.titleLarge),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      project.tagline,
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'View case study',
                          style: text.labelLarge?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: scheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Branded stand-in until a real screenshot is added to the case study.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.project});

  final CaseStudy project;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initials = project.title.split(' ').take(2).map((w) => w[0]).join();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        gradient: AppDecorations.of(context).subtleGradient,
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              initials,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: scheme.primary.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.s16,
            bottom: AppSpacing.s12,
            child: Text(
              '${project.year} · ${project.role}',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
