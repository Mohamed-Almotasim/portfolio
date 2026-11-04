import 'package:flutter/material.dart';
import 'package:portfolio/features/services/widgets/project_case_study_card.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';
import 'package:portfolio/shared/widgets/app_section.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const caseStudies = [
      _ProjectCaseStudy(
        title: 'Student Management System',
        tagline:
            'A cross-platform student portal built for dependable academic operations.',
        problem:
            'Teachers needed a way to capture grades and attendance without relying on a stable internet connection.',
        solution:
            'Built a Flutter app with Firebase sync so staff could work offline first and sync updates once connected.',
        techStack: ['Flutter', 'Firebase', 'Riverpod'],
        result:
            'Real-time sync, offline support, and a cleaner workflow for school staff.',
        liveDemoUrl: 'https://demo.example.com/student-management',
        githubUrl: 'https://github.com/example/student-management-system',
      ),
      _ProjectCaseStudy(
        title: 'Portfolio Web App',
        tagline:
            'A polished developer portfolio designed to present product thinking and frontend craft.',
        problem:
            'A generic portfolio did not communicate engineering depth, interaction quality, or architecture decisions.',
        solution:
            'Built a responsive Flutter web app with structured sections, reusable UI patterns, and route-based navigation.',
        techStack: ['Flutter Web', 'GoRouter', 'Material 3'],
        result:
            'Fast navigation, scalable UI sections, and a more credible presentation of work.',
        liveDemoUrl: 'https://demo.example.com/portfolio-web-app',
        githubUrl: 'https://github.com/example/portfolio-web-app',
      ),
      _ProjectCaseStudy(
        title: 'Inventory Operations Dashboard',
        tagline:
            'A dashboard for tracking stock levels, purchase flow, and warehouse visibility.',
        problem:
            'Operations teams were managing stock updates in spreadsheets, which caused delays and duplicate entries.',
        solution:
            'Delivered a Flutter dashboard with role-based views, reusable state handling, and focused reporting widgets.',
        techStack: ['Flutter', 'Dart', 'Riverpod', 'REST API'],
        result:
            'Improved reporting speed, clearer stock visibility, and cleaner internal architecture.',
        liveDemoUrl: 'https://demo.example.com/inventory-dashboard',
        githubUrl: 'https://github.com/example/inventory-operations-dashboard',
      ),
      _ProjectCaseStudy(
        title: 'Telehealth Booking Platform',
        tagline:
            'A scheduling experience that reduces friction for remote consultations.',
        problem:
            'Patients needed a simple booking flow while clinics needed a maintainable system for appointment handling.',
        solution:
            'Created a Flutter booking interface backed by modular scheduling logic and provider-friendly time slot management.',
        techStack: ['Flutter', 'Riverpod', 'Firebase', 'Cloud Functions'],
        result:
            'Smoother booking journeys, scalable backend workflows, and easier feature expansion.',
        liveDemoUrl: 'https://demo.example.com/telehealth-booking',
        githubUrl: 'https://github.com/example/telehealth-booking-platform',
      ),
    ];

    return AppPage(
      title: 'Projects',
      child: AppSection(
        title: 'App Demos',
        subtitle:
            'Selected product case studies focused on the problem solved, the implementation approach, and the outcome delivered.',
        child: ResponsiveGrid(
          childAspectRatio: 0.78,
          children: caseStudies
              .map(
                (caseStudy) => ProjectCaseStudyCard(
                  title: caseStudy.title,
                  tagline: caseStudy.tagline,
                  problem: caseStudy.problem,
                  solution: caseStudy.solution,
                  techStack: caseStudy.techStack,
                  result: caseStudy.result,
                  liveDemoUrl: caseStudy.liveDemoUrl,
                  githubUrl: caseStudy.githubUrl,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ProjectCaseStudy {
  const _ProjectCaseStudy({
    required this.title,
    required this.tagline,
    required this.problem,
    required this.solution,
    required this.techStack,
    required this.result,
    required this.liveDemoUrl,
    required this.githubUrl,
  });

  final String title;
  final String tagline;
  final String problem;
  final String solution;
  final List<String> techStack;
  final String result;
  final String liveDemoUrl;
  final String githubUrl;
}
