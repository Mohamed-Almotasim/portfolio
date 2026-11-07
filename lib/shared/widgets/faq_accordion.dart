import 'package:flutter/material.dart';
import 'package:portfolio/core/content/faq_item.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// Questions as ruled rows; one opens at a time. `+` / `−` in mono marks
/// the state, so it reads without an icon legend.
class FaqAccordion extends StatefulWidget {
  const FaqAccordion({super.key, required this.items});

  final List<FaqItem> items;

  @override
  State<FaqAccordion> createState() => _FaqAccordionState();
}

class _FaqAccordionState extends State<FaqAccordion> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, item) in widget.items.indexed)
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: deco.rule)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  expanded: _open == i,
                  child: InkWell(
                    onTap: () => setState(() => _open = _open == i ? null : i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.s16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(item.question, style: text.titleMedium),
                          ),
                          ExcludeSemantics(
                            child: Text(
                              _open == i ? '−' : '+',
                              style: text.labelLarge?.copyWith(
                                color: deco.accentText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: AppMotion.of(context, AppMotion.measure),
                  curve: AppMotion.curve,
                  alignment: Alignment.topLeft,
                  child: _open == i
                      ? Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.s16,
                            right: AppSpacing.s32,
                          ),
                          child: Text(item.answer, style: text.bodyLarge),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
