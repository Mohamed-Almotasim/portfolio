import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
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
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: AppRoutes.uiShowcase,
        builder: (context, state) => const UIShowcasePage(),
      ),
      GoRoute(
        path: AppRoutes.widgetGallery,
        builder: (context, state) => const UIPatternsPage(),
      ),
      GoRoute(
        path: AppRoutes.architecture,
        builder: (context, state) => const ArchitecturePage(),
      ),
      GoRoute(
        path: AppRoutes.services,
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: AppRoutes.contact,
        builder: (context, state) => const ContactPage(),
      ),
      GoRoute(
        path: AppRoutes.appDemos,
        builder: (context, state) => const AppSimulatorPage(),
      ),
    ],
  );
}
