import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/state/theme_mode_provider.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/widgets/app_footer.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';
import 'package:portfolio/shared/widgets/scroll_to_top_button.dart';

class AppPage extends ConsumerStatefulWidget {
  const AppPage({super.key, required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  ConsumerState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  final ScrollController _scrollController = ScrollController();
  // build()'s context is above the Scaffold, so Scaffold.of(context) can't find it.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDeveloperMode = ref.watch(developerModeProvider);
    final scheme = Theme.of(context).colorScheme;
    final currentLocation = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();

    return Scaffold(
      key: _scaffoldKey,
      drawer: !AppBreakpoints.isDesktop(context)
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: scheme.primary),
                    child: Text(
                      'Portfolio',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: scheme.onPrimary),
                    ),
                  ),
                  for (final d in navDestinations)
                    ListTile(
                      title: Text(d.label),
                      selected: currentLocation == d.path,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(d.path);
                      },
                    ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Dark theme'),
                    secondary: const Icon(Icons.dark_mode_outlined),
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (_) => ref
                        .read(themeModeProvider.notifier)
                        .toggle(Theme.of(context).brightness),
                  ),
                  ListTile(
                    title: const Text('Developer Mode'),
                    trailing: Switch(
                      value: isDeveloperMode,
                      onChanged: (value) {
                        ref.read(developerModeProvider.notifier).set(value);
                      },
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: Stack(
        children: [
          // Sticky navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppNavbar(
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),

          // Scrollable content
          Positioned(
            top: 60, // Height of navbar
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxContentWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null) ...[
                          Text(
                            widget.title!,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),
                        ],
                        widget.child,
                        const SizedBox(height: 64),
                        const AppFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Scroll to top button
          ScrollToTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
