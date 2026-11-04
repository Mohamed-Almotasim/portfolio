import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/landing/widgets/featured_projects_section.dart';
import 'package:portfolio/features/landing/widgets/hero_section.dart';
import 'package:portfolio/features/landing/widgets/landing_sections.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/widgets/animated_section.dart';
import 'package:portfolio/shared/widgets/app_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget link(String label, String path) => TextButton.icon(
      onPressed: () => context.go(path),
      icon: const Icon(Icons.arrow_forward, size: 16),
      iconAlignment: IconAlignment.end,
      label: Text(label),
    );

    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnimatedSection(child: HeroSection()),
          const SizedBox(height: AppSpacing.s24),
          const AnimatedSection(
            delay: Duration(milliseconds: 150),
            child: ProofStrip(),
          ),
          AppSection(
            title: 'What I do',
            subtitle: 'From first prototype to store release.',
            action: link('All services', AppRoutes.services),
            child: const AnimatedSection(child: ServicesTeaser()),
          ),
          AppSection(
            title: 'Selected work',
            subtitle: 'The problem, the approach and what changed.',
            action: link('All work', AppRoutes.services),
            child: const AnimatedSection(child: FeaturedProjectsSection()),
          ),
          const AppSection(
            title: 'Skills',
            subtitle: 'The stack I reach for, grouped by what it does.',
            child: AnimatedSection(child: SkillsByCategory()),
          ),
          const AppSection(
            title: 'How I work',
            subtitle: 'A simple process that keeps you in the loop.',
            child: AnimatedSection(child: ProcessSection()),
          ),
          const SizedBox(height: AppSpacing.s32),
          const AnimatedSection(child: FinalCtaBand()),
        ],
      ),
    );
  }
}
