import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:portfolio/features/app_simulator/widgets/magnetic_card_grid/magnetic_controller.dart';
import 'package:portfolio/features/app_simulator/widgets/magnetic_card_grid/magnetic_model.dart';

class MagneticCardGrid extends StatefulWidget {
  const MagneticCardGrid({
    super.key,
    required this.cards,
    this.spacing = 18,
    this.onControllerReady,
  });

  final List<MagneticCardData> cards;
  final double spacing;
  final ValueChanged<MagneticCardGridController>? onControllerReady;

  @override
  State<MagneticCardGrid> createState() => _MagneticCardGridState();
}

class _MagneticCardGridState extends State<MagneticCardGrid> {
  late MagneticCardGridController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
  }

  @override
  void didUpdateWidget(covariant MagneticCardGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cards != widget.cards) {
      _controller.dispose();
      _controller = _createController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  MagneticCardGridController _createController() {
    final controller = MagneticCardGridController(cards: widget.cards);
    widget.onControllerReady?.call(controller);
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _resolveColumns(constraints.maxWidth);
        final width =
            (constraints.maxWidth - ((columns - 1) * widget.spacing)) / columns;

        return MouseRegion(
          onHover: (event) => _controller.updateCursor(event.position),
          onExit: (_) => _controller.updateCursor(null),
          child: Wrap(
            spacing: widget.spacing,
            runSpacing: widget.spacing,
            children: List<Widget>.generate(widget.cards.length, (index) {
              return SizedBox(
                width: width,
                child: _MagneticCardTile(
                  key: ValueKey('magnetic-card-$index'),
                  index: index,
                  data: widget.cards[index],
                  controller: _controller,
                ),
              );
            }),
          ),
        );
      },
    );
  }

  int _resolveColumns(double width) {
    if (width < 560) {
      return 1;
    }
    if (width < 860) {
      return 2;
    }
    if (width < 1160) {
      return 3;
    }
    return 4;
  }
}

class _MagneticCardTile extends StatefulWidget {
  const _MagneticCardTile({
    super.key,
    required this.index,
    required this.data,
    required this.controller,
  });

  final int index;
  final MagneticCardData data;
  final MagneticCardGridController controller;

  @override
  State<_MagneticCardTile> createState() => _MagneticCardTileState();
}

class _MagneticCardTileState extends State<_MagneticCardTile> {
  final GlobalKey _cardKey = GlobalKey();
  MagneticCardVisualState _previousState = const MagneticCardVisualState();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateRect());
  }

  @override
  void didUpdateWidget(covariant _MagneticCardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateRect());
  }

  void _updateRect() {
    final context = _cardKey.currentContext;
    if (context == null) {
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return;
    }

    final offset = renderBox.localToGlobal(Offset.zero);
    widget.controller.registerCardRect(widget.index, offset & renderBox.size);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateRect());

    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 1.08,
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            final targetState = widget.controller.stateFor(widget.index);

            return TweenAnimationBuilder<MagneticCardVisualState>(
              tween: MagneticCardVisualStateTween(
                begin: _previousState,
                end: targetState,
              ),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              onEnd: () {
                _previousState = targetState;
              },
              builder: (context, animatedState, child) {
                return Listener(
                  onPointerDown: _touch,
                  onPointerMove: _touch,
                  onPointerUp: _release,
                  onPointerCancel: _release,
                  child: MouseRegion(
                    key: _cardKey,
                    onEnter: (_) =>
                        widget.controller.setHovered(widget.index, true),
                    onExit: (_) =>
                        widget.controller.setHovered(widget.index, false),
                    onHover: (event) => widget.controller.updateLocalPointer(
                      widget.index,
                      event.localPosition,
                    ),
                    child: GestureDetector(
                      onTapDown: (_) =>
                          widget.controller.setPressed(widget.index, true),
                      onTapUp: (_) =>
                          widget.controller.setPressed(widget.index, false),
                      onTapCancel: () =>
                          widget.controller.setPressed(widget.index, false),
                      child: Transform.translate(
                        offset: animatedState.translation,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..scaleByDouble(
                              animatedState.scale,
                              animatedState.scale,
                              animatedState.scale,
                              1,
                            )
                            ..rotateX(animatedState.rotationX)
                            ..rotateY(animatedState.rotationY),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  widget.data.color.withValues(alpha: 0.92),
                                  widget.data.color.withValues(alpha: 0.72),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.18),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: animatedState.shadowOpacity,
                                  ),
                                  blurRadius: animatedState.shadowBlur,
                                  offset: animatedState.shadowOffset,
                                ),
                                BoxShadow(
                                  color: widget.data.color.withValues(
                                    alpha: animatedState.glowOpacity,
                                  ),
                                  blurRadius: 26,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Transform.translate(
                                offset: animatedState.parallaxOffset,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.16,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.data.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.data.subtitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.88,
                                            ),
                                            height: 1.35,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Touch has no hover: a finger on a card drives the same pull and tilt.
  // A Listener stays out of the gesture arena, so scrolling still works.
  void _touch(PointerEvent e) {
    if (e.kind == PointerDeviceKind.mouse) return;
    widget.controller
      ..setHovered(widget.index, true)
      ..updateLocalPointer(widget.index, e.localPosition)
      ..updateCursor(e.position);
  }

  void _release(PointerEvent e) {
    if (e.kind == PointerDeviceKind.mouse) return;
    widget.controller
      ..setHovered(widget.index, false)
      ..updateCursor(null);
  }
}

class MagneticCardVisualStateTween extends Tween<MagneticCardVisualState> {
  MagneticCardVisualStateTween({required super.begin, required super.end});

  @override
  MagneticCardVisualState lerp(double t) {
    return MagneticCardVisualState.lerp(begin!, end!, t);
  }
}
