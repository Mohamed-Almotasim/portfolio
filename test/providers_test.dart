import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/content/portfolio_content.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/state/theme_mode_provider.dart';
import 'package:portfolio/features/landing/proof_stats_provider.dart';
import 'package:portfolio/features/widget_gallery/ui_pattern.dart';
import 'package:portfolio/features/widget_gallery/widget_gallery_search_provider.dart';

ProviderContainer _container() {
  final c = ProviderContainer();
  addTearDown(c.dispose);
  return c;
}

bool _isLinkable(String url) =>
    url.isEmpty ||
    (Uri.tryParse(url)?.hasScheme ?? false) &&
        ['http', 'https', 'mailto'].contains(Uri.parse(url).scheme);

void main() {
  group('developer mode', () {
    test('starts off, toggles and can be set', () {
      final c = _container();
      final n = c.read(developerModeProvider.notifier);
      expect(c.read(developerModeProvider), isFalse);
      n.toggle();
      expect(c.read(developerModeProvider), isTrue);
      n.set(false);
      expect(c.read(developerModeProvider), isFalse);
    });
  });

  group('theme mode', () {
    test('follows the system until the visitor picks', () {
      expect(_container().read(themeModeProvider), ThemeMode.system);
    });

    test('toggle flips whatever is shown, even from system', () {
      final c = _container();
      final n = c.read(themeModeProvider.notifier)..set(ThemeMode.system);
      n.toggle(Brightness.light);
      expect(c.read(themeModeProvider), ThemeMode.dark);
      n.toggle(Brightness.dark);
      expect(c.read(themeModeProvider), ThemeMode.light);
    });
  });

  group('UI pattern filters', () {
    test('query and category notifiers hold their values', () {
      final c = _container();
      c.read(uiPatternsSearchProvider.notifier).setQuery('auth');
      c
          .read(uiPatternsCategoryProvider.notifier)
          .setCategory(UiPatternCategory.form);
      expect(c.read(uiPatternsSearchProvider), 'auth');
      expect(c.read(uiPatternsCategoryProvider), UiPatternCategory.form);
    });

    test('matches searches name, description and category, any case', () {
      final auth = uiPatterns.firstWhere((p) => p.name.contains('Auth'));
      expect(auth.matches('LOGIN'), isTrue); // description
      expect(auth.matches('form'), isTrue); // category label
      expect(auth.matches('zzz'), isFalse);
      expect(auth.matches(''), isTrue);
    });
  });

  group('content', () {
    test('every link is http(s), mailto or deliberately empty', () {
      final urls = [
        for (final s in profile.contactLinks) s.url,
        for (final c in caseStudies)
          for (final l in c.links) l.url,
      ];
      for (final url in urls) {
        expect(_isLinkable(url), isTrue, reason: url);
      }
    });

    test('nav destinations have unique labels and paths', () {
      final paths = navDestinations.map((d) => d.path).toList();
      final labels = navDestinations.map((d) => d.label).toList();
      expect(paths.toSet().length, paths.length);
      expect(labels.toSet().length, labels.length);
    });

    test('skills, services and FAQs are non-empty and unique by name', () {
      final skillNames = skills.map((s) => s.name).toList();
      expect(skillNames.toSet().length, skillNames.length);
      expect(serviceOfferings, isNotEmpty);
      expect(faqs.map((f) => f.question).toSet().length, faqs.length);
    });

    test('the proof strip only shows stats that have a value', () {
      final stats = _container().read(proofStatsProvider);
      expect(stats, isNotEmpty);
      expect(stats.every((s) => s.value != null), isTrue);
    });
  });
}
