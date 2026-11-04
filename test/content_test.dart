import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/portfolio_content.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/features/projects/projects_provider.dart';

void main() {
  test('every nav destination is a registered route', () {
    final paths = AppRouter.router.configuration.routes
        .whereType<GoRoute>()
        .map((r) => r.path)
        .toSet();
    for (final d in navDestinations) {
      expect(paths, contains(d.path), reason: d.label);
    }
  });

  test('shortBio highlight markers are balanced', () {
    expect('*'.allMatches(profile.shortBio).length.isEven, isTrue);
  });

  test('contactLinks ends with a mailto for the profile email', () {
    expect(profile.contactLinks.last.url, 'mailto:${profile.email}');
  });

  test('featured provider returns only featured case studies', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final featured = container.read(featuredCaseStudiesProvider);
    expect(featured, isNotEmpty);
    expect(featured.every((c) => c.featured), isTrue);
  });
}
