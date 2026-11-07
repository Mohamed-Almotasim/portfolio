import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/portfolio_content.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/work_page.dart';

import 'helpers/pump_app.dart';

Future<void> pumpRoute(WidgetTester tester, String path) =>
    pumpApp(tester, path: path, size: const Size(1280, 2400));

void main() {
  group('case study lookup', () {
    test('finds a case study by slug', () {
      final first = caseStudies.first;
      expect(caseStudyBySlug(caseStudies, first.slug), same(first));
    });

    test('returns null for an unknown slug', () {
      expect(caseStudyBySlug(caseStudies, 'does-not-exist'), isNull);
    });

    test('next and previous wrap around', () {
      expect(nextCaseStudy(caseStudies, caseStudies.last), caseStudies.first);
      expect(nextCaseStudy(caseStudies, caseStudies.first), caseStudies[1]);
      expect(
        previousCaseStudy(caseStudies, caseStudies.first),
        caseStudies.last,
      );
    });

    test('slugs are unique', () {
      final slugs = caseStudies.map((c) => c.slug).toList();
      expect(slugs.toSet().length, slugs.length);
    });
  });

  group('type filter', () {
    test('null filter keeps everything', () {
      expect(filterByType(caseStudies, null), caseStudies);
    });

    test('keeps only case studies of that type', () {
      final type = caseStudies.first.type;
      final result = filterByType(caseStudies, type);
      expect(result, isNotEmpty);
      expect(result.every((c) => c.type == type), isTrue);
      expect(result.length, lessThan(caseStudies.length));
    });

    test('allTypes lists each type once, in first-seen order', () {
      final types = allTypes(caseStudies);
      expect(types.toSet().length, types.length);
      expect(types.first, caseStudies.first.type);
    });
  });

  group('links', () {
    test('template example.com links are never treated as real', () {
      const fake = CaseStudyLink(
        label: 'Demo',
        url: 'https://demo.example.com/x',
        icon: Icons.launch,
      );
      const real = CaseStudyLink(
        label: 'Demo',
        url: 'https://apps.apple.com/app/x',
        icon: Icons.launch,
      );
      expect(fake.isReal, isFalse);
      expect(real.isReal, isTrue);
    });
  });

  group('routes', () {
    testWidgets('/work lists a register row per case study', (tester) async {
      await pumpRoute(tester, AppRoutes.work);
      expect(find.byType(RegisterRow), findsNWidgets(caseStudies.length));
    });

    testWidgets('/work/:slug shows the spec sheet, without fake links', (
      tester,
    ) async {
      final study = caseStudies.first;
      await pumpRoute(tester, AppRoutes.caseStudy(study.slug));
      expect(find.text(study.title), findsWidgets);
      for (final heading in ['Problem', 'Approach', 'Result']) {
        expect(find.text(heading), findsOneWidget);
      }
      expect(find.text('Next project'), findsOneWidget);
      expect(find.text('Previous project'), findsOneWidget);
      expect(find.textContaining(study.gallery.first.caption), findsOneWidget);
      // Every link in the content is still an example.com template.
      expect(find.text('Live Demo'), findsNothing);
    });

    testWidgets('/work/unknown shows the 404 page', (tester) async {
      await pumpRoute(tester, AppRoutes.caseStudy('nope'));
      expect(find.text('404'), findsOneWidget);
    });

    testWidgets('choosing a type chip filters the register', (tester) async {
      await pumpRoute(tester, AppRoutes.work);
      final type = caseStudies.first.type;
      await tester.tap(find.widgetWithText(ChoiceChip, type));
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.byType(RegisterRow),
        findsNWidgets(filterByType(caseStudies, type).length),
      );
    });

    testWidgets('a register row opens its case study', (tester) async {
      final router = await pumpApp(
        tester,
        path: AppRoutes.work,
        size: const Size(1280, 2400),
      );
      await tester.tap(find.byType(RegisterRow).at(1));
      await settle(tester);
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.caseStudy(caseStudies[1].slug),
      );
    });
  });
}
