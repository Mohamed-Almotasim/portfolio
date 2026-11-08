import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/project_media.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/state/project_assets_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/media/loop_video.dart';
import 'package:portfolio/shared/widgets/spec_marks.dart';

/// Pixel 8 in logical pixels.
const _screenAspect = 412 / 915;
const _fade = Duration(milliseconds: 250);
const _slideEvery = Duration(milliseconds: 2500);

/// What footage a project really has, from the asset manifest.
class Footage {
  Footage(this.media, Set<String> assets, {bool videoFailed = false})
    : hasVideo = media != null && !videoFailed && assets.contains(media.video),
      shots = [
        for (final p in media?.screenshots ?? List.filled(4, ''))
          assets.contains(p) ? p : null,
      ];

  final ProjectMedia? media;
  final bool hasVideo;

  /// Four slots; null where the screenshot doesn't exist yet.
  final List<String?> shots;

  bool get hasShots => shots.any((s) => s != null);
  String? get poster => shots.first;

  String caption(int i) =>
      media?.captions.elementAtOrNull(i) ?? 'Screen ${i + 1}';
}

/// An emulator-style phone that plays a project's footage: the video, else
/// its screenshots in turn, else an "awaiting footage" screen. The frame
/// never changes size; when [study] changes only the screen cross-fades.
class ProjectPhone extends ConsumerStatefulWidget {
  const ProjectPhone({
    super.key,
    required this.study,
    this.next,
    this.autoAdvance = false,
    this.onCycleEnd,
    this.onOpen,
    this.onSwipe,
    this.progress,
  });

  final CaseStudy study;

  /// Preloaded in the background (poster and video) after a switch.
  final CaseStudy? next;

  /// When a cycle ends: true calls [onCycleEnd], false loops.
  final bool autoAdvance;
  final VoidCallback? onCycleEnd;

  /// Tapping the screen.
  final VoidCallback? onOpen;

  /// A horizontal swipe on the screen: +1 next, -1 previous.
  final ValueChanged<int>? onSwipe;

  /// 0..1 through the current cycle.
  final ValueNotifier<double>? progress;

  @override
  ConsumerState<ProjectPhone> createState() => _ProjectPhoneState();
}

class _ProjectPhoneState extends ConsumerState<ProjectPhone>
    with SingleTickerProviderStateMixin {
  final _videos = <String, LoopVideo>{};
  final _failed = <String>{};

  /// Slugs whose screen may still be fading out; disposed after the fade.
  final _onStage = <String>{};
  late final _slides = AnimationController(
    vsync: this,
    duration: _slideEvery * 4,
  );
  late final AppLifecycleListener _lifecycle;
  ScrollPosition? _position;
  LoopVideo? _listening;
  Timer? _cleanup;

  int _slide = 0;
  int? _pinned;
  bool? _paused;
  bool _onScreen = true;
  bool _tabVisible = true;
  bool _endHandled = false;

  bool get _running =>
      _paused == false && _pinned == null && _onScreen && _tabVisible;

  @override
  void initState() {
    super.initState();
    _onStage.add(widget.study.slug);
    _slides
      ..addListener(_onSlidesTick)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _ended();
      });
    _lifecycle = AppLifecycleListener(
      onStateChange: (s) {
        _tabVisible =
            s == AppLifecycleState.resumed || s == AppLifecycleState.inactive;
        _sync();
      },
    );
    ref.listenManual(projectAssetsProvider, (_, _) => _sync());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOnScreen();
      _preloadNext();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduced motion: no autoplay; the poster waits with a play button.
    _paused ??= MediaQuery.disableAnimationsOf(context);
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_checkOnScreen);
      _position = position?..addListener(_checkOnScreen);
    }
    _sync();
  }

  @override
  void didUpdateWidget(ProjectPhone old) {
    super.didUpdateWidget(old);
    if (old.study.slug != widget.study.slug) {
      _pinned = null;
      _slide = 0;
      _endHandled = false;
      _paused = MediaQuery.disableAnimationsOf(context);
      _slides.value = 0;
      widget.progress?.value = 0;
      _onStage.add(widget.study.slug);
      // At most two players: drop a preloaded one we didn't switch to.
      for (final slug in [..._videos.keys]) {
        if (!_onStage.contains(slug)) _videos.remove(slug)!.dispose();
      }
      _sync();
      _cleanup?.cancel();
      _cleanup = Timer(
        AppMotion.of(context, _fade) + const Duration(milliseconds: 50),
        _afterFade,
      );
    }
  }

  @override
  void dispose() {
    _cleanup?.cancel();
    _lifecycle.dispose();
    _position?.removeListener(_checkOnScreen);
    _listening?.removeListener(_onVideoTick);
    for (final v in _videos.values) {
      v.dispose();
    }
    _slides.dispose();
    super.dispose();
  }

  Footage _footage(CaseStudy s) => Footage(
    s.media,
    ref.read(projectAssetsProvider).value ?? const {},
    videoFailed: _failed.contains(s.slug),
  );

  LoopVideo? _video(CaseStudy s) {
    if (!_footage(s).hasVideo) return null;
    return _videos.putIfAbsent(s.slug, () {
      final v = ref.read(loopVideoFactoryProvider)(s.media!.video);
      v.initialize().then(
        (_) => _sync(),
        onError: (Object _) {
          // Unplayable file: fall back to the screenshots.
          _failed.add(s.slug);
          if (_videos[s.slug] == v) _videos.remove(s.slug)?.dispose();
          _sync();
        },
      );
      return v;
    });
  }

  /// Plays or pauses the current footage to match [_running].
  void _sync() {
    if (!mounted) return;
    final v = _video(widget.study);
    if (_listening != v) {
      _listening?.removeListener(_onVideoTick);
      _listening = v?..addListener(_onVideoTick);
    }
    if (v != null) {
      _slides.stop();
      if (v.isReady) _running ? v.play() : v.pause();
    } else if (_running) {
      _slides.forward();
    } else {
      _slides.stop();
    }
    setState(() {});
  }

  /// After a switch's cross-fade: free the outgoing player, warm the next.
  void _afterFade() {
    if (!mounted) return;
    _onStage
      ..clear()
      ..add(widget.study.slug);
    for (final slug in [..._videos.keys]) {
      if (slug != widget.study.slug) _videos.remove(slug)!.dispose();
    }
    _preloadNext();
  }

  void _preloadNext() {
    final next = widget.next;
    if (!mounted || next == null || next.slug == widget.study.slug) return;
    final poster = _footage(next).poster;
    if (poster != null) {
      precacheImage(AssetImage(poster), context, onError: (_, _) {});
    }
    _video(next); // initialized, not played
  }

  void _onVideoTick() {
    final v = _listening;
    if (v == null || !v.isReady) return;
    final ms = v.duration.inMilliseconds;
    if (ms > 0) {
      widget.progress?.value = (v.position.inMilliseconds / ms).clamp(0, 1);
    }
    if (v.isCompleted && !_endHandled) {
      _endHandled = true;
      _ended();
    }
  }

  void _onSlidesTick() {
    widget.progress?.value = _slides.value;
    final i = math.min((_slides.value * 4).floor(), 3);
    if (i != _slide) setState(() => _slide = i);
  }

  void _ended() {
    if (widget.autoAdvance && widget.onCycleEnd != null) {
      widget.onCycleEnd!();
    } else {
      _replay();
    }
  }

  void _replay() {
    _paused = false;
    _pinned = null;
    _endHandled = false;
    _slide = 0;
    final v = _listening;
    if (v != null) {
      v.seekTo(Duration.zero).then((_) => _sync());
    } else {
      _slides.value = 0;
      _sync();
    }
  }

  void _togglePlay() {
    _paused = !_paused!;
    if (_paused == false) _pinned = null;
    _sync();
  }

  void _pin(int? i) {
    _pinned = i;
    if (i == null) _paused = false;
    _sync();
  }

  void _checkOnScreen() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final on =
        top < MediaQuery.sizeOf(context).height && top + box.size.height > 0;
    if (on != _onScreen) {
      _onScreen = on;
      _sync();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final label = Theme.of(context).textTheme.labelSmall;
    final study = widget.study;
    ref.watch(projectAssetsProvider);
    final f = _footage(study);
    final video = _videos[study.slug];
    final fade = AppMotion.of(context, _fade);
    final vh = MediaQuery.sizeOf(context).height;
    final playing = _running;

    final caption = _pinned != null
        ? 'Fig. ${_pinned! + 1} · ${f.caption(_pinned!)}'
        : f.hasVideo
        ? (playing ? 'Video' : 'Video · paused')
        : f.hasShots
        ? 'Fig. ${_slide + 1} · ${f.caption(_slide)}'
        : 'No footage yet';

    return LayoutBuilder(
      builder: (context, c) {
        const bezel = 6.0;
        // Same size for every project: the width and ~70% of the viewport
        // height decide it, never the footage.
        final screenW = [
          300.0,
          c.maxWidth - 2 * bezel,
          (vh * 0.7 - 2 * bezel) * _screenAspect,
        ].reduce(math.min).clamp(80.0, 300.0);
        final screenH = screenW / _screenAspect;
        final radius = screenW * 0.08;
        final barH = math.max(14.0, screenH * 0.035);

        final screen = Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: fade,
              // The incoming screen fades in over the outgoing one, which
              // stays opaque underneath: never a see-through frame.
              transitionBuilder: (child, a) => child.key == ValueKey(study.slug)
                  ? FadeTransition(opacity: a, child: child)
                  : child,
              child: _Screen(
                key: ValueKey(study.slug),
                title: study.title,
                footage: f,
                video: video,
                slide: _slide,
                pinned: _pinned,
                fade: fade,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: barH,
              child: _StatusBar(height: barH),
            ),
            if (ref.watch(developerModeProvider) && video != null)
              Positioned(
                top: barH + AppSpacing.s8,
                left: AppSpacing.s8,
                right: AppSpacing.s8,
                child: _TimedNotes(video: video, notes: f.media!.notes),
              ),
            if (_paused! && _pinned == null)
              Center(
                child: FilledButton(
                  onPressed: _togglePlay,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.play_arrow, semanticLabel: 'Play'),
                ),
              ),
          ],
        );

        final device = Inspectable(
          label: 'ProjectPhone',
          note:
              'One frame for every project: only the screen cross-fades. The '
              'poster paints first and the video fades in over it once '
              'decoded, so a switch never shows a blank frame.',
          source: 'lib/features/work/widgets/project_phone.dart:392',
          tokens: const ['AppDecorations.ruleStrong', 'surfaceContainerLow'],
          child: Container(
            padding: const EdgeInsets.all(bezel),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              border: Border.all(color: deco.ruleStrong),
              borderRadius: BorderRadius.circular(radius + bezel),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: SizedBox(
                width: screenW,
                height: screenH,
                child: Semantics(
                  button: widget.onOpen != null,
                  label: widget.onOpen != null
                      ? 'Open the ${study.title} case study'
                      : '${study.title} footage',
                  onTap: widget.onOpen,
                  child: MouseRegion(
                    cursor: widget.onOpen != null
                        ? SystemMouseCursors.click
                        : MouseCursor.defer,
                    child: GestureDetector(
                      onTap: widget.onOpen,
                      onHorizontalDragEnd: widget.onSwipe == null
                          ? null
                          : (d) {
                              final v = d.primaryVelocity ?? 0;
                              if (v.abs() > 200) {
                                widget.onSwipe!(v < 0 ? 1 : -1);
                              }
                            },
                      child: screen,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitleBar(
              title: study.title,
              playing: playing,
              fade: fade,
              onReplay: _replay,
              onToggle: _togglePlay,
            ),
            const SizedBox(height: AppSpacing.s12),
            Center(child: device),
            const SizedBox(height: AppSpacing.s16),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                _Chapter(
                  label: f.hasVideo || !f.hasShots ? 'Video' : 'Loop',
                  semantics: 'Play the loop',
                  selected: _pinned == null,
                  onTap: () => _pin(null),
                  width: 64,
                ),
                for (var i = 0; i < 4; i++)
                  _Chapter(
                    label: '${i + 1}',
                    semantics: 'Screen ${i + 1}: ${f.caption(i)}',
                    path: f.shots[i],
                    selected: _pinned == i,
                    onTap: () => _pin(i),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: label?.copyWith(color: deco.inkMute),
            ),
          ],
        );
      },
    );
  }
}

/// `Pixel 8 · 412×915 · <name>`, replay and play/pause.
class _TitleBar extends StatelessWidget {
  const _TitleBar({
    required this.title,
    required this.playing,
    required this.fade,
    required this.onReplay,
    required this.onToggle,
  });

  final String title;
  final bool playing;
  final Duration fade;
  final VoidCallback onReplay;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final label = Theme.of(context).textTheme.labelSmall;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: deco.rule)),
      ),
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final compact = c.maxWidth < 300;
                return AnimatedSwitcher(
                  duration: fade,
                  layoutBuilder: (current, previous) => Stack(
                    alignment: Alignment.centerLeft,
                    children: [...previous, ?current],
                  ),
                  child: Text(
                    compact ? 'Pixel 8 · $title' : 'Pixel 8 · 412×915 · $title',
                    key: ValueKey(title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: label?.copyWith(color: deco.inkMute),
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: onReplay,
            tooltip: 'Replay',
            icon: const Icon(Icons.replay, size: 18),
          ),
          IconButton(
            onPressed: onToggle,
            tooltip: playing ? 'Pause' : 'Play',
            icon: Icon(playing ? Icons.pause : Icons.play_arrow, size: 18),
          ),
        ],
      ),
    );
  }
}

/// One project's screen content.
class _Screen extends StatelessWidget {
  const _Screen({
    super.key,
    required this.title,
    required this.footage,
    required this.video,
    required this.slide,
    required this.pinned,
    required this.fade,
  });

  final String title;
  final Footage footage;
  final LoopVideo? video;
  final int slide;
  final int? pinned;
  final Duration fade;

  @override
  Widget build(BuildContext context) {
    final f = footage;
    final v = video;
    Widget shot(int i) => _Shot(key: ValueKey(i), path: f.shots[i], index: i);
    final Widget child;
    if (pinned != null) {
      child = shot(pinned!);
    } else if (f.hasVideo) {
      child = Stack(
        fit: StackFit.expand,
        children: [
          f.poster != null ? shot(0) : _AwaitingFootage(title: title),
          if (v != null)
            ListenableBuilder(
              listenable: v,
              builder: (context, _) => AnimatedOpacity(
                opacity:
                    v.isReady && (v.isPlaying || v.position > Duration.zero)
                    ? 1
                    : 0,
                duration: fade,
                child: v.isReady ? v.view() : const SizedBox.shrink(),
              ),
            ),
        ],
      );
    } else if (f.hasShots) {
      child = AnimatedSwitcher(duration: fade, child: shot(slide));
    } else {
      child = _AwaitingFootage(title: title, prefix: f.media?.prefix);
    }
    return ExcludeSemantics(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox.expand(child: child),
      ),
    );
  }
}

/// A screenshot, or a numbered well where it will go.
class _Shot extends StatelessWidget {
  const _Shot({super.key, required this.path, required this.index});

  final String? path;
  final int index;

  @override
  Widget build(BuildContext context) {
    final well = _Well(text: 'Screen ${index + 1}\nNo screenshot yet');
    if (path == null) return well;
    return Image.asset(
      path!,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => well,
    );
  }
}

class _Well extends StatelessWidget {
  const _Well({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s8),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppDecorations.of(context).inkMute,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// No video, no screenshots: the project name inside crop marks, and where
/// the footage goes.
class _AwaitingFootage extends StatelessWidget {
  const _AwaitingFootage({required this.title, this.prefix});

  final String title;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final mute = text.labelSmall?.copyWith(
      color: AppDecorations.of(context).inkMute,
    );
    return LayoutBuilder(
      builder: (context, c) => Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: math.max(0, c.maxWidth - 2 * AppSpacing.s24),
            child: CropMarks(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    const SizedBox(height: AppSpacing.s8),
                    Text('Awaiting footage', style: mute),
                    if (prefix != null) ...[
                      const SizedBox(height: AppSpacing.s4),
                      Text('$prefix-video.mp4', style: mute),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Camera cutout and a battery, over the recording's own status bar.
class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final dot = height * 0.5;
    return ExcludeSemantics(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: dot,
                height: dot,
                decoration: BoxDecoration(
                  color: deco.deviceBezel,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: height * 0.8,
              top: height * 0.32,
              bottom: height * 0.32,
              width: height * 0.7,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: deco.inkMute),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inspect mode: the note for this moment of the video, as an Inspector tag.
class _TimedNotes extends StatelessWidget {
  const _TimedNotes({required this.video, required this.notes});

  final LoopVideo video;
  final List<InspectNote> notes;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    return IgnorePointer(
      child: ListenableBuilder(
        listenable: video,
        builder: (context, _) {
          final t = video.position.inMilliseconds / 1000;
          final note = notes
              .where((n) => t >= n.seconds && t < n.seconds + 2.5)
              .firstOrNull;
          if (note == null) return const SizedBox.shrink();
          return Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s4,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: deco.accent,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: deco.shadowSoft,
              ),
              child: Text(
                '${note.seconds.toStringAsFixed(0)}s · ${note.label}',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: deco.onAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A chapter in the strip under the phone: `Video`, or a screen thumbnail.
class _Chapter extends StatelessWidget {
  const _Chapter({
    required this.label,
    required this.semantics,
    required this.selected,
    required this.onTap,
    this.path,
    this.width = 44,
  });

  final String label;
  final String semantics;
  final bool selected;
  final VoidCallback onTap;
  final String? path;
  final double width;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme.labelSmall;
    final tag = Text(
      label,
      style: text?.copyWith(color: selected ? deco.accentText : deco.inkMute),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: semantics,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.snap),
          curve: AppMotion.curve,
          width: width,
          height: 56,
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: selected ? deco.accent : deco.rule,
              width: selected ? 2 : 1,
            ),
          ),
          color: scheme.surfaceContainerLow,
          child: path == null
              ? Center(child: tag)
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      path!,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      cacheWidth: 132,
                      errorBuilder: (_, _, _) => Center(child: tag),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ColoredBox(
                        color: scheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: tag,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
