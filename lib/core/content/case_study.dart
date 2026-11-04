import 'package:flutter/material.dart';

class CaseStudyLink {
  const CaseStudyLink({
    required this.label,
    required this.url,
    required this.icon,
  });

  final String label;
  final String url;
  final IconData icon;
}

class CaseStudy {
  const CaseStudy({
    required this.slug,
    required this.title,
    required this.tagline,
    required this.problem,
    required this.solution,
    required this.result,
    required this.techStack,
    required this.role,
    required this.year,
    required this.links,
    this.imagePath,
    this.featured = false,
  });

  final String slug;
  final String title;
  final String tagline;
  final String problem;
  final String solution;
  final String result;
  final List<String> techStack;
  final String role;
  final int year;

  /// The first link is shown as the primary button.
  final List<CaseStudyLink> links;
  final String? imagePath;

  /// Featured case studies appear on the landing page.
  final bool featured;
}
