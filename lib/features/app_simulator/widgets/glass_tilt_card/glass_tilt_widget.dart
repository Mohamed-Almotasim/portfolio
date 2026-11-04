import 'dart:ui';

import 'package:flutter/material.dart';

import 'glass_tilt_controller.dart';
import 'glass_tilt_model.dart';

class GlassTiltCard extends StatefulWidget {
  const GlassTiltCard({
    super.key,
    required this.data,
    this.aspectRatio = 1.18,
    this.onControllerReady,
  });

  final GlassCardData data;
  final double aspectRatio;
  final ValueChanged<GlassTiltCardController>? onControllerReady;

  @override
  State<GlassTiltCard> createState() => _GlassTiltCardState();
}

class _GlassTiltCardState extends State<GlassTiltCard> {
  late GlassTiltCardController _controller;
  GlassTiltVisualState _previousState = const GlassTiltVisualState();

  @override
  void initState() {
    super.initState();
    _controller = GlassTiltCardController();
    widget.onControllerReady?.call(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = Size(constraints.maxWidth, constraints.maxHeight);

        return RepaintBoundary(
          child: MouseRegion(
            onEnter: (_) => _controller.setHovered(true),
            onExit: (_) => _controller.setHovered(false),
            onHover: (event) => _controller.updatePointer(event.localPosition),
            child: GestureDetector(
              onTapDown: (_) => _controller.setPressed(true),
              onTapUp: (_) => _controller.setPressed(false),
              onTapCancel: () => _controller.setPressed(false),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final targetState = _controller.stateFor(cardSize);

                  return TweenAnimationBuilder<GlassTiltVisualState>(
                    tween: GlassTiltVisualStateTween(
                      begin: _previousState,
                      end: targetState,
                    ),
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    onEnd: () {
                      _previousState = targetState;
                    },
                    builder: (context, animatedState, child) {
                      return AspectRatio(
                        aspectRatio: widget.aspectRatio,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0011)
                            ..scale(animatedState.scale)
                            ..rotateX(animatedState.rotationX)
                            ..rotateY(animatedState.rotationY),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: animatedState.shadowOpacity,
                                        ),
                                        blurRadius: animatedState.shadowBlur,
                                        offset: animatedState.shadowOffset,
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withValues(
                                          alpha:
                                              animatedState.borderGlowOpacity,
                                        ),
                                        blurRadius: 30,
                                        spreadRadius: 0.8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 18,
                                    sigmaY: 18,
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(
                                            0xFFFFFFFF,
                                          ).withValues(alpha: 0.22),
                                          const Color(
                                            0xFFF8FAFC,
                                          ).withValues(alpha: 0.08),
                                          const Color(
                                            0xFFFFFFFF,
                                          ).withValues(alpha: 0.04),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.24,
                                        ),
                                      ),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Positioned.fill(
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: RadialGradient(
                                                center: const Alignment(
                                                  -0.75,
                                                  -0.9,
                                                ),
                                                radius: 1.2,
                                                colors: [
                                                  Colors.white.withValues(
                                                    alpha: 0.18,
                                                  ),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: IgnorePointer(
                                            child: _GlassGlareOverlay(
                                              alignment:
                                                  animatedState.glareAlignment,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(28),
                                          child: Transform.translate(
                                            offset:
                                                animatedState.parallaxOffset,
                                            child: _GlassCardContent(
                                              data: widget.data,
                                            ),
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
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlassCardContent extends StatelessWidget {
  const _GlassCardContent({required this.data});

  final GlassCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white.withValues(alpha: 0.18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Icon(data.icon, color: Colors.white, size: 28),
        ),
        const Spacer(),
        Text(
          data.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.84),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _GlassGlareOverlay extends StatelessWidget {
  const _GlassGlareOverlay({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: alignment,
          radius: 0.75,
          colors: [
            Colors.white.withValues(alpha: 0.38),
            Colors.white.withValues(alpha: 0.12),
            Colors.transparent,
          ],
          stops: const [0, 0.28, 1],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.16),
              Colors.transparent,
              Colors.white.withValues(alpha: 0.08),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassTiltVisualStateTween extends Tween<GlassTiltVisualState> {
  GlassTiltVisualStateTween({required super.begin, required super.end});

  @override
  GlassTiltVisualState lerp(double t) {
    return GlassTiltVisualState.lerp(begin!, end!, t);
  }
}
