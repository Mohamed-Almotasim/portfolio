import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavbar extends StatefulWidget {
  const AppNavbar({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                      _NavLink(
                        label: 'Home',
                        route: '/',
                        isActive: currentLocation == '/',
                        onPressed: () => context.go('/'),
                      ),
                      const SizedBox(width: 24),
                      _NavLink(
                        label: 'UI Showcase',
                        route: '/ui-showcase',
                        isActive: currentLocation == '/ui-showcase',
                        onPressed: () => context.go('/ui-showcase'),
                      ),
                      const SizedBox(width: 24),
                      _NavLink(
                        label: 'UI Patterns',
                        route: '/widget-gallery',
                        isActive: currentLocation == '/widget-gallery',
                        onPressed: () => context.go('/widget-gallery'),
                      ),
                      const SizedBox(width: 24),
                      _NavLink(
                        label: 'App Demos',
                        route: '/app-demos',
                        isActive: currentLocation == '/app-demos',
                        onPressed: () => context.go('/app-demos'),
                      ),
                      const SizedBox(width: 24),
                      _NavLink(
                        label: 'Architecture',
                        route: '/architecture',
                        isActive: currentLocation == '/architecture',
                        onPressed: () => context.go('/architecture'),
                      ),
                      const SizedBox(width: 24),
                      _NavLink(
                        label: 'Services',
                        route: '/services',
                        isActive: currentLocation == '/services',
                        onPressed: () => context.go('/services'),
                      ),
                      const SizedBox(width: 24),
                      _NavLink(
                        label: 'Contact',
                        route: '/contact',
                        isActive: currentLocation == '/contact',
                        onPressed: () => context.go('/contact'),
                      ),
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
    required this.route,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final String route;
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
              ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
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
