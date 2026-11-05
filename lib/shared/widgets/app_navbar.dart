import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/brand_logo.dart';
import 'package:portfolio/shared/widgets/theme_toggle_button.dart';

/// The title block: a plain paper strip with a full-ink bottom rule, mono
/// links, the Inspect toggle and one action. Collapses to a drawer below
/// the tablet breakpoint. No blur, no glass (docs/DESIGN.md §8).
class AppNavbar extends StatelessWidget {
  const AppNavbar({
    super.key,
    required this.location,
    this.scrolled = false,
    this.onMenuPressed,
  });

  static const double height = 64;

  final String location;

  /// Kept for AppShell; the bar looks the same at every scroll position.
  final bool scrolled;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppBreakpoints.tablet;
    final margin = AppSpacing.margin(width);

    return Inspectable(
      label: 'AppNavbar',
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(bottom: BorderSide(color: deco.ruleStrong)),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth + margin * 2,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: margin),
              child: Row(
                children: [
                  Flexible(
                    flex: isDesktop ? 0 : 1,
                    child: Semantics(
                      button: true,
                      label: 'Home',
                      excludeSemantics: true,
                      child: InkWell(
                        onTap: () => context.go(AppRoutes.home),
                        child: BrandLogo(showName: width >= 360),
                      ),
                    ),
                  ),
                  if (isDesktop) ...[
                    const SizedBox(width: AppSpacing.s24),
                    Expanded(
                      // scaleDown only matters at 1024–1100 with 7 links.
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
                            const InspectToggle(),
                            const SizedBox(width: AppSpacing.s12),
                            FilledButton(
                              onPressed: () => context.go(AppRoutes.contact),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.s16,
                                ),
                                minimumSize: const Size(44, 40),
                              ),
                              child: const Text('Start a project'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
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
    );
  }
}

/// Turns Inspector mode (developer mode) on and off. Labelled, so its state
/// reads without an icon legend.
class InspectToggle extends ConsumerWidget {
  const InspectToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(developerModeProvider);
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      toggled: on,
      child: TextButton(
        onPressed: () => ref.read(developerModeProvider.notifier).toggle(),
        style: TextButton.styleFrom(
          foregroundColor: on ? deco.accentText : scheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
        ),
        child: Tooltip(
          message: on
              ? 'Inspector mode on: hide layout and code'
              : 'Inspector mode: show the layout and code behind the site',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // A 10px box: outlined off, filled on.
              AnimatedContainer(
                duration: AppMotion.of(context, AppMotion.snap),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: on ? deco.accent : null,
                  border: Border.all(color: on ? deco.accent : deco.inkMute),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              const Text('Inspect'),
            ],
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
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final deco = AppDecorations.of(context);
    final text = Theme.of(context).textTheme;
    final active = widget.isActive;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: active ? deco.accentText : scheme.onSurface,
          textStyle: text.labelMedium,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          minimumSize: const Size(44, 44),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        // Underline the width of the label: 2px accent active, 1px ink hover.
        child: AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.snap),
          curve: AppMotion.curve,
          padding: const EdgeInsets.only(top: 6, bottom: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: active
                    ? deco.accent
                    : _hovered
                    ? scheme.onSurface
                    : deco.accent.withValues(alpha: 0),
              ),
            ),
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
