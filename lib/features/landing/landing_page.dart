import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/features/landing/widgets/client_reviews.dart';
import 'package:portfolio/features/landing/widgets/hero_section.dart';
import 'package:portfolio/features/landing/widgets/home_sections.dart';
import 'package:portfolio/features/landing/widgets/project_bench.dart';
import 'package:portfolio/features/playground/specimens/one_codebase.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/widgets/animated_section.dart';
import 'package:portfolio/shared/widgets/app_section.dart';

/// The drawing set's cover sheet: the hero, then six numbered sheets.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroSection(),
          AppSection(
            number: '01',
            title: l10n.sectionSelectedWork,
            inspectLabel: 'Selected work',
            inspectNote:
                'Sheet 01, the bench: the register picks what the phone plays. '
                'On phones the "All work" link drops below the list.',
            inspectSource: 'lib/features/landing/landing_page.dart:26',
            action: ArrowLink(
              label: l10n.allWork,
              onPressed: () => context.go(AppRoutes.work),
            ),
            child: const AnimatedSection(child: ProjectBench()),
          ),
          AppSection(
            number: '02',
            title: l10n.sectionTryOne,
            inspectLabel: 'Try one',
            action: ArrowLink(
              label: l10n.navPlayground,
              onPressed: () => context.go(AppRoutes.playground),
            ),
            child: const AnimatedSection(child: OneCodebaseSpecimen()),
          ),
          AppSection(
            number: '03',
            title: l10n.sectionWhatIDo,
            inspectLabel: 'What I do',
            action: ArrowLink(
              label: l10n.waysToWork,
              onPressed: () => context.go(AppRoutes.contact),
            ),
            child: const AnimatedSection(child: ServicesList()),
          ),
          AppSection(
            number: '04',
            title: l10n.sectionClients,
            inspectLabel: 'What clients say',
            action: const FiverrReviewsLink(),
            child: const AnimatedSection(child: ClientReviews()),
          ),
          AppSection(
            number: '05',
            title: l10n.sectionHowIWork,
            inspectLabel: 'How I work',
            child: const AnimatedSection(child: ProcessLine()),
          ),
          AppSection(
            number: '06',
            title: l10n.sectionTellMe,
            inspectLabel: "Tell me what you're building",
            child: const AnimatedSection(child: ContactBlock()),
          ),
        ],
      ),
    );
  }
}
