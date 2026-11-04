import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_navbar.dart';
import '../widgets/app_footer.dart';
import '../widgets/scroll_to_top_button.dart';
import '../../core/state/developer_mode_provider.dart';

class AppPage extends ConsumerStatefulWidget {
  const AppPage({super.key, required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  ConsumerState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDeveloperMode = ref.watch(developerModeProvider);
    final currentLocation = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();

    return Scaffold(
      drawer: MediaQuery.of(context).size.width <= 600
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text(
                      'Portfolio',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    selected: currentLocation == '/',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/');
                    },
                  ),
                  ListTile(
                    title: const Text('UI Showcase'),
                    selected: currentLocation == '/ui-showcase',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/ui-showcase');
                    },
                  ),
                  ListTile(
                    title: const Text('UI Patterns'),
                    selected: currentLocation == '/widget-gallery',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/widget-gallery');
                    },
                  ),
                  ListTile(
                    title: const Text('Architecture'),
                    selected: currentLocation == '/architecture',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/architecture');
                    },
                  ),
                  ListTile(
                    title: const Text('Services'),
                    selected: currentLocation == '/services',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/services');
                    },
                  ),
                  ListTile(
                    title: const Text('App Demos'),
                    selected: currentLocation == '/app-demos',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/app-demos');
                    },
                  ),
                  ListTile(
                    title: const Text('Contact'),
                    selected: currentLocation == '/contact',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/contact');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Developer Mode'),
                    trailing: Switch(
                      value: isDeveloperMode,
                      onChanged: (value) {
                        ref.read(developerModeProvider.notifier).state = value;
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
              onMenuPressed: () => Scaffold.of(context).openDrawer(),
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
                  constraints: const BoxConstraints(maxWidth: 1100),
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
