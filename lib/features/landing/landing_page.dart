import 'package:flutter/material.dart';
import 'package:portfolio/core/dev_mode/developer_info.dart';
import 'package:portfolio/features/landing/widgets/call_to_action_section.dart';
import 'package:portfolio/features/landing/widgets/featured_projects_section.dart';
import 'package:portfolio/features/landing/widgets/hero_section.dart';
import 'package:portfolio/features/landing/widgets/tech_stack_grid.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/widgets/animated_section.dart';
import 'package:portfolio/shared/widgets/app_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(
      child: Column(
        children: [
          AppSection(child: AnimatedSection(child: HeroSection())),
          AppSection(
            showDivider: true,
            title: 'Skills',
            subtitle: 'Technologies and tools I work with',
            child: AnimatedSection(child: TechStackGrid()),
          ),
          AppSection(
            showDivider: true,
            title: 'Featured Projects',
            subtitle: 'Showcase of my recent work and achievements',
            child: AnimatedSection(child: FeaturedProjectsSection()),
          ),
          AppSection(child: AnimatedSection(child: CallToActionSection())),
          DeveloperInfo(),
        ],
      ),
    );
  }
}
