import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/portfolio_content_ar.dart' as ar;
import 'package:portfolio/core/state/locale_provider.dart';

final caseStudiesProvider = Provider<List<CaseStudy>>(
  (ref) => ref.watch(isArabicProvider) ? ar.caseStudies : content.caseStudies,
);

final featuredCaseStudiesProvider = Provider<List<CaseStudy>>(
  (ref) => ref.watch(caseStudiesProvider).where((c) => c.featured).toList(),
);

CaseStudy? caseStudyBySlug(List<CaseStudy> all, String slug) =>
    all.where((c) => c.slug == slug).firstOrNull;

/// The one after [current], wrapping to the first.
CaseStudy nextCaseStudy(List<CaseStudy> all, CaseStudy current) =>
    all[(all.indexOf(current) + 1) % all.length];

/// The one before [current], wrapping to the last.
CaseStudy previousCaseStudy(List<CaseStudy> all, CaseStudy current) =>
    all[(all.indexOf(current) - 1 + all.length) % all.length];

/// `null` keeps everything.
List<CaseStudy> filterByType(List<CaseStudy> all, String? type) =>
    type == null ? all : all.where((c) => c.type == type).toList();

/// Each type once, in first-seen order.
List<String> allTypes(List<CaseStudy> all) =>
    {for (final c in all) c.type}.toList();

class WorkTypeFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setType(String? type) => state = type;
}

final workTypeFilterProvider =
    NotifierProvider<WorkTypeFilterNotifier, String?>(
      WorkTypeFilterNotifier.new,
    );
