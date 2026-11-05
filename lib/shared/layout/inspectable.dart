import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/app_decorations.dart';

/// Inspector mode (docs/DESIGN.md §7): while developer mode is on, outlines
/// this box, hatches its [padding] and, when hovered, tapped or focused,
/// shows a tag like `Card 352×240`. Works in release builds.
///
/// When developer mode is off, the render object paints only its child: no
/// extra layer, no mouse annotation, and toggling never remounts [child].
class Inspectable extends ConsumerWidget {
  const Inspectable({
    super.key,
    required this.label,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  /// Widget name shown in the tag, e.g. `HeroSection`.
  final String label;

  /// Applied around [child], and shown as hatching in inspector mode.
  final EdgeInsets padding;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deco = AppDecorations.of(context);
    return _InspectBox(
      enabled: ref.watch(developerModeProvider),
      label: label,
      padding: padding,
      accent: deco.accent,
      onAccent: deco.onAccent,
      tagStyle: Theme.of(context).textTheme.labelSmall!,
      shadow: deco.shadowSoft.first.color,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: (focused) {
          final r = context.findRenderObject();
          if (r is RenderInspectable) r.focused = focused;
        },
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _InspectBox extends SingleChildRenderObjectWidget {
  const _InspectBox({
    required this.enabled,
    required this.label,
    required this.padding,
    required this.accent,
    required this.onAccent,
    required this.tagStyle,
    required this.shadow,
    required super.child,
  });

  final bool enabled;
  final String label;
  final EdgeInsets padding;
  final Color accent;
  final Color onAccent;
  final TextStyle tagStyle;
  final Color shadow;

  @override
  RenderInspectable createRenderObject(BuildContext context) =>
      RenderInspectable(
        enabled: enabled,
        label: label,
        padding: padding,
        accent: accent,
        onAccent: onAccent,
        tagStyle: tagStyle,
        shadow: shadow,
      );

  @override
  void updateRenderObject(BuildContext context, RenderInspectable r) => r
    ..enabled = enabled
    ..label = label
    ..padding = padding
    ..accent = accent
    ..onAccent = onAccent
    ..tagStyle = tagStyle
    ..shadow = shadow;
}

@visibleForTesting
class RenderInspectable extends RenderProxyBox
    implements MouseTrackerAnnotation {
  RenderInspectable({
    required bool enabled,
    required String label,
    required EdgeInsets padding,
    required Color accent,
    required Color onAccent,
    required TextStyle tagStyle,
    required Color shadow,
  }) : _enabled = enabled,
       _label = label,
       _padding = padding,
       _accent = accent,
       _onAccent = onAccent,
       _tagStyle = tagStyle,
       _shadow = shadow;

  // Boxes under the pointer (or holding focus); the deepest one is active.
  static final _engaged = <RenderInspectable>{};
  static RenderInspectable? _active;
  static int? _lastTouch;

  @visibleForTesting
  static RenderInspectable? get active => _active;

  static void _refresh() {
    RenderInspectable? next;
    for (final r in _engaged) {
      if (next == null || r.depth > next.depth) next = r;
    }
    if (next == _active) return;
    final previous = _active;
    _active = next;
    previous?.markNeedsPaint();
    next?.markNeedsPaint();
  }

  void _engage(bool on) {
    on ? _engaged.add(this) : _engaged.remove(this);
    _refresh();
  }

  bool _enabled;
  bool get enabled => _enabled;
  set enabled(bool v) {
    if (v == _enabled) return;
    _enabled = v;
    if (!v) _engage(false);
    markNeedsPaint();
  }

  String _label;
  set label(String v) {
    if (v == _label) return;
    _label = v;
    markNeedsPaint();
  }

  EdgeInsets _padding;
  set padding(EdgeInsets v) {
    if (v == _padding) return;
    _padding = v;
    markNeedsPaint();
  }

  Color _accent;
  set accent(Color v) {
    if (v == _accent) return;
    _accent = v;
    markNeedsPaint();
  }

  Color _onAccent;
  set onAccent(Color v) {
    if (v == _onAccent) return;
    _onAccent = v;
    markNeedsPaint();
  }

  TextStyle _tagStyle;
  set tagStyle(TextStyle v) {
    if (v == _tagStyle) return;
    _tagStyle = v;
    markNeedsPaint();
  }

  Color _shadow;
  set shadow(Color v) {
    if (v == _shadow) return;
    _shadow = v;
    markNeedsPaint();
  }

  set focused(bool v) {
    if (_enabled) _engage(v);
  }

  // While inspecting, the whole box (padding included) is hoverable.
  @override
  bool hitTestSelf(Offset position) => _enabled;

  // Mouse: hover engages. Inert (not tracked at all) while disabled.
  @override
  bool get validForMouseTracker => _enabled && attached;
  @override
  MouseCursor get cursor => MouseCursor.defer;
  @override
  PointerEnterEventListener? get onEnter =>
      (_) => _engage(true);
  @override
  PointerExitEventListener? get onExit =>
      (_) => _engage(false);

  // Touch: a tap selects the deepest box under it; the child still gets it.
  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (!_enabled || event is! PointerDownEvent) return;
    if (event.kind == PointerDeviceKind.mouse) return;
    if (_lastTouch != event.pointer) {
      _lastTouch = event.pointer;
      _engaged.clear();
    }
    _engaged.add(this);
    _refresh();
  }

  @override
  void detach() {
    _engaged.remove(this);
    if (_active == this) _active = null;
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (!_enabled) return;
    final canvas = context.canvas;
    final box = offset & size;
    final isActive = _active == this;

    // Padding as 45° hatching between the box and its child.
    if (_padding != EdgeInsets.zero) {
      final inner = _padding.deflateRect(box);
      final hatch = Paint()
        ..color = _accent.withValues(alpha: 0.35)
        ..strokeWidth = 1;
      canvas
        ..save()
        ..clipPath(
          Path()
            ..fillType = PathFillType.evenOdd
            ..addRect(box)
            ..addRect(inner),
        );
      for (var x = box.left - box.height; x < box.right; x += 6) {
        canvas.drawLine(
          Offset(x, box.bottom),
          Offset(x + box.height, box.top),
          hatch,
        );
      }
      canvas.restore();
    }

    if (isActive) {
      canvas.drawRect(box, Paint()..color = _accent.withValues(alpha: 0.04));
    }
    canvas.drawRect(
      box.deflate(isActive ? 1 : 0.5),
      Paint()
        ..color = _accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = isActive ? 2 : 1,
    );

    if (isActive) _paintTag(canvas, box);
  }

  void _paintTag(Canvas canvas, Rect box) {
    final tag = TextPainter(
      text: TextSpan(
        text: '$_label ${size.width.round()}×${size.height.round()}',
        style: _tagStyle.copyWith(color: _onAccent),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    const pad = EdgeInsets.symmetric(horizontal: 6, vertical: 3);
    final w = tag.width + pad.horizontal;
    final h = tag.height + pad.vertical;
    // Above the box when there is room, else just inside its top edge.
    final top = box.top >= h ? box.top - h : box.top;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(box.left, top, w, h),
      const Radius.circular(4),
    );
    canvas
      ..drawRRect(
        rect.shift(const Offset(0, 2)),
        Paint()
          ..color = _shadow
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      )
      ..drawRRect(rect, Paint()..color = _accent);
    tag.paint(canvas, Offset(box.left + pad.left, top + pad.top));
    tag.dispose();
  }
}
