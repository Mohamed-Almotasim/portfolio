import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';

class AppNavbar extends StatefulWidget {
  const AppNavbar({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  /// Below this width the 7 inline links don't fit; AppPage shows a drawer.
  static const double collapseBelow = 1024;

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();
    final isDesktop =
        MediaQuery.sizeOf(context).width >= AppNavbar.collapseBelow;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Portfolio name/logo
                Text(
                  'Portfolio',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                // Navigation links or hamburger menu
                if (isDesktop) ...[
                  Row(
                    children: [
                      for (final (i, d) in navDestinations.indexed) ...[
                        if (i > 0) const SizedBox(width: 24),
                        _NavLink(
                          label: d.label,
                          isActive: currentLocation == d.path,
                          onPressed: () => context.go(d.path),
                        ),
                      ],
                    ],
                  ),
                ] else ...[
                  // Mobile hamburger menu
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: widget.onMenuPressed,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          color: widget.isActive
              ? Theme.of(context).colorScheme.primary
              : _isHovered
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
              : Theme.of(context).colorScheme.onSurface,
          decoration: widget.isActive || _isHovered
              ? TextDecoration.underline
              : TextDecoration.none,
          decorationColor: Theme.of(context).colorScheme.primary,
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
