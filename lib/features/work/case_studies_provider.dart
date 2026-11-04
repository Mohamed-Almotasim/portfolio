import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;

final caseStudiesProvider = Provider<List<CaseStudy>>(
  (ref) => content.caseStudies,
);

final featuredCaseStudiesProvider = Provider<List<CaseStudy>>(
  (ref) => ref.watch(caseStudiesProvider).where((c) => c.featured).toList(),
);

CaseStudy? caseStudyBySlug(List<CaseStudy> all, String slug) =>
    all.where((c) => c.slug == slug).firstOrNull;

/// The one after [current], wrapping to the first.
CaseStudy nextCaseStudy(List<CaseStudy> all, CaseStudy current) =>
    all[(all.indexOf(current) + 1) % all.length];

/// `null` keeps everything.
List<CaseStudy> filterByTech(List<CaseStudy> all, String? tech) =>
    tech == null ? all : all.where((c) => c.techStack.contains(tech)).toList();

List<String> allTech(List<CaseStudy> all) =>
    {for (final c in all) ...c.techStack}.toList()..sort();

class WorkTechFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setTech(String? tech) => state = tech;
}

final workTechFilterProvider =
    NotifierProvider<WorkTechFilterNotifier, String?>(
      WorkTechFilterNotifier.new,
    );
