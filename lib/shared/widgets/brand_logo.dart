import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// Title-block wordmark: initials in a 1px ink cell, then the name in mono.
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
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: deco.ruleStrong)),
          // The cell is fixed, so large text scales the initials down to fit.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              initials(name),
              style: text.headlineSmall?.copyWith(
                fontSize: 13,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        if (showName) ...[
          const SizedBox(width: AppSpacing.s12),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: text.labelLarge,
            ),
          ),
        ],
      ],
    );
  }
}
