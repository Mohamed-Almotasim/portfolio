import 'package:flutter/material.dart';

class LoadingSkeletonPreview extends StatefulWidget {
  const LoadingSkeletonPreview({super.key});

  @override
  State<LoadingSkeletonPreview> createState() => _LoadingSkeletonPreviewState();
}

class _LoadingSkeletonPreviewState extends State<LoadingSkeletonPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 250;
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Row(
              children: [
                Opacity(
                  opacity: _animation.value,
                  child: CircleAvatar(
                    radius: isCompact ? 16 : 20,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: _animation.value,
                        child: Container(
                          width: isCompact ? 100 : 120,
                          height: isCompact ? 12 : 16,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Opacity(
                        opacity: _animation.value,
                        child: Container(
                          width: isCompact ? 80 : 100,
                          height: isCompact ? 10 : 12,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
