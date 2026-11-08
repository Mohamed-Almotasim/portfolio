import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// The owner's portrait as a spec-sheet figure: a 4:5 frame inside crop
/// marks, with a mono caption. Renders nothing when there is no photo or the
/// file fails to load.
class ProfilePhoto extends ConsumerWidget {
  const ProfilePhoto({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final path = profile.photo;
    if (path == null) return const SizedBox.shrink();

    final deco = AppDecorations.of(context);
    final caption = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: deco.inkMute);

    return Inspectable(
      label: 'ProfilePhoto',
      note:
          'Cropped 4:5 and compressed to ~85 KB; cacheWidth decodes it at '
          'display size.',
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CropMarks(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: deco.ruleStrong),
                ),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    cacheWidth: (width * MediaQuery.devicePixelRatioOf(context))
                        .round(),
                    semanticLabel: 'Photo of ${profile.name}',
                    errorBuilder: (_, _, _) =>
                        ColoredBox(color: deco.codeBackground),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Text('${profile.name} · ${profile.location}', style: caption),
          ],
        ),
      ),
    );
  }
}
