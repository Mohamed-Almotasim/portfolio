import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/features/landing/widgets/hero_section.dart';
import 'package:portfolio/features/landing/widgets/home_sections.dart';
import 'package:portfolio/features/landing/widgets/selected_work.dart';
import 'package:portfolio/features/playground/specimens/one_codebase.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/widgets/animated_section.dart';
import 'package:portfolio/shared/widgets/app_section.dart';

/// The drawing set's cover sheet: the hero, then five numbered sheets.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroSection(),
          AppSection(
            number: '01',
            title: 'Selected work',
            inspectNote:
                'Sheet 01: numbered because the home page reads in order. '
                'On phones the "All work" link drops below the list.',
            inspectSource: 'lib/features/landing/landing_page.dart:23',
            action: ArrowLink(
              label: 'All work',
              onPressed: () => context.go(AppRoutes.work),
            ),
            child: const AnimatedSection(child: SelectedWork()),
          ),
          AppSection(
            number: '02',
            title: 'Try one',
            action: ArrowLink(
              label: 'Playground',
              onPressed: () => context.go(AppRoutes.playground),
            ),
            child: const AnimatedSection(child: OneCodebaseSpecimen()),
          ),
          AppSection(
            number: '03',
            title: 'What I do',
            action: ArrowLink(
              label: 'Ways to work together',
              onPressed: () => context.go(AppRoutes.contact),
            ),
            child: const AnimatedSection(child: ServicesList()),
          ),
          const AppSection(
            number: '04',
            title: 'How I work',
            child: AnimatedSection(child: ProcessLine()),
          ),
          const AppSection(
            number: '05',
            title: "Tell me what you're building",
            child: AnimatedSection(child: ContactBlock()),
          ),
        ],
      ),
    );
  }
}
