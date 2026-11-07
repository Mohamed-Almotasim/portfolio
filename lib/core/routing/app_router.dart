import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/profile.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/features/about/about_page.dart';
import 'package:portfolio/features/contact/contact_page.dart';
import 'package:portfolio/features/landing/landing_page.dart';
import 'package:portfolio/features/not_found/not_found_page.dart';
import 'package:portfolio/features/playground/playground_page.dart'
    deferred as playground;
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/case_study_page.dart';
import 'package:portfolio/features/work/work_page.dart';
import 'package:portfolio/shared/layout/app_shell.dart';
import 'package:portfolio/shared/layout/deferred_page.dart';

/// Browser tab title: `Page — Name`, or `Name — Title` on the home page.
String pageTitle(String path, Profile profile, List<CaseStudy> caseStudies) {
  if (path == AppRoutes.home) return '${profile.name} — ${profile.title}';
  if (path.startsWith('${AppRoutes.work}/')) {
    final slug = path.substring(AppRoutes.work.length + 1);
    final study = caseStudies.where((c) => c.slug == slug).firstOrNull;
    return '${study?.title ?? 'Not found'} — ${profile.name}';
  }
  final label = navDestinations
      .where((d) => d.path == path)
      .map((d) => d.label)
      .firstOrNull;
  return '${label ?? 'Not found'} — ${profile.name}';
}

GoRouter createRouter({
  String initialLocation = AppRoutes.home,
  Profile profile = content.profile,
  List<CaseStudy> caseStudies = content.caseStudies,
}) {
  Widget titled(BuildContext context, String path, Widget child) => Title(
    title: pageTitle(path, profile, caseStudies),
    color: Theme.of(context).colorScheme.primary,
    child: child,
  );

  GoRoute route(String path, Widget Function(GoRouterState state) page) =>
      GoRoute(
        path: path,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: titled(context, state.uri.path, page(state)),
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, _, child) {
            if (MediaQuery.disableAnimationsOf(context)) return child;
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.015),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );

  return GoRouter(
    initialLocation: initialLocation,
    // Pages must not grab focus on push, or keyboard users start inside the
    // page and reach the navbar last. Focus order is set in AppShell.
    requestFocus: false,
    // errorBuilder bypasses ShellRoute, so wrap the 404 in the shell here.
    errorBuilder: (context, state) => AppShell(
      location: state.uri.path,
      child: titled(
        context,
        state.uri.path,
        NotFoundPage(path: state.uri.path),
      ),
    ),
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          route(AppRoutes.home, (_) => const LandingPage()),
          route(AppRoutes.work, (_) => const WorkPage()),
          // A sibling, not a child of /work: a child route would keep the work
          // page laid out offstage underneath, which breaks its SelectionArea.
          route(
            AppRoutes.caseStudy(':slug'),
            (s) => CaseStudyPage(slug: s.pathParameters['slug']!),
          ),
          route(
            AppRoutes.playground,
            (s) => DeferredPage(
              load: playground.loadLibrary,
              builder: (_) => playground.PlaygroundPage(),
            ),
          ),
          route(
            AppRoutes.about,
            (s) => AboutPage(
              showBuilt: s.uri.queryParameters['section'] == 'built',
            ),
          ),
          route(AppRoutes.contact, (_) => const ContactPage()),
          // Old URLs.
          for (final (from, to) in [
            (AppRoutes.uiShowcase, AppRoutes.playground),
            (AppRoutes.widgetGallery, AppRoutes.playground),
            (AppRoutes.appDemos, AppRoutes.playground),
            (AppRoutes.architecture, AppRoutes.aboutBuilt),
            (AppRoutes.services, AppRoutes.contact),
          ])
            GoRoute(path: from, redirect: (_, _) => to),
        ],
      ),
    ],
  );
}

/// Override in tests with `routerProvider.overrideWithValue(createRouter(...))`.
final routerProvider = Provider<GoRouter>((ref) {
  final router = createRouter(
    profile: ref.read(profileProvider),
    caseStudies: ref.read(caseStudiesProvider),
  );
  ref.onDispose(router.dispose);
  return router;
});
