import 'package:flutter/material.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// Screenshot if the case study has one, otherwise a branded placeholder.
/// Wrapped in a Hero so it flies from the card to the detail header.
class CaseStudyCover extends StatelessWidget {
  const CaseStudyCover({super.key, required this.project, this.height = 168});

  final CaseStudy project;
  final double height;

  static String heroTag(CaseStudy c) => 'case-study-cover-${c.slug}';

  @override
  Widget build(BuildContext context) {
    final placeholder = _Placeholder(project: project);
    return Hero(
      tag: heroTag(project),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: project.imagePath == null
            ? placeholder
            : Image.asset(
                project.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
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
      decoration: BoxDecoration(color: scheme.surfaceContainer),
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
