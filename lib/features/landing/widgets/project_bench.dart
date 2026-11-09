import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';
import 'package:portfolio/features/work/widgets/project_phone.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';

/// Matches the phone's screen cross-fade, so row, title bar and screen move
/// together.
const _fade = Duration(milliseconds: 250);
const _idle = Duration(seconds: 5);

/// The bench: a register of projects beside a phone playing the selected
/// one. Auto-advances when a cycle ends, holding while the visitor hovers,
/// touches or has focus inside, until 5s after the last interaction.
class ProjectBench extends ConsumerStatefulWidget {
  const ProjectBench({super.key});

  @override
  ConsumerState<ProjectBench> createState() => _ProjectBenchState();
}

class _ProjectBenchState extends ConsumerState<ProjectBench> {
  final _progress = ValueNotifier<double>(0);
  final _phoneKey = GlobalKey();
  int _index = 0;
  bool _hold = false;
  bool _focused = false;
  Timer? _idleTimer;
  ScrollPosition? _position;
  double _stickyY = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_stick);
      _position = position?..addListener(_stick);
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _position?.removeListener(_stick);
    _progress.dispose();
    super.dispose();
  }

  void _select(int i) {
    if (i == _index) return;
    _progress.value = 0;
    setState(() => _index = i);
  }

  /// Any interaction holds auto-advance; 5s of quiet releases it.
  void _poke([Object? _]) {
    _idleTimer?.cancel();
    if (!_hold) setState(() => _hold = true);
    _idleTimer = Timer(_idle, () {
      if (mounted && !_focused) setState(() => _hold = false);
    });
  }

  /// Keeps the phone below the navbar while the list scrolls past, within
  /// the bench. A no-op while the phone is the taller column.
  void _stick() {
    if (MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) return;
    final bench = context.findRenderObject() as RenderBox?;
    final phone = _phoneKey.currentContext?.findRenderObject() as RenderBox?;
    if (bench == null || phone == null || !bench.hasSize || !phone.hasSize) {
      return;
    }
    final top = bench.localToGlobal(Offset.zero).dy;
    final room = math.max(0.0, bench.size.height - phone.size.height);
    final y = (AppNavbar.height + AppSpacing.s24 - top).clamp(0.0, room);
    if (y != _stickyY) setState(() => _stickyY = y);
  }

  @override
  Widget build(BuildContext context) {
    final studies = ref.watch(featuredCaseStudiesProvider);
    if (studies.isEmpty) return const SizedBox.shrink();
    final n = studies.length;
    final i = _index % n;
    final study = studies[i];
    final wide = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    final reduced = MediaQuery.disableAnimationsOf(context);
    void open() => context.go(AppRoutes.caseStudy(study.slug));

    final phone = ProjectPhone(
      key: _phoneKey,
      study: study,
      // Compact loads only the active video.
      next: wide ? studies[(i + 1) % n] : null,
      autoAdvance: !_hold && !reduced,
      onCycleEnd: () => _select((i + 1) % n),
      onOpen: open,
      onSwipe: wide
          ? null
          : (d) {
              _poke();
              _select((i + d) % n);
            },
      progress: _progress,
    );

    final list = Inspectable(
      label: 'BenchList',
      note:
          'Every row keeps the same height whether active or not; the action '
          'fades in place and the progress line has its own 2px slot.',
      source: 'lib/features/landing/widgets/project_bench.dart:117',
      tokens: const ['AppDecorations.ruleStrong', 'AppSpacing.s16'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _HeaderRow(),
          for (final (j, s) in studies.indexed)
            _BenchRow(
              number: j + 1,
              study: s,
              active: j == i,
              progress: _progress,
              onSelect: () {
                _poke();
                _select(j);
              },
            ),
        ],
      ),
    );

    final body = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    list,
                    const SizedBox(height: AppSpacing.s32),
                    // What the phone is showing: the outcome, then its stack
                    // and role, so the list side carries as much as the
                    // phone instead of trailing off into empty space.
                    AnimatedSwitcher(
                      duration: AppMotion.of(context, _fade),
                      child: _ActiveSpec(
                        key: ValueKey(study.slug),
                        study: study,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s48),
              SizedBox(
                width: 420,
                child: Transform.translate(
                  offset: Offset(0, _stickyY),
                  child: phone,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Tabs(
                studies: studies,
                index: i,
                progress: _progress,
                onSelect: (j) {
                  _poke();
                  _select(j);
                },
              ),
              const SizedBox(height: AppSpacing.s24),
              phone,
              const SizedBox(height: AppSpacing.s16),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: open,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    'Open case study →',
                    semanticsLabel: 'Open the ${study.title} case study',
                  ),
                ),
              ),
            ],
          );

    return Inspectable(
      label: 'ProjectBench',
      note:
          'Hover, touch or focus holds auto-advance; it resumes after 5s of '
          'quiet. Off-screen or in a hidden tab, playback pauses.',
      source: 'lib/features/landing/widgets/project_bench.dart:205',
      tokens: const ['AppBreakpoints.tablet', 'AppSpacing.s48'],
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: (f) {
          _focused = f;
          _poke();
        },
        child: Listener(
          onPointerDown: _poke,
          onPointerHover: _poke,
          onPointerSignal: _poke,
          child: body,
        ),
      ),
    );
  }
}

/// The active project under the register: outcome, then stack and role as
/// mono spec lines.
class _ActiveSpec extends StatelessWidget {
  const _ActiveSpec({super.key, required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final label = text.labelSmall?.copyWith(color: deco.inkMute);
    Widget line(String name, String value) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(width: 72, child: Text(name, style: label)),
          Expanded(child: Text(value, style: text.labelLarge)),
        ],
      ),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(study.outcome, style: text.bodyLarge),
          const SizedBox(height: AppSpacing.s12),
          line('Stack', study.techStack.join(' / ')),
          line('Role', study.role),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final head = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: deco.inkMute);
    return Container(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: deco.ruleStrong)),
      ),
      child: _Columns(
        no: Text('No.', style: head),
        name: Text('Project', style: head),
        type: Text('Type', style: head),
        year: Text('Year', style: head),
      ),
    );
  }
}

class _Columns extends StatelessWidget {
  const _Columns({
    required this.no,
    required this.name,
    required this.type,
    required this.year,
  });

  final Widget no, name, type, year;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(width: 48, child: no),
        Expanded(child: name),
        const SizedBox(width: AppSpacing.s16),
        SizedBox(width: 152, child: type),
        const SizedBox(width: AppSpacing.s16),
        SizedBox(width: 72, child: year),
      ],
    );
  }
}

/// One register row. Same height active or not: the action and the
/// progress line occupy their slots on every row and only fade.
class _BenchRow extends StatelessWidget {
  const _BenchRow({
    required this.number,
    required this.study,
    required this.active,
    required this.progress,
    required this.onSelect,
  });

  final int number;
  final CaseStudy study;
  final bool active;
  final ValueNotifier<double> progress;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final fade = AppMotion.of(context, _fade);
    final mono = text.labelMedium?.copyWith(color: deco.inkMute);

    return Semantics(
      selected: active,
      child: InkWell(
        onTap: onSelect,
        child: AnimatedContainer(
          duration: fade,
          curve: AppMotion.curve,
          color: active ? scheme.surfaceContainerLow : scheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s16,
                  AppSpacing.s4,
                  0,
                ),
                child: _Columns(
                  no: AnimatedDefaultTextStyle(
                    duration: fade,
                    style: mono!.copyWith(
                      color: active ? deco.accentText : deco.inkMute,
                    ),
                    child: Text(number.toString().padLeft(2, '0')),
                  ),
                  name: Text(
                    study.title,
                    style: text.titleMedium,
                    semanticsLabel: 'Show ${study.title} on the phone',
                  ),
                  type: Text(study.type, style: mono),
                  year: Text(study.yearLabel, style: mono),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48 + AppSpacing.s4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedOpacity(
                    opacity: active ? 1 : 0,
                    duration: fade,
                    child: IgnorePointer(
                      ignoring: !active,
                      child: ExcludeFocus(
                        excluding: !active,
                        child: ExcludeSemantics(
                          excluding: !active,
                          child: TextButton(
                            onPressed: () =>
                                context.go(AppRoutes.caseStudy(study.slug)),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Open case study →',
                              semanticsLabel:
                                  'Open the ${study.title} case study',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _ProgressSlot(active: active, progress: progress),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2px at the bottom of a row: the rule, or the accent progress line.
class _ProgressSlot extends StatelessWidget {
  const _ProgressSlot({
    required this.active,
    required this.progress,
    this.rule = true,
  });

  final bool active;
  final ValueNotifier<double> progress;
  final bool rule;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    return SizedBox(
      height: 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (rule)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(height: 1, color: deco.rule),
            ),
          if (active)
            ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, p, _) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: p,
                child: ColoredBox(color: deco.accent),
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact: project names as a swipeable strip of tabs; the active one is
/// accent with the progress line as its underline.
class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.studies,
    required this.index,
    required this.progress,
    required this.onSelect,
  });

  final List<CaseStudy> studies;
  final int index;
  final ValueNotifier<double> progress;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final label = Theme.of(context).textTheme.labelMedium;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: deco.rule)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final (j, s) in studies.indexed)
              Semantics(
                selected: j == index,
                button: true,
                child: InkWell(
                  onTap: () => onSelect(j),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.s4,
                            AppSpacing.s12,
                            AppSpacing.s16,
                            AppSpacing.s12 + 2,
                          ),
                          child: Text(
                            s.title,
                            style: label?.copyWith(
                              color: j == index
                                  ? deco.accentText
                                  : deco.inkMute,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _ProgressSlot(
                            active: j == index,
                            progress: progress,
                            rule: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
