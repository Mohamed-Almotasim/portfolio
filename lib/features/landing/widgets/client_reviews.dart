import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/testimonial.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/utils/link_launcher.dart';
import 'package:portfolio/shared/widgets/app_section.dart';

final testimonialsProvider = Provider<List<Testimonial>>(
  (ref) => content.testimonials,
);

/// Client reviews as ruled quote blocks: two columns from tablet up, one on
/// phones. Each quote keeps its reviewer and country, in mono.
class ClientReviews extends ConsumerWidget {
  const ClientReviews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(testimonialsProvider);
    if (reviews.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, c) {
        final columns = c.maxWidth >= 720 ? 2 : 1;
        const gap = AppSpacing.s48;
        final itemWidth = (c.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: AppSpacing.s32,
          children: [
            for (final (i, r) in reviews.indexed)
              SizedBox(
                width: itemWidth,
                child: _Review(review: r, index: i),
              ),
          ],
        );
      },
    );
  }
}

class _Review extends StatelessWidget {
  const _Review({required this.review, required this.index});

  final Testimonial review;
  final int index;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final mute = text.labelSmall?.copyWith(color: deco.inkMute);

    return Inspectable(
      label: 'Review',
      child: Container(
        padding: const EdgeInsets.only(top: AppSpacing.s16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: deco.ruleStrong)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${(index + 1).toString().padLeft(2, '0')} · '
              '${review.source} review',
              style: mute,
            ),
            const SizedBox(height: AppSpacing.s12),
            Text('“${review.quote}”', style: text.titleMedium),
            const SizedBox(height: AppSpacing.s12),
            Text(
              '${review.author} · ${review.country}',
              style: text.labelMedium?.copyWith(color: deco.accentText),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section action: opens the full review list on Fiverr.
class FiverrReviewsLink extends ConsumerWidget {
  const FiverrReviewsLink({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ArrowLink(
    label: 'All reviews on Fiverr',
    onPressed: () =>
        openLink(context, ref, Uri.parse(content.fiverrProfileUrl)),
  );
}
