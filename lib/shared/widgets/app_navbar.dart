import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/widgets/theme_toggle_button.dart';

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
    final isDesktop = AppBreakpoints.isDesktop(context);
    final logo = Text(
      'Portfolio',
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isDesktop) logo else Flexible(child: logo),
                const SizedBox(width: 16),

                // Navigation links or hamburger menu
                if (isDesktop) ...[
                  // scaleDown only kicks in for the frames before web fonts load.
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          for (final (i, d) in navDestinations.indexed) ...[
                            if (i > 0) const SizedBox(width: 24),
                            _NavLink(
                              label: d.label,
                              isActive: currentLocation == d.path,
                              onPressed: () => context.go(d.path),
                            ),
                          ],
                          const SizedBox(width: 16),
                          const ThemeToggleButton(),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      const ThemeToggleButton(),
                      IconButton(
                        tooltip: 'Open menu',
                        icon: const Icon(Icons.menu),
                        onPressed: widget.onMenuPressed,
                      ),
                    ],
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
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: widget.isActive
              ? Theme.of(context).colorScheme.primary
              : _isHovered
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
              : Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            decoration: widget.isActive || _isHovered
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Text(widget.label),
      ),
    );
  }
}
