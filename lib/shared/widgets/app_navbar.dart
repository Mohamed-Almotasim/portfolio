import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/widgets/brand_logo.dart';
import 'package:portfolio/shared/widgets/theme_toggle_button.dart';

/// Sticky top bar. Transparent at the top of a page; frosted glass with a
/// hairline border once [scrolled]. Collapses to a drawer below the tablet
/// breakpoint.
class AppNavbar extends StatelessWidget {
  const AppNavbar({
    super.key,
    required this.location,
    this.scrolled = false,
    this.onMenuPressed,
  });

  static const double height = 64;

  final String location;
  final bool scrolled;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final deco = AppDecorations.of(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    // The full name only fits next to 7 links on wide screens.
    final showName = !isDesktop || MediaQuery.sizeOf(context).width >= 1200;

    return ClipRect(
      child: BackdropFilter(
        enabled: scrolled,
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          decoration: BoxDecoration(
            color: scrolled
                ? deco.glassSurface
                : Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(
                color: scrolled
                    ? scheme.outlineVariant
                    : scheme.outlineVariant.withValues(alpha: 0),
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                child: Row(
                  children: [
                    Flexible(
                      flex: isDesktop ? 0 : 1,
                      child: Semantics(
                        button: true,
                        label: 'Home',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          onTap: () => context.go(AppRoutes.home),
                          child: BrandLogo(showName: showName),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    if (isDesktop)
                      Expanded(
                        // scaleDown only kicks in for frames before web fonts load.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              for (final d in navDestinations)
                                _NavLink(
                                  label: d.label,
                                  isActive: location == d.path,
                                  onPressed: () => context.go(d.path),
                                ),
                              const SizedBox(width: AppSpacing.s16),
                              const ThemeToggleButton(),
                              const _DevModeButton(),
                              const SizedBox(width: AppSpacing.s8),
                              FilledButton(
                                onPressed: () => context.go(AppRoutes.contact),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.s16,
                                    vertical: AppSpacing.s12,
                                  ),
                                ),
                                child: const Text('Hire me'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      const Spacer(),
                      const ThemeToggleButton(),
                      IconButton(
                        tooltip: 'Open menu',
                        icon: const Icon(Icons.menu),
                        onPressed: onMenuPressed,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DevModeButton extends ConsumerWidget {
  const _DevModeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(developerModeProvider);
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: on
          ? 'Developer mode on: hide source code'
          : 'Developer mode: show the code behind each demo',
      isSelected: on,
      onPressed: () => ref.read(developerModeProvider.notifier).toggle(),
      icon: const Icon(Icons.code),
      style: IconButton.styleFrom(
        foregroundColor: on ? scheme.primary : scheme.onSurface,
        backgroundColor: on
            ? scheme.primaryContainer
            : scheme.primaryContainer.withValues(alpha: 0),
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
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final highlighted = widget.isActive || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: highlighted
              ? scheme.onSurface
              : scheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s8,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.label),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 2,
              width: widget.isActive ? 20 : (_hovered ? 10 : 0),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
