import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;

final caseStudiesProvider = Provider<List<CaseStudy>>(
  (ref) => content.caseStudies,
);

final featuredCaseStudiesProvider = Provider<List<CaseStudy>>(
  (ref) => ref.watch(caseStudiesProvider).where((c) => c.featured).toList(),
);
