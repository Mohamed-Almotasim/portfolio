import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/shared/demo/demo_component.dart';

class DashboardCardDemo extends ConsumerStatefulWidget {
  const DashboardCardDemo({super.key});

  @override
  ConsumerState<DashboardCardDemo> createState() => _DashboardCardDemoState();
}

class _DashboardCardDemoState extends ConsumerState<DashboardCardDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _usersAnimation;
  late Animation<double> _revenueAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _usersAnimation = Tween<double>(begin: 0, end: 1248).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _revenueAnimation = Tween<double>(begin: 0, end: 12540).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoComponent(
      title: 'Interactive Dashboard Card',
      description:
          'A dynamic dashboard widget featuring animated statistics, mini charts, and hover effects. Perfect for displaying key metrics with smooth number animations.',
      label: 'Component',
      demoWidget: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;

          if (isCompact) {
            return Column(
              children: [
                _MetricCard(
                  title: 'Users Online',
                  value: _usersAnimation.value.toInt(),
                  change: '+12%',
                  changeColor: Colors.green,
                  icon: Icons.people,
                  animation: _usersAnimation,
                ),
                const SizedBox(height: 16),
                _MetricCard(
                  title: 'Revenue',
                  value: _revenueAnimation.value.toInt(),
                  prefix: '\$',
                  change: '+8%',
                  changeColor: Colors.green,
                  icon: Icons.attach_money,
                  animation: _revenueAnimation,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Users Online',
                  value: _usersAnimation.value.toInt(),
                  change: '+12%',
                  changeColor: Colors.green,
                  icon: Icons.people,
                  animation: _usersAnimation,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricCard(
                  title: 'Revenue',
                  value: _revenueAnimation.value.toInt(),
                  prefix: '\$',
                  change: '+8%',
                  changeColor: Colors.green,
                  icon: Icons.attach_money,
                  animation: _revenueAnimation,
                ),
              ),
            ],
          );
        },
      ),
      sourcePath: 'lib/features/ui_showcase/demos/dashboard_card_demo.dart',
    );
  }
}

class _MetricCard extends StatefulWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.changeColor,
    required this.icon,
    required this.animation,
    this.prefix = '',
  });

  final String title;
  final int value;
  final String change;
  final Color changeColor;
  final IconData icon;
  final Animation<double> animation;
  final String prefix;

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool _isHovered = false;

  @override
  // #region snippet
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Spacer(),
                Text(
                  widget.change,
                  style: TextStyle(
                    color: widget.changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {
                return Text(
                  '${widget.prefix}${widget.value}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Mini chart
            SizedBox(
              height: 20,
              child: Row(
                children: List.generate(
                  10,
                  (index) => Container(
                    width: 4,
                    height: (index % 3 + 1) * 4.0,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // #endregion
}
