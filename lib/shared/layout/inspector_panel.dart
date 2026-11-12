import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/inspector_notes_ar.dart';
import 'package:portfolio/core/state/locale_provider.dart';
import 'package:portfolio/core/state/profile_provider.dart';
import 'package:portfolio/core/state/theme_tokens_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/theme_tokens.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/demo/source_snippet.dart';
import 'package:portfolio/shared/layout/inspectable.dart';
import 'package:portfolio/shared/utils/link_launcher.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';
import 'package:portfolio/shared/widgets/code_viewer.dart';

/// The inspector panel for the selected [Inspectable] (docs/DESIGN.md §7):
/// docked right on desktop, a bottom sheet below it. AppShell builds this
/// only while Inspector mode is on, so nothing here costs anything when off.
/// Width of the docked panel (desktop), and height of the sheet (below it).
const _dockWidth = 380.0;
double _sheetHeight(Size screen) => math.min(screen.height * 0.55, 480);

/// The room an open panel takes from the page, so AppShell can shrink the
/// page instead of letting the panel cover the selected element.
EdgeInsets inspectorInset(Size screen) => screen.width >= AppBreakpoints.tablet
    ? const EdgeInsets.only(right: _dockWidth)
    : EdgeInsets.only(bottom: _sheetHeight(screen));

class InspectorLayer extends StatelessWidget {
  const InspectorLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: RenderInspectable.selection,
      builder: (context, _) {
        final box = RenderInspectable.selection.box;
        if (box == null || !box.attached || !box.hasSize) {
          return const SizedBox.shrink();
        }
        return InspectorPanel(box: box);
      },
    );
  }
}

class InspectorPanel extends StatefulWidget {
  const InspectorPanel({super.key, required this.box});

  final RenderInspectable box;

  @override
  State<InspectorPanel> createState() => _InspectorPanelState();
}

class _InspectorPanelState extends State<InspectorPanel> {
  final _panelKey = GlobalKey();
  int _tab = 0;
  Offset _downAt = Offset.zero;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    super.dispose();
  }

  bool _onKey(KeyEvent e) {
    if (e is! KeyDownEvent || e.logicalKey != LogicalKeyboardKey.escape) {
      return false;
    }
    RenderInspectable.selection.clear();
    return true;
  }

  // Global routes run after the boxes under the pointer, so a click that
  // selected a box is already marked; any other click (not a drag, not on
  // the panel) closes it.
  void _onPointer(PointerEvent e) {
    if (e is PointerDownEvent) _downAt = e.position;
    if (e is! PointerUpEvent ||
        identical(e, RenderInspectable.selectingUp) ||
        (e.position - _downAt).distance >= kTouchSlop) {
      return;
    }
    final panel = _panelKey.currentContext?.findRenderObject();
    if (panel is RenderBox &&
        (panel.localToGlobal(Offset.zero) & panel.size).contains(e.position)) {
      return;
    }
    RenderInspectable.selection.clear();
  }

  @override
  Widget build(BuildContext context) {
    final box = widget.box;
    final l10n = AppLocalizations.of(context);
    final tabNames = [
      (l10n.ipTabLayout, l10n.ipTabLayout),
      (l10n.ipTabTokens, l10n.ipTabTokens),
      (l10n.ipTabPerf, l10n.ipTabPerfFull),
      (l10n.ipTabA11y, l10n.ipTabA11yFull),
    ];
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final screen = MediaQuery.sizeOf(context);
    final desktop = screen.width >= AppBreakpoints.tablet;
    final strong = BorderSide(color: deco.ruleStrong);

    final header = Padding(
      padding: const EdgeInsets.only(left: AppSpacing.s16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              box.label,
              style: text.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${box.size.width.round()}×${box.size.height.round()}',
            style: text.labelMedium?.copyWith(color: deco.inkMute),
          ),
          IconButton(
            tooltip: l10n.ipClose,
            icon: const Icon(Icons.close, size: 20),
            onPressed: RenderInspectable.selection.clear,
          ),
        ],
      ),
    );

    final tabs = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: deco.rule)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        child: Row(
          children: [
            for (final (i, (short, full)) in tabNames.indexed)
              _TabButton(
                label: short,
                semanticsLabel: full,
                active: i == _tab,
                onPressed: () => setState(() => _tab = i),
              ),
          ],
        ),
      ),
    );

    final body = switch (_tab) {
      0 => _LayoutTab(box: box),
      1 => const _TokensTab(),
      2 => const _PerfTab(),
      _ => _A11yTab(box: box),
    };

    final panel = DecoratedBox(
      key: _panelKey,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        border: desktop ? Border(left: strong) : Border(top: strong),
        // Only the sheet floats over the page; the dock sits beside it.
        boxShadow: desktop ? null : deco.shadowElevated,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: l10n.ipPanelLabel(box.label),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              tabs,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Stack(
      children: [
        if (desktop)
          Positioned(
            top: AppNavbar.height,
            right: 0,
            bottom: 0,
            width: _dockWidth,
            child: panel,
          )
        else
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _sheetHeight(screen),
            child: panel,
          ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.semanticsLabel,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final String semanticsLabel;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      selected: active,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: active ? deco.accentText : scheme.onSurface,
          textStyle: Theme.of(context).textTheme.labelMedium,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
        ),
        // Same mark as the active nav link: a 2px accent underline.
        child: Container(
          padding: const EdgeInsets.only(top: 6, bottom: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: active ? deco.accent : deco.accent.withValues(alpha: 0),
              ),
            ),
          ),
          child: Text(label, semanticsLabel: semanticsLabel),
        ),
      ),
    );
  }
}

// ── Shared bits ─────────────────────────────────────────────────────────

/// `1184`, `0.5`, `∞`.
String _n(double v) => v.isInfinite
    ? '∞'
    : (v - v.round()).abs() < 0.05
    ? '${v.round()}'
    : v.toStringAsFixed(1);

String _range(double min, double max) =>
    min == max ? _n(min) : '${_n(min)}–${_n(max)}';

String _insets(AppLocalizations l10n, EdgeInsets e) {
  final v = [e.top, e.right, e.bottom, e.left].map(_n).toList();
  if (v.toSet().length == 1) {
    return v.first == '0' ? l10n.ipInsetsNone : l10n.ipInsetsAll(v.first);
  }
  return l10n.ipInsetsSides(v[0], v[1], v[2], v[3]);
}

/// Heading for a group of rows inside a tab.
class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s8),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    ),
  );
}

/// One spec-sheet row: a mono key in ink-mute, its value in ink.
class _Row extends StatelessWidget {
  const _Row(this.name, this.value, {this.trailing});

  final String name;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: deco.rule)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              name,
              style: text.labelSmall?.copyWith(color: deco.inkMute),
            ),
          ),
          Expanded(child: Text(value, style: text.labelMedium)),
          ?trailing,
        ],
      ),
    );
  }
}

// ── Layout ──────────────────────────────────────────────────────────────

class _LayoutTab extends ConsumerStatefulWidget {
  const _LayoutTab({required this.box});

  final RenderInspectable box;

  @override
  ConsumerState<_LayoutTab> createState() => _LayoutTabState();
}

class _LayoutTabState extends ConsumerState<_LayoutTab> {
  String? _source;
  Future<String>? _code;

  /// `lib/…/file.dart:42` → (path, 42).
  static (String, int)? _parse(String? source) {
    final m = RegExp(r'^(.+):(\d+)$').firstMatch(source ?? '');
    return m == null ? null : (m[1]!, int.parse(m[2]!));
  }

  @override
  Widget build(BuildContext context) {
    final box = widget.box;
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final src = _parse(box.source);
    if (box.source != _source) {
      _source = box.source;
      _code = src == null ? null : loadLines(src.$1, src.$2);
    }

    // Margin: the gap to the enclosing Inspectable's content box.
    final parent = box.parentBox;
    EdgeInsets? margin;
    if (parent != null && parent.hasSize) {
      final inner = parent.padding.deflateRect(Offset.zero & parent.size);
      final at = MatrixUtils.transformPoint(
        box.getTransformTo(parent),
        Offset.zero,
      );
      margin = EdgeInsets.fromLTRB(
        at.dx - inner.left,
        at.dy - inner.top,
        inner.right - at.dx - box.size.width,
        inner.bottom - at.dy - box.size.height,
      );
    }
    final c = box.constraints;
    final path = box.path;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            children: [
              for (final (i, label) in path.indexed)
                TextSpan(
                  text: i == path.length - 1 ? label : '$label / ',
                  style: i == path.length - 1
                      ? null
                      : TextStyle(color: deco.inkMute),
                ),
            ],
          ),
          style: text.labelSmall,
        ),
        if (box.note != null) ...[
          const SizedBox(height: AppSpacing.s12),
          Text(
            ref.watch(isArabicProvider)
                ? inspectorNoteAr(box.note!) ?? box.note!
                : box.note!,
            style: text.bodyMedium,
          ),
        ],
        const SizedBox(height: AppSpacing.s16),
        _Row(
          l10n.ipConstraints,
          l10n.ipConstraintsValue(
            _range(c.minWidth, c.maxWidth),
            _range(c.minHeight, c.maxHeight),
          ),
        ),
        _Row(l10n.ipSize, '${_n(box.size.width)} × ${_n(box.size.height)}'),
        _Row(l10n.ipPadding, _insets(l10n, box.padding)),
        if (margin != null) _Row(l10n.ipMargin, _insets(l10n, margin)),
        if (box.tokens.isNotEmpty)
          _Row(l10n.ipTokensRow, box.tokens.join('\n')),
        _Heading(l10n.ipSource),
        if (src == null)
          Text(
            l10n.ipNoSource,
            style: text.bodySmall?.copyWith(color: deco.inkMute),
          )
        else ...[
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => openLink(
                context,
                ref,
                Uri.parse(ref.read(sourceUrlProvider)(src.$1, src.$2)),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(l10n.ipViewSource),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          FutureBuilder<String>(
            future: _code,
            builder: (context, snap) => snap.hasData
                ? CodeViewer(
                    code: snap.data!,
                    filename: '${src.$1.split('/').last}:${src.$2}',
                    firstLine: src.$2,
                    wrap: true,
                  )
                : snap.hasError
                ? Text(l10n.ipSourceUnavailable, style: text.bodySmall)
                : const LinearProgressIndicator(),
          ),
        ],
      ],
    );
  }
}

// ── Tokens ──────────────────────────────────────────────────────────────

class _TokensTab extends ConsumerWidget {
  const _TokensTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = ref.watch(themeTokensProvider);
    final notifier = ref.read(themeTokensProvider.notifier);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final brightness = Theme.of(context).brightness;
    String times(double v) => '×${v.toStringAsFixed(v * 8 % 1 == 0 ? 3 : 2)}';

    Widget slider(
      String name,
      double value,
      double min,
      double max,
      int divisions,
      ValueChanged<double> onChanged,
    ) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Row(name, times(value)),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          semanticFormatterCallback: times,
          onChanged: onChanged,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.ipTokensNote,
          style: text.bodySmall?.copyWith(color: deco.inkMute),
        ),
        _Row(l10n.ipAccent, t.accent.label),
        const SizedBox(height: AppSpacing.s8),
        Wrap(
          spacing: AppSpacing.s8,
          children: [
            for (final a in AccentOption.values)
              _Swatch(
                color: a.colors(brightness).fill,
                label: a.label,
                selected: t.accent == a,
                onTap: () => notifier.set(t.copyWith(accent: a)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        slider(
          l10n.ipSpacing,
          t.space,
          0.5,
          1.5,
          4,
          (v) => notifier.set(t.copyWith(space: v)),
        ),
        _Row(l10n.ipRadius, _n(t.radius)),
        const SizedBox(height: AppSpacing.s8),
        Wrap(
          spacing: AppSpacing.s8,
          children: [
            for (final r in const [0.0, 2.0, 4.0])
              ChoiceChip(
                label: Text(_n(r)),
                selected: t.radius == r,
                onSelected: (_) => notifier.set(t.copyWith(radius: r)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        slider(
          l10n.ipTypeScale,
          t.typeScale,
          0.875,
          1.25,
          3,
          (v) => notifier.set(t.copyWith(typeScale: v)),
        ),
        const SizedBox(height: AppSpacing.s16),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            onPressed: t.isDefault ? null : notifier.reset,
            child: Text(l10n.ipResetTokens),
          ),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.square(
            dimension: 44,
            child: Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: selected ? deco.ruleStrong : deco.rule,
                    width: selected ? 2 : 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Performance ─────────────────────────────────────────────────────────

class _PerfTab extends StatefulWidget {
  const _PerfTab();

  @override
  State<_PerfTab> createState() => _PerfTabState();
}

class _PerfTabState extends State<_PerfTab> {
  final _frames = <double>[];

  @override
  void initState() {
    super.initState();
    RenderInspectable.flashRebuilds = true;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  @override
  void dispose() {
    RenderInspectable.flashRebuilds = false;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    super.dispose();
  }

  // The engine reports timings in batches; redrawing this tab adds a cheap
  // frame of its own to the next batch, which is honest to show.
  void _onTimings(List<FrameTiming> timings) {
    if (!mounted) return;
    setState(() {
      _frames.addAll(timings.map((t) => t.totalSpan.inMicroseconds / 1000));
      if (_frames.length > 90) _frames.removeRange(0, _frames.length - 90);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final mute = text.bodySmall?.copyWith(color: deco.inkMute);
    final counts = RenderInspectable.rebuilds.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final avg = _frames.isEmpty
        ? 0.0
        : _frames.reduce((a, b) => a + b) / _frames.length;
    final worst = _frames.fold(0.0, math.max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.ipPerfNote, style: mute),
        _Heading(l10n.ipFrameTime),
        if (_frames.isEmpty)
          Text(l10n.ipNoFrames, style: mute)
        else ...[
          SizedBox(
            height: 64,
            child: CustomPaint(
              painter: _FramesPainter(
                frames: List.of(_frames),
                bar: deco.inkMute,
                over: deco.accent,
                rule: deco.rule,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            l10n.ipFrameStats(avg.toStringAsFixed(1), worst.toStringAsFixed(1)),
            style: text.labelSmall?.copyWith(color: deco.inkMute),
          ),
        ],
        _Heading(l10n.ipRebuilds),
        if (counts.isEmpty)
          Text(l10n.ipNoRebuilds, style: mute)
        else
          for (final e in counts.take(12)) _Row('${e.value}', e.key),
        const SizedBox(height: AppSpacing.s8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => setState(RenderInspectable.rebuilds.clear),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(l10n.ipResetCounts),
          ),
        ),
      ],
    );
  }
}

class _FramesPainter extends CustomPainter {
  _FramesPainter({
    required this.frames,
    required this.bar,
    required this.over,
    required this.rule,
  });

  final List<double> frames;
  final Color bar;
  final Color over;
  final Color rule;

  static const _budget = 1000 / 60;

  @override
  void paint(Canvas canvas, Size size) {
    // Scale fits 2 frame budgets, or the worst frame if that's longer.
    final top = math.max(_budget * 2, frames.fold(0.0, math.max));
    final w = size.width / 90;
    for (final (i, ms) in frames.indexed) {
      final h = math.max(1.0, size.height * ms / top);
      canvas.drawRect(
        Rect.fromLTWH(i * w, size.height - h, math.max(1, w - 1), h),
        Paint()..color = ms > _budget ? over : bar,
      );
    }
    final y = size.height - size.height * _budget / top;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), Paint()..color = rule);
  }

  @override
  bool shouldRepaint(_FramesPainter old) => old.frames != frames;
}

// ── Accessibility ───────────────────────────────────────────────────────

class _A11yTab extends StatefulWidget {
  const _A11yTab({required this.box});

  final RenderInspectable box;

  @override
  State<_A11yTab> createState() => _A11yTabState();
}

class _A11yTabState extends State<_A11yTab> {
  final _overlay = OverlayPortalController();
  SemanticsHandle? _handle;
  SemanticsOwner? _owner;
  List<Rect> _small = const [];
  List<String> _labels = const [];

  @override
  void initState() {
    super.initState();
    // Semantics are usually off on web until a screen reader asks; turn
    // them on only while this tab is open.
    _handle = SemanticsBinding.instance.ensureSemantics();
    _overlay.show();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) _attach();
    });
  }

  double _dpr = 1;

  void _attach() {
    final owner = widget.box.owner?.semanticsOwner;
    if (owner == null) {
      SchedulerBinding.instance
        ..addPostFrameCallback((_) {
          if (mounted) _attach();
        })
        ..scheduleFrame();
      return;
    }
    _owner = owner..addListener(_onSemantics);
    _scan();
  }

  @override
  void didUpdateWidget(_A11yTab old) {
    super.didUpdateWidget(old);
    if (old.box != widget.box) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scan();
      });
    }
  }

  @override
  void dispose() {
    _owner?.removeListener(_onSemantics);
    _handle?.dispose();
    super.dispose();
  }

  // Semantics change mid-frame; read them once the frame is done.
  void _onSemantics() => SchedulerBinding.instance.addPostFrameCallback((_) {
    if (mounted) _scan();
  });

  void _scan() {
    final root = _owner?.rootSemanticsNode;
    final box = widget.box;
    if (root == null || !box.attached) return;
    final dpr = _dpr;
    final boxRect = MatrixUtils.transformRect(
      box.getTransformTo(null),
      Offset.zero & box.size,
    );
    final small = <Rect>[];
    final labels = <String>[];
    void visit(SemanticsNode n, Matrix4 parent) {
      final m = n.transform == null ? parent : parent.multiplied(n.transform!);
      final r = MatrixUtils.transformRect(m, n.rect);
      final rect = Rect.fromLTRB(
        r.left / dpr,
        r.top / dpr,
        r.right / dpr,
        r.bottom / dpr,
      );
      if (!n.isInvisible && !n.isMergedIntoParent) {
        final d = n.getSemanticsData();
        if (d.hasAction(SemanticsAction.tap) &&
            (rect.width < 43.5 || rect.height < 43.5)) {
          small.add(rect);
        }
        if (d.label.isNotEmpty && boxRect.overlaps(rect)) {
          final f = d.flagsCollection;
          final role = f.isButton
              ? 'button'
              : f.isLink
              ? 'link'
              : f.isHeader
              ? 'heading'
              : f.isTextField
              ? 'textField'
              : f.isImage
              ? 'image'
              : 'text';
          labels.add('$role|${d.label.replaceAll('\n', ' ')}');
        }
      }
      n.visitChildren((c) {
        visit(c, m);
        return true;
      });
    }

    visit(root, Matrix4.identity());
    if (_sameRects(small, _small) && _sameStrings(labels, _labels)) return;
    setState(() {
      _small = small;
      _labels = labels;
    });
  }

  static bool _sameRects(List<Rect> a, List<Rect> b) =>
      a.length == b.length &&
      Iterable.generate(a.length).every((i) => a[i] == b[i]);

  static bool _sameStrings(List<String> a, List<String> b) =>
      a.length == b.length &&
      Iterable.generate(a.length).every((i) => a[i] == b[i]);

  /// Text colours in the box, contrast-checked against the page ground.
  List<_Contrast> _contrasts(Color ground) {
    final out = <String, _Contrast>{};
    void add(TextStyle? s, TextStyle? root) {
      final color = s?.color ?? root?.color;
      if (color == null) return;
      final size = s?.fontSize ?? root?.fontSize ?? 14;
      final weight = s?.fontWeight ?? root?.fontWeight ?? FontWeight.w400;
      final c = _Contrast(
        Color.alphaBlend(color, ground),
        ground,
        size,
        weight,
      );
      out.putIfAbsent(c.key, () => c);
    }

    void walk(RenderObject r) {
      if (r is RenderParagraph) {
        final root = r.text.style;
        add(root, null);
        r.text.visitChildren((span) {
          if (span is TextSpan && span.style?.color != null) {
            add(span.style, root);
          }
          return true;
        });
      }
      r.visitChildren(walk);
    }

    walk(widget.box);
    return out.values.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final deco = AppDecorations.of(context);
    final mute = text.bodySmall?.copyWith(color: deco.inkMute);
    final contrasts = _contrasts(scheme.surface);
    _dpr = View.of(context).devicePixelRatio;

    return OverlayPortal(
      controller: _overlay,
      overlayChildBuilder: (_) => Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(painter: _TargetsPainter(_small, scheme.error)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Heading(l10n.ipTapTargets),
          Text(
            _small.isEmpty ? l10n.ipTapOk : l10n.ipTapSmall(_small.length),
            style: text.bodySmall,
          ),
          _Heading(l10n.ipSemanticsIn),
          if (_labels.isEmpty)
            Text(l10n.ipNoLabels, style: mute)
          else
            for (final l in _labels.take(24))
              _Row(switch (l.split('|').first) {
                'button' => l10n.ipRoleButton,
                'link' => l10n.ipRoleLink,
                'heading' => l10n.ipRoleHeading,
                'textField' => l10n.ipRoleTextField,
                'image' => l10n.ipRoleImage,
                _ => l10n.ipRoleText,
              }, l.substring(l.indexOf('|') + 1)),
          _Heading(l10n.ipTextContrast),
          Text(l10n.ipContrastNote, style: mute),
          for (final c in contrasts)
            _Row(
              c.hex,
              '${_n(c.size)}px  ${c.ratio.toStringAsFixed(1)}:1  ${c.verdict(l10n)}',
              trailing: Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 2),
                color: c.color,
              ),
            ),
        ],
      ),
    );
  }
}

class _Contrast {
  _Contrast(this.color, Color ground, this.size, this.weight)
    : ratio = _ratio(color, ground);

  final Color color;
  final double size;
  final FontWeight weight;
  final double ratio;

  static double _ratio(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  String get hex =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  String get key => '$hex|${_n(size)}|${weight.value}';

  /// WCAG AA: 3:1 for large text (24px, or 18.66px bold), else 4.5:1.
  String verdict(AppLocalizations l10n) {
    final large = size >= 24 || (size >= 18.66 && weight.value >= 700);
    return ratio >= 4.5
        ? l10n.ipAA
        : large && ratio >= 3
        ? l10n.ipAALarge
        : l10n.ipFailsAA;
  }
}

class _TargetsPainter extends CustomPainter {
  _TargetsPainter(this.rects, this.color);

  final List<Rect> rects;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color.withValues(alpha: 0.08);
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final r in rects) {
      canvas
        ..drawRect(r, fill)
        ..drawRect(r.deflate(0.75), line);
    }
  }

  @override
  bool shouldRepaint(_TargetsPainter old) =>
      old.rects != rects || old.color != color;
}
