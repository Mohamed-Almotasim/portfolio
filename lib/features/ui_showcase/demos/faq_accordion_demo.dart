import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/shared/demo/demo_component.dart';

class FaqAccordionDemo extends ConsumerStatefulWidget {
  const FaqAccordionDemo({super.key});

  @override
  ConsumerState<FaqAccordionDemo> createState() => _FaqAccordionDemoState();
}

class _FaqAccordionDemoState extends ConsumerState<FaqAccordionDemo>
    with SingleTickerProviderStateMixin {
  int? _expandedIndex;

  final List<FaqItem> _faqs = [
    FaqItem(
      question: 'What technologies do you use?',
      answer:
          'I primarily work with Flutter for cross-platform mobile development, React for web applications, and Node.js for backend services. I also have experience with various databases, cloud platforms, and modern development tools.',
    ),
    FaqItem(
      question: 'How long does a project take?',
      answer:
          'Project timelines vary depending on complexity and scope. A simple mobile app might take 4-6 weeks, while a full-featured application with backend integration could take 3-6 months. I provide detailed timelines during the planning phase.',
    ),
    FaqItem(
      question: 'Do you build full applications?',
      answer:
          'Yes, I develop complete applications from concept to deployment. This includes UI/UX design, frontend development, backend integration, database design, testing, and deployment to app stores or web hosting platforms.',
    ),
  ];

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoComponent(
      title: 'Expandable FAQ Component',
      description:
          'An accordion-style FAQ component with smooth expand/collapse animations. Features staggered animations and clean typography for an elegant user experience.',
      label: 'UI Pattern',
      demoWidget: Column(
        children: List.generate(_faqs.length, (index) {
          return _FaqItemWidget(
            item: _faqs[index],
            isExpanded: _expandedIndex == index,
            onTap: () => _toggleExpansion(index),
            index: index,
          );
        }),
      ),
      codeSnippet: '''
class FaqAccordionDemo extends ConsumerStatefulWidget {
  // Expandable FAQ accordion with smooth animations
  // Features staggered expansion and clean interactions
  // Demonstrates list-based UI patterns
}''',
    );
  }
}

class _FaqItemWidget extends StatefulWidget {
  const _FaqItemWidget({
    required this.item,
    required this.isExpanded,
    required this.onTap,
    required this.index,
  });

  final FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;
  final int index;

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
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}
