import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../widgets/origami_animation/origami_controller.dart';
import '../widgets/origami_animation/origami_model.dart';
import '../widgets/origami_animation/origami_widget.dart';

class OrigamiGridAnimationDemo extends StatefulWidget {
  const OrigamiGridAnimationDemo({super.key});

  @override
  State<OrigamiGridAnimationDemo> createState() =>
      _OrigamiGridAnimationDemoState();
}

class _OrigamiGridAnimationDemoState extends State<OrigamiGridAnimationDemo> {
  late final List<OrigamiStep> _jsonSteps;
  OrigamiAnimationController? _controller;
  double _speed = 1;

  @override
  void initState() {
    super.initState();
    _jsonSteps = _buildStepsFromJson();
  }

  List<OrigamiStep> _buildStepsFromJson() {
    const rawSteps = [
      {
        'topLeftScaleX': 1.0,
        'topLeftScaleY': 1.0,
        'topRightScaleX': 1.0,
        'topRightScaleY': 1.0,
        'bottomLeftScaleX': 1.0,
        'bottomLeftScaleY': 1.0,
        'bottomRightScaleX': 1.0,
        'bottomRightScaleY': 1.0,
      },
      {
        'topLeftScaleX': 0.76,
        'topLeftScaleY': 0.58,
        'topRightScaleX': 0.58,
        'topRightScaleY': 0.76,
        'bottomLeftScaleX': 0.58,
        'bottomLeftScaleY': 0.76,
        'bottomRightScaleX': 0.76,
        'bottomRightScaleY': 0.58,
      },
      {
        'topLeftScaleX': 0.52,
        'topLeftScaleY': 0.88,
        'topRightScaleX': 0.88,
        'topRightScaleY': 0.52,
        'bottomLeftScaleX': 0.88,
        'bottomLeftScaleY': 0.52,
        'bottomRightScaleX': 0.52,
        'bottomRightScaleY': 0.88,
      },
      {
        'topLeftScaleX': 0.68,
        'topLeftScaleY': 0.76,
        'topRightScaleX': 0.76,
        'topRightScaleY': 0.68,
        'bottomLeftScaleX': 0.76,
        'bottomLeftScaleY': 0.68,
        'bottomRightScaleX': 0.68,
        'bottomRightScaleY': 0.76,
      },
    ];

    return rawSteps.map(OrigamiStep.fromJson).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;
          final controlsWidth = isWide ? 180.0 : math.min(220.0, constraints.maxWidth);

          return Padding(
            padding: const EdgeInsets.all(8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.35,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: isWide
                    ? Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: OrigamiGridAnimation(
                                  steps: _jsonSteps,
                                  initialSpeed: _speed,
                                  onControllerReady: (controller) {
                                    _controller = controller;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: controlsWidth,
                            child: _ControlsColumn(
                              speed: _speed,
                              scrubValue: _controller?.scrubValue ?? 0,
                              onSpeedChanged: (value) {
                                setState(() {
                                  _speed = value;
                                });
                                _controller?.setSpeed(value);
                              },
                              onScrubStart: () => _controller?.pause(),
                              onScrubChanged: (value) {
                                setState(() {
                                  _controller?.setScrubValue(value);
                                });
                              },
                              onScrubEnd: () => _controller?.resume(),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: OrigamiGridAnimation(
                              steps: _jsonSteps,
                              initialSpeed: _speed,
                              onControllerReady: (controller) {
                                _controller = controller;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: controlsWidth,
                              child: _ControlsColumn(
                                speed: _speed,
                                scrubValue: _controller?.scrubValue ?? 0,
                                onSpeedChanged: (value) {
                                  setState(() {
                                    _speed = value;
                                  });
                                  _controller?.setSpeed(value);
                                },
                                onScrubStart: () => _controller?.pause(),
                                onScrubChanged: (value) {
                                  setState(() {
                                    _controller?.setScrubValue(value);
                                  });
                                },
                                onScrubEnd: () => _controller?.resume(),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ControlsColumn extends StatelessWidget {
  const _ControlsColumn({
    required this.speed,
    required this.scrubValue,
    required this.onSpeedChanged,
    required this.onScrubStart,
    required this.onScrubChanged,
    required this.onScrubEnd,
  });

  final double speed;
  final double scrubValue;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onScrubStart;
  final ValueChanged<double> onScrubChanged;
  final VoidCallback onScrubEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Speed', style: theme.textTheme.labelLarge),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: speed,
            min: 0.35,
            max: 2.4,
            divisions: 41,
            label: '${speed.toStringAsFixed(2)}x',
            onChanged: onSpeedChanged,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${speed.toStringAsFixed(2)}x',
            style: theme.textTheme.labelMedium,
          ),
        ),
        const SizedBox(height: 12),
        Text('Timeline', style: theme.textTheme.labelLarge),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: scrubValue,
            onChangeStart: (_) => onScrubStart(),
            onChanged: onScrubChanged,
            onChangeEnd: (_) => onScrubEnd(),
          ),
        ),
    ]);  }
}
