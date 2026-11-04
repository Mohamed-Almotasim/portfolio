import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/shared/widgets/code_viewer.dart';

class DemoComponent extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final Widget demoWidget;
  final String codeSnippet;
  final String? label;

  const DemoComponent({
    super.key,
    required this.title,
    required this.description,
    required this.demoWidget,
    required this.codeSnippet,
    this.label,
  });

  @override
  ConsumerState<DemoComponent> createState() => _DemoComponentState();
}

class _DemoComponentState extends ConsumerState<DemoComponent>
    with SingleTickerProviderStateMixin {
  bool _showCode = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCode() {
    setState(() {
      _showCode = !_showCode;
      if (_showCode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isDeveloperMode = ref.watch(developerModeProvider);
        return LayoutBuilder(
          builder: (context, constraints) {
            // Constrain max width for better UX on very wide screens
            final maxCardWidth = constraints.maxWidth > 600
                ? 600.0
                : constraints.maxWidth;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxCardWidth),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label
                          if (widget.label != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.label!,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Title
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 16),

                          // Live widget preview area
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: widget.demoWidget,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description - remove maxLines to allow natural wrapping
                          Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 16),

                          // Code section
                          if (isDeveloperMode) ...[
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Code',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                TextButton.icon(
                                  onPressed: _toggleCode,
                                  icon: AnimatedRotation(
                                    turns: _showCode ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(Icons.code),
                                  ),
                                  label: Text(
                                    _showCode ? 'Hide Code' : 'Show Code',
                                  ),
                                ),
                              ],
                            ),
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
                                margin: const EdgeInsets.only(top: 12),
                                child: CodeViewer(code: widget.codeSnippet),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
