import 'package:go_router/go_router.dart';
import 'package:portfolio/features/app_simulator/app_simulator_page.dart';
import 'package:portfolio/features/architecture/architecture_page.dart';
import 'package:portfolio/features/contact/contact_page.dart';
import 'package:portfolio/features/landing/landing_page.dart';
import 'package:portfolio/features/not_found/not_found_page.dart';
import 'package:portfolio/features/services/services_page.dart';
import 'package:portfolio/features/ui_showcase/ui_showcase_page.dart';
import 'package:portfolio/features/widget_gallery/ui_patterns_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    errorBuilder: (context, state) => NotFoundPage(path: state.uri.path),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingPage()),
      GoRoute(
        path: '/ui-showcase',
        builder: (context, state) => const UIShowcasePage(),
      ),
      GoRoute(
        path: '/widget-gallery',
        builder: (context, state) => const UIPatternsPage(),
      ),
      GoRoute(
        path: '/architecture',
        builder: (context, state) => const ArchitecturePage(),
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactPage(),
      ),
      GoRoute(
        path: '/app-demos',
        builder: (context, state) => const AppSimulatorPage(),
      ),
    ],
  );
}
