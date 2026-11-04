import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// Monogram (initials from Profile.name) plus, optionally, the full name.
class BrandLogo extends ConsumerWidget {
  const BrandLogo({super.key, this.showName = true});

  final bool showName;

  static String initials(String name) => name
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .take(2)
      .map((w) => w[0].toUpperCase())
      .join();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(profileProvider).name;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          ),
          child: Text(
            initials(name),
            style: text.titleSmall?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        if (showName) ...[
          const SizedBox(width: AppSpacing.s12),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ],
    );
  }
}
