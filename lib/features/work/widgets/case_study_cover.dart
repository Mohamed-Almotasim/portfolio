import 'package:flutter/material.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// The case study's cover in a cropped frame. Wrapped in a Hero so it flies
/// from the index (or home) to the case-study header.
class CaseStudyCover extends StatelessWidget {
  const CaseStudyCover({
    super.key,
    required this.project,
    this.aspectRatio = 16 / 10,
  });

  final CaseStudy project;
  final double aspectRatio;

  static String heroTag(CaseStudy c) => 'case-study-cover-${c.slug}';

  @override
  Widget build(BuildContext context) {
    return CropMarks(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Hero(
          tag: heroTag(project),
          // No dedicated cover: show the first app screen, whole, instead
          // of "No image yet". Missing files still fall back to the well.
          child: project.imagePath != null
              ? FigureImage(path: project.imagePath, label: project.title)
              : FigureImage(
                  path: project.media?.screenshots.firstOrNull,
                  label: project.title,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}

/// An image, or a `ground-2` well that says plainly it has no image yet.
/// Never an icon in a box (DESIGN.md §8).
class FigureImage extends StatelessWidget {
  const FigureImage({
    super.key,
    required this.path,
    required this.label,
    this.fit = BoxFit.cover,
  });

  final String? path;

  /// [BoxFit.contain] shows a whole phone screen inside a wider frame.
  final BoxFit fit;

  /// What the image shows; read by screen readers.
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final deco = AppDecorations.of(context);
    final empty = Container(
      color: scheme.surfaceContainerLow,
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(AppSpacing.s12),
      child: Text(
        'No image yet',
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: deco.inkMute),
      ),
    );
    return Semantics(
      image: true,
      label: label,
      child: ExcludeSemantics(
        child: path == null
            ? empty
            : ColoredBox(
                color: scheme.surfaceContainerLow,
                child: Image.asset(
                  path!,
                  fit: fit,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, _, _) => empty,
                ),
              ),
      ),
    );
  }
}

/// A figure with a mono caption below: `Fig. 2 · Booking flow`.
class Figure extends StatelessWidget {
  const Figure({
    super.key,
    required this.number,
    required this.figure,
    this.aspectRatio = 4 / 3,
  });

  final int number;
  final CaseStudyFigure figure;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CropMarks(
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: FigureImage(path: figure.imagePath, label: figure.caption),
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          'Fig. $number · ${figure.caption}',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: deco.inkMute),
        ),
      ],
    );
  }
}
