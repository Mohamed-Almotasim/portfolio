import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/skill.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/features/landing/proof_stats_provider.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/app_section.dart';
import 'package:portfolio/shared/widgets/profile_photo.dart';

final skillsProvider = Provider<List<Skill>>((ref) => content.skills);
final siteLayersProvider = Provider<List<(String, String)>>(
  (ref) => content.siteLayers,
);
final siteNotesProvider = Provider<List<(String, String)>>(
  (ref) => content.siteNotes,
);

/// Who, with what, and how this very site is put together.
class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key, this.showBuilt = false});

  /// Scroll to "How this site is built" (from `/about?section=built`).
  final bool showBuilt;

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  final _builtKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.showBuilt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _builtKey.currentContext;
        if (ctx != null) Scrollable.ensureVisible(ctx);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final text = Theme.of(context).textTheme;

    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s48),
          LayoutBuilder(
            builder: (context, c) {
              final intro = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text('About', style: text.displayLarge),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Text(
                      profile.shortBio,
                      style: AppTypography.lead(context),
                    ),
                  ),
                ],
              );
              if (profile.photo == null) return intro;
              // Photo beside the intro on wide screens, below it on phones.
              if (c.maxWidth < 860) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    intro,
                    const SizedBox(height: AppSpacing.s32),
                    ProfilePhoto(width: math.min(280.0, c.maxWidth)),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: intro),
                  const SizedBox(width: AppSpacing.s64),
                  const ProfilePhoto(width: 300),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.s48),
          const _Facts(),
          const AppSection(number: '01', title: 'Toolbox', child: _Toolbox()),
          AppSection(
            key: _builtKey,
            number: '02',
            title: 'How this site is built',
            lead:
                'A Flutter web app, top to bottom. Switch on Inspect to see '
                'the layout of any page.',
            child: const _Built(),
          ),
        ],
      ),
    );
  }
}

/// Name, location, availability and any real stats, as title-block cells.
class _Facts extends ConsumerWidget {
  const _Facts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final stats = ref.watch(proofStatsProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final facts = [
      ('Role', profile.title),
      ('Based in', profile.location),
      ('Availability', profile.availability),
      if (profile.responseTime != null) ('Replies', profile.responseTime!),
      for (final s in stats) (s.label, s.value!),
    ];
    return Inspectable(
      label: 'Facts',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: deco.ruleStrong),
          ),
        ),
        child: Wrap(
          children: [
            for (final (label, value) in facts)
              Container(
                width: 260,
                padding: const EdgeInsets.fromLTRB(
                  0,
                  AppSpacing.s12,
                  AppSpacing.s24,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: text.labelSmall?.copyWith(color: deco.inkMute),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(value, style: text.labelLarge),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Skills grouped by what they do: category in mono, tools beside it.
class _Toolbox extends ConsumerWidget {
  const _Toolbox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    return Column(
      children: [
        for (final cat in SkillCategory.values)
          if (skills.any((s) => s.category == cat))
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: deco.rule)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      cat.label,
                      style: text.labelMedium?.copyWith(color: deco.inkMute),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      skills
                          .where((s) => s.category == cat)
                          .map((s) => s.name)
                          .join(', '),
                      style: text.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}

class _Built extends ConsumerWidget {
  const _Built();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layers = ref.watch(siteLayersProvider);
    final notes = ref.watch(siteNotesProvider);
    final inspecting = ref.watch(developerModeProvider);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);

    // The three layers as a stacked section drawing: each band names its
    // folder, and the arrows say who may import whom.
    final layerDrawing = Inspectable(
      label: 'LayerDiagram',
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: deco.ruleStrong)),
        child: Column(
          children: [
            for (final (i, (path, body)) in layers.indexed)
              Container(
                padding: const EdgeInsets.all(AppSpacing.s16),
                decoration: BoxDecoration(
                  border: i == 0
                      ? null
                      : Border(top: BorderSide(color: deco.ruleStrong)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    SizedBox(
                      width: 104,
                      child: Text(
                        path,
                        style: text.labelLarge?.copyWith(
                          color: deco.accentText,
                        ),
                      ),
                    ),
                    Expanded(child: Text(body, style: text.bodyMedium)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    final noteList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (title, body) in notes) ...[
          Text(title, style: text.titleMedium),
          const SizedBox(height: AppSpacing.s4),
          Text(body, style: text.bodyMedium),
          const SizedBox(height: AppSpacing.s24),
        ],
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, c) => c.maxWidth < 900
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    layerDrawing,
                    const SizedBox(height: AppSpacing.s8),
                    _ImportNote(style: text.labelSmall, color: deco.inkMute),
                    const SizedBox(height: AppSpacing.s48),
                    noteList,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          layerDrawing,
                          const SizedBox(height: AppSpacing.s8),
                          _ImportNote(
                            style: text.labelSmall,
                            color: deco.inkMute,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s64),
                    Expanded(flex: 5, child: noteList),
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.s16),
        OutlinedButton(
          onPressed: () => ref.read(developerModeProvider.notifier).toggle(),
          child: Text(inspecting ? 'Stop inspecting' : 'Inspect this page'),
        ),
      ],
    );
  }
}

class _ImportNote extends StatelessWidget {
  const _ImportNote({required this.style, required this.color});

  final TextStyle? style;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    'Read top to bottom: what you see, what it is built from, what it stands on.',
    style: style?.copyWith(color: color),
  );
}
