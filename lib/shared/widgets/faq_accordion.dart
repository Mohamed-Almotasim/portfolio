import 'package:flutter/material.dart';
import 'package:portfolio/core/content/faq_item.dart';

/// Accordion of questions; one answer open at a time.
class FaqAccordion extends StatefulWidget {
  const FaqAccordion({super.key, required this.items});

  final List<FaqItem> items;

  @override
  State<FaqAccordion> createState() => _FaqAccordionState();
}

class _FaqAccordionState extends State<FaqAccordion> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (i, item) in widget.items.indexed)
          _FaqItemWidget(
            item: item,
            isExpanded: _expandedIndex == i,
            onTap: () =>
                setState(() => _expandedIndex = _expandedIndex == i ? null : i),
          ),
      ],
    );
  }
}

class _FaqItemWidget extends StatefulWidget {
  const _FaqItemWidget({
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  final FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  State<_FaqItemWidget> createState() => _FaqItemWidgetState();
}

class _FaqItemWidgetState extends State<_FaqItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_FaqItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  // #region snippet
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // Question header
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.question,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _iconRotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _iconRotationAnimation.value * 3.14159,
                        child: Icon(
                          Icons.expand_more,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Answer content
          AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.item.answer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // #endregion
}
