import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

/// A numbered sheet of the drawing set (docs/DESIGN.md §5): hairline on top,
/// `01` in mono on the heading's baseline, the heading, an optional one-line
/// [lead] and an optional [action] link at the far end.
class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.number,
    this.lead,
    this.action,
    this.inspectLabel,
    this.inspectNote,
    this.inspectSource,
  });

  final String title;

  /// e.g. `01`. Only where the order is real (DESIGN.md §10).
  final String? number;
  final String? lead;
  final Widget? action;
  final Widget child;

  /// Inspector tag; defaults to the title.
  final String? inspectLabel;

  /// Inspector note and source (`lib/…:line` of the `AppSection(` call).
  final String? inspectNote;
  final String? inspectSource;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final width = MediaQuery.sizeOf(context).width;

    final heading = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (number != null)
          SizedBox(
            width: width < AppBreakpoints.mobile ? 40 : 64,
            child: Text(
              number!,
              style: text.labelMedium?.copyWith(color: deco.inkMute),
            ),
          ),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: text.headlineLarge),
          ),
        ),
        if (action != null && width >= AppBreakpoints.mobile) action!,
      ],
    );

    return Inspectable(
      label: inspectLabel ?? title,
      note: inspectNote,
      source: inspectSource,
      tokens: const [
        'AppSpacing.section',
        'AppSpacing.s48',
        'headlineLarge',
        'AppDecorations.rule',
      ],
      child: Padding(
        padding: EdgeInsets.only(top: AppSpacing.section(width) * deco.space),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: deco.rule),
            const SizedBox(height: AppSpacing.s24),
            heading,
            if (lead != null) ...[
              const SizedBox(height: AppSpacing.s12),
              Padding(
                padding: EdgeInsets.only(
                  left: number == null
                      ? 0
                      : (width < AppBreakpoints.mobile ? 40 : 64),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    lead!,
                    style: text.bodyLarge?.copyWith(color: deco.inkMute),
                  ),
                ),
              ),
            ],
            SizedBox(height: AppSpacing.s48 * deco.space),
            child,
            if (action != null && width < AppBreakpoints.mobile) ...[
              const SizedBox(height: AppSpacing.s24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// A mono "View all →" style link for [AppSection.action] and elsewhere.
class ArrowLink extends StatelessWidget {
  const ArrowLink({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text('$label →'));
  }
}
