import 'package:flutter/material.dart';
import '../../shared/layout/app_page.dart';
import '../../core/dev_mode/developer_info.dart';
import '../../shared/widgets/app_section.dart';
import '../../shared/widgets/animated_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/tech_stack_grid.dart';
import 'widgets/featured_projects_section.dart';
import 'widgets/call_to_action_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: const Column(
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
