import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/state/theme_mode_provider.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';
import 'package:portfolio/shared/widgets/brand_logo.dart';

/// Built once by the router's ShellRoute: navbar and drawer persist while
/// [child] (the current page) changes underneath.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _scrolled = false;

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A new page always starts at the top.
    if (oldWidget.location != widget.location) _scrolled = false;
  }

  bool _onScroll(ScrollNotification n) {
    if (n.depth == 0 && n.metrics.axis == Axis.vertical) {
      final scrolled = n.metrics.pixels > 4;
      if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    }
    return false;
  }

  bool _devBannerShown = false;

  /// Explains developer mode the first time it's switched on.
  void _maybeShowDevBanner(bool enabled) {
    final messenger = ScaffoldMessenger.of(context);
    if (!enabled) {
      messenger.hideCurrentMaterialBanner();
      return;
    }
    if (_devBannerShown) return;
    _devBannerShown = true;
    messenger.showMaterialBanner(
      MaterialBanner(
        leading: const Icon(Icons.code),
        content: const Text(
          'Developer mode is on. Showcase components now show the real source '
          'they run, and app demos list their layout and widgets.',
        ),
        actions: [
          TextButton(
            onPressed: messenger.hideCurrentMaterialBanner,
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(developerModeProvider, (_, enabled) {
      if (enabled) loadCodeFont();
      _maybeShowDevBanner(enabled);
    });
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppBreakpoints.isDesktop(context)
          ? null
          : _AppDrawer(location: widget.location),
      // The navbar is painted last (on top), but keyboard focus and screen
      // readers should reach it first, so both orders are set explicitly.
      body: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        // Invisible starting point: the first Tab goes to the first item in
        // the order above (the navbar). Routes don't take focus on push.
        child: Focus(
          autofocus: true,
          skipTraversal: true,
          child: Stack(
            children: [
              Positioned.fill(
                child: FocusTraversalOrder(
                  order: const NumericFocusOrder(2),
                  child: Semantics(
                    sortKey: const OrdinalSortKey(2),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: _onScroll,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FocusTraversalOrder(
                  order: const NumericFocusOrder(1),
                  child: Semantics(
                    sortKey: const OrdinalSortKey(1),
                    container: true,
                    explicitChildNodes: true,
                    child: AppNavbar(
                      location: widget.location,
                      scrolled: _scrolled,
                      onMenuPressed: () =>
                          _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer({required this.location});

  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = navDestinations.indexWhere((d) => d.path == location);
    final brightness = Theme.of(context).brightness;
    return NavigationDrawer(
      selectedIndex: index < 0 ? null : index,
      onDestinationSelected: (i) {
        Navigator.pop(context);
        context.go(navDestinations[i].path);
      },
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 16, 16),
          child: BrandLogo(),
        ),
        for (final d in navDestinations)
          NavigationDrawerDestination(icon: Icon(d.icon), label: Text(d.label)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Divider(),
        ),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Dark theme'),
          value: brightness == Brightness.dark,
          onChanged: (_) =>
              ref.read(themeModeProvider.notifier).toggle(brightness),
        ),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          secondary: const Icon(Icons.code),
          title: const Text('Developer mode'),
          value: ref.watch(developerModeProvider),
          onChanged: (v) => ref.read(developerModeProvider.notifier).set(v),
        ),
      ],
    );
  }
}
