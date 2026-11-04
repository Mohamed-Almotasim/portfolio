import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

class ScrollToTopButton extends StatefulWidget {
  const ScrollToTopButton({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(ScrollToTopButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_scrollListener);
      widget.scrollController.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final visible = widget.scrollController.offset >= 400;
    if (visible != _isVisible) setState(() => _isVisible = visible);
  }

  void _scrollToTop() {
    if (MediaQuery.disableAnimationsOf(context)) {
      widget.scrollController.jumpTo(0);
      return;
    }
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: AppSpacing.s24,
      right: AppSpacing.s24,
      child: IgnorePointer(
        ignoring: !_isVisible,
        child: AnimatedSlide(
          offset: _isVisible ? Offset.zero : const Offset(0, 0.5),
          duration: const Duration(milliseconds: 200),
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: AppDecorations.of(context).shadowSoft,
              ),
              child: IconButton.filledTonal(
                tooltip: 'Back to top',
                onPressed: _scrollToTop,
                style: IconButton.styleFrom(
                  backgroundColor: scheme.surfaceContainerHigh,
                  foregroundColor: scheme.onSurface,
                  side: BorderSide(color: scheme.outlineVariant),
                  minimumSize: const Size(48, 48),
                ),
                icon: const Icon(Icons.arrow_upward),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
