import 'package:flutter/material.dart';

/// Shows [placeholder] until this widget first scrolls into view, then builds
/// [builder] once and keeps it. Keeps heavy previews off the first frame.
class LazyInView extends StatefulWidget {
  const LazyInView({
    super.key,
    required this.builder,
    required this.placeholder,
  });

  final WidgetBuilder builder;
  final Widget placeholder;

  @override
  State<LazyInView> createState() => _LazyInViewState();
}

class _LazyInViewState extends State<LazyInView> {
  ScrollPosition? _position;
  bool _visible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position?..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_visible || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height) {
      _position?.removeListener(_check);
      setState(() => _visible = true);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _visible ? widget.builder(context) : widget.placeholder;
}
