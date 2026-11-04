import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'origami_controller.dart';
import 'origami_model.dart';

class OrigamiGridAnimation extends StatefulWidget {
  const OrigamiGridAnimation({
    super.key,
    this.steps,
    this.stepDuration = const Duration(milliseconds: 600),
    this.stepDelay = const Duration(milliseconds: 140),
    this.enableTapToReverse = true,
    this.enableScrollScrub = true,
    this.enableHoverPause = true,
    this.borderRadius = 28,
    this.initialSpeed = 1,
    this.panelColors = const [
      Color(0xFF0F766E),
      Color(0xFF0284C7),
      Color(0xFFF59E0B),
      Color(0xFFEF4444),
    ],
    this.onControllerReady,
  });

  final List<OrigamiStep>? steps;
  final Duration stepDuration;
  final Duration stepDelay;
  final bool enableTapToReverse;
  final bool enableScrollScrub;
  final bool enableHoverPause;
  final double borderRadius;
  final double initialSpeed;
  final List<Color> panelColors;
  final ValueChanged<OrigamiAnimationController>? onControllerReady;

  @override
  State<OrigamiGridAnimation> createState() => _OrigamiGridAnimationState();
}

class _OrigamiGridAnimationState extends State<OrigamiGridAnimation>
    with TickerProviderStateMixin {
  late OrigamiAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
  }

  @override
  void didUpdateWidget(covariant OrigamiGridAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.steps != widget.steps ||
        oldWidget.stepDuration != widget.stepDuration ||
        oldWidget.stepDelay != widget.stepDelay) {
      _controller.dispose();
      _controller = _createController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  OrigamiAnimationController _createController() {
    final controller = OrigamiAnimationController(
      vsync: this,
      steps: widget.steps,
      stepDuration: widget.stepDuration,
      stepDelay: widget.stepDelay,
      speed: widget.initialSpeed,
    );
    widget.onControllerReady?.call(controller);
    return controller;
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!widget.enableScrollScrub || event is! PointerScrollEvent) {
      return;
    }

    _controller.scrubBy(event.scrollDelta.dy / 320);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dimension = _resolveDimension(constraints);

        return Center(
          child: SizedBox.square(
            dimension: dimension,
            child: MouseRegion(
              onEnter: widget.enableHoverPause
                  ? (_) => _controller.pause()
                  : null,
              onExit: widget.enableHoverPause
                  ? (_) => _controller.resume()
                  : null,
              child: Listener(
                onPointerSignal: _handlePointerSignal,
                child: GestureDetector(
                  onTap: widget.enableTapToReverse
                      ? _controller.toggleDirection
                      : null,
                  child: AnimatedBuilder(
                    animation: _controller.listenable,
                    builder: (context, child) {
                      return OrigamiGridAnimationView(
                        step: _controller.currentStep,
                        borderRadius: widget.borderRadius,
                        panelColors: widget.panelColors,
                        showPausedOverlay: _controller.isPaused,
                        showReverseBadge: _controller.isReversed,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _resolveDimension(BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : 280.0;
    final maxHeight = constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : maxWidth;
    final shortestSide = math.min(maxWidth, maxHeight);

    if (shortestSide.isFinite && shortestSide > 0) {
      return shortestSide;
    }

    return 280.0;
  }
}

class OrigamiGridAnimationView extends StatelessWidget {
  const OrigamiGridAnimationView({
    super.key,
    required this.step,
    required this.borderRadius,
    required this.panelColors,
    required this.showPausedOverlay,
    required this.showReverseBadge,
  });

  final OrigamiStep step;
  final double borderRadius;
  final List<Color> panelColors;
  final bool showPausedOverlay;
  final bool showReverseBadge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foldIntensity = _foldIntensity(step);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0012)
        ..rotateX(0.04 + (foldIntensity * 0.05))
        ..rotateY(-0.03 + (foldIntensity * 0.04)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const gap = 10.0;
              final panelWidth = (constraints.maxWidth - gap) / 2;
              final panelHeight = (constraints.maxHeight - gap) / 2;

              return Stack(
                children: [
                  _buildPanel(
                    quadrant: OrigamiQuadrant.topLeft,
                    scale: step.scaleFor(OrigamiQuadrant.topLeft),
                    color: panelColors[0],
                    left: 0,
                    top: 0,
                    width: panelWidth,
                    height: panelHeight,
                    foldIntensity: foldIntensity,
                  ),
                  _buildPanel(
                    quadrant: OrigamiQuadrant.topRight,
                    scale: step.scaleFor(OrigamiQuadrant.topRight),
                    color: panelColors[1],
                    left: panelWidth + gap,
                    top: 0,
                    width: panelWidth,
                    height: panelHeight,
                    foldIntensity: foldIntensity,
                  ),
                  _buildPanel(
                    quadrant: OrigamiQuadrant.bottomLeft,
                    scale: step.scaleFor(OrigamiQuadrant.bottomLeft),
                    color: panelColors[2],
                    left: 0,
                    top: panelHeight + gap,
                    width: panelWidth,
                    height: panelHeight,
                    foldIntensity: foldIntensity,
                  ),
                  _buildPanel(
                    quadrant: OrigamiQuadrant.bottomRight,
                    scale: step.scaleFor(OrigamiQuadrant.bottomRight),
                    color: panelColors[3],
                    left: panelWidth + gap,
                    top: panelHeight + gap,
                    width: panelWidth,
                    height: panelHeight,
                    foldIntensity: foldIntensity,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _ModeBadge(
                      label: showReverseBadge ? 'Reverse' : 'Loop',
                    ),
                  ),
                  if (showPausedOverlay)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Center(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xCC0F172A),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(14),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPanel({
    required OrigamiQuadrant quadrant,
    required OrigamiPanelScale scale,
    required Color color,
    required double left,
    required double top,
    required double width,
    required double height,
    required double foldIntensity,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Transform(
        alignment: _pivotFor(quadrant),
        transform: Matrix4.identity()
          ..scale(scale.scaleX, scale.scaleY)
          ..rotateZ(_rotationFor(quadrant) * foldIntensity),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: _radiusFor(quadrant),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Alignment _pivotFor(OrigamiQuadrant quadrant) {
    switch (quadrant) {
      case OrigamiQuadrant.topLeft:
        return Alignment.bottomRight;
      case OrigamiQuadrant.topRight:
        return Alignment.bottomLeft;
      case OrigamiQuadrant.bottomLeft:
        return Alignment.topRight;
      case OrigamiQuadrant.bottomRight:
        return Alignment.topLeft;
    }
  }

  BorderRadius _radiusFor(OrigamiQuadrant quadrant) {
    final outer = Radius.circular(borderRadius * 0.55);
    final inner = Radius.circular(borderRadius * 0.22);

    switch (quadrant) {
      case OrigamiQuadrant.topLeft:
        return BorderRadius.only(
          topLeft: outer,
          topRight: inner,
          bottomLeft: inner,
          bottomRight: inner,
        );
      case OrigamiQuadrant.topRight:
        return BorderRadius.only(
          topLeft: inner,
          topRight: outer,
          bottomLeft: inner,
          bottomRight: inner,
        );
      case OrigamiQuadrant.bottomLeft:
        return BorderRadius.only(
          topLeft: inner,
          topRight: inner,
          bottomLeft: outer,
          bottomRight: inner,
        );
      case OrigamiQuadrant.bottomRight:
        return BorderRadius.only(
          topLeft: inner,
          topRight: inner,
          bottomLeft: inner,
          bottomRight: outer,
        );
    }
  }

  double _rotationFor(OrigamiQuadrant quadrant) {
    switch (quadrant) {
      case OrigamiQuadrant.topLeft:
      case OrigamiQuadrant.bottomRight:
        return -0.04;
      case OrigamiQuadrant.topRight:
      case OrigamiQuadrant.bottomLeft:
        return 0.04;
    }
  }

  double _foldIntensity(OrigamiStep step) {
    final values = [
      step.topLeftScaleX,
      step.topLeftScaleY,
      step.topRightScaleX,
      step.topRightScaleY,
      step.bottomLeftScaleX,
      step.bottomLeftScaleY,
      step.bottomRightScaleX,
      step.bottomRightScaleY,
    ];

    final totalDelta = values.fold<double>(
      0,
      (sum, value) => sum + (1 - value).abs(),
    );

    final averageDelta = totalDelta / values.length;
    return (averageDelta / 0.5).clamp(0.0, 1.0);
  }
}

class _ModeBadge extends StatelessWidget {
  const _ModeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xCC0F172A),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
