import 'package:flutter/material.dart';
import 'package:portfolio/core/content/project_media.dart';

class CaseStudyLink {
  const CaseStudyLink({
    required this.label,
    required this.url,
    required this.icon,
  });

  final String label;
  final String url;
  final IconData icon;

  /// Template links (example.com) are never shown.
  bool get isReal => !(Uri.tryParse(url)?.host ?? '').endsWith('example.com');
}

/// One image in a case study's gallery. [imagePath] null shows a captioned
/// placeholder frame until the real screenshot exists.
class CaseStudyFigure {
  const CaseStudyFigure({required this.caption, this.imagePath});

  final String caption;
  final String? imagePath;
}

class CaseStudy {
  const CaseStudy({
    required this.slug,
    required this.title,
    required this.type,
    required this.tagline,
    required this.outcome,
    required this.problem,
    required this.solution,
    required this.result,
    required this.techStack,
    required this.role,
    required this.year,
    required this.links,
    this.media,
    this.gallery = const [],
    this.imagePath,
    this.featured = false,
  });

  final String slug;
  final String title;

  /// What kind of thing it is, e.g. "Mobile app". Used by the /work filter.
  final String type;
  final String tagline;

  /// One line: what changed because of the work.
  final String outcome;
  final String problem;
  final String solution;
  final String result;
  final List<String> techStack;
  final String role;

  /// Null shows `TODO(me)` until the owner fills it in.
  final int? year;

  String get yearLabel => year?.toString() ?? 'TODO(me)';

  /// Shown only when [CaseStudyLink.isReal].
  final List<CaseStudyLink> links;
  final List<CaseStudyFigure> gallery;

  /// Cover image; null shows a placeholder frame.
  final String? imagePath;

  /// Footage for the landing-page bench and the case-study phone.
  final ProjectMedia? media;

  /// Featured case studies appear on the landing page.
  final bool featured;

  List<CaseStudyLink> get realLinks => links.where((l) => l.isReal).toList();
}
