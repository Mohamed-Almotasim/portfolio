import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/content/portfolio_content.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/widgets/case_study_card.dart';

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

    test('next case study wraps around to the first', () {
      expect(nextCaseStudy(caseStudies, caseStudies.last), caseStudies.first);
      expect(nextCaseStudy(caseStudies, caseStudies.first), caseStudies[1]);
    });

    test('slugs are unique', () {
      final slugs = caseStudies.map((c) => c.slug).toList();
      expect(slugs.toSet().length, slugs.length);
    });
  });

  group('tech filter', () {
    test('null filter keeps everything', () {
      expect(filterByTech(caseStudies, null), caseStudies);
    });

    test('keeps only case studies using the tech', () {
      final result = filterByTech(caseStudies, 'Firebase');
      expect(result, isNotEmpty);
      expect(result.every((c) => c.techStack.contains('Firebase')), isTrue);
      expect(result.length, lessThan(caseStudies.length));
    });

    test('allTech lists each technology once, sorted', () {
      final tech = allTech(caseStudies);
      expect(tech.toSet().length, tech.length);
      expect(tech, [...tech]..sort());
      expect(tech, contains('Riverpod'));
    });
  });

  group('routes', () {
    testWidgets('/work shows a card per case study', (tester) async {
      await pumpRoute(tester, AppRoutes.work);
      expect(find.byType(CaseStudyCard), findsNWidgets(caseStudies.length));
    });

    testWidgets('/work/:slug shows the case study', (tester) async {
      final study = caseStudies.first;
      await pumpRoute(tester, AppRoutes.caseStudy(study.slug));
      expect(find.text(study.title), findsWidgets);
      expect(find.text('Problem'), findsOneWidget);
      expect(find.text('Next project'), findsOneWidget);
    });

    testWidgets('/work/unknown shows the 404 page', (tester) async {
      await pumpRoute(tester, AppRoutes.caseStudy('nope'));
      expect(find.text('404'), findsOneWidget);
    });

    testWidgets('choosing a tech chip filters the grid', (tester) async {
      await pumpRoute(tester, AppRoutes.work);
      await tester.tap(find.widgetWithText(ChoiceChip, 'Firebase'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.byType(CaseStudyCard),
        findsNWidgets(filterByTech(caseStudies, 'Firebase').length),
      );
    });
  });
}
