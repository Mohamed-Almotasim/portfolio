import 'dart:ui';

enum OrigamiQuadrant { topLeft, topRight, bottomLeft, bottomRight }

class OrigamiPanelScale {
  const OrigamiPanelScale({required this.scaleX, required this.scaleY});

  final double scaleX;
  final double scaleY;
}

class OrigamiStep {
  const OrigamiStep({
    required this.topLeftScaleX,
    required this.topLeftScaleY,
    required this.topRightScaleX,
    required this.topRightScaleY,
    required this.bottomLeftScaleX,
    required this.bottomLeftScaleY,
    required this.bottomRightScaleX,
    required this.bottomRightScaleY,
  });

  factory OrigamiStep.fromJson(Map<String, dynamic> json) {
    return OrigamiStep(
      topLeftScaleX: _readDouble(json, 'topLeftScaleX'),
      topLeftScaleY: _readDouble(json, 'topLeftScaleY'),
      topRightScaleX: _readDouble(json, 'topRightScaleX'),
      topRightScaleY: _readDouble(json, 'topRightScaleY'),
      bottomLeftScaleX: _readDouble(json, 'bottomLeftScaleX'),
      bottomLeftScaleY: _readDouble(json, 'bottomLeftScaleY'),
      bottomRightScaleX: _readDouble(json, 'bottomRightScaleX'),
      bottomRightScaleY: _readDouble(json, 'bottomRightScaleY'),
    );
  }

  final double topLeftScaleX;
  final double topLeftScaleY;
  final double topRightScaleX;
  final double topRightScaleY;
  final double bottomLeftScaleX;
  final double bottomLeftScaleY;
  final double bottomRightScaleX;
  final double bottomRightScaleY;

  static const List<OrigamiStep> defaultSequence = [
    OrigamiStep(
      topLeftScaleX: 1,
      topLeftScaleY: 1,
      topRightScaleX: 1,
      topRightScaleY: 1,
      bottomLeftScaleX: 1,
      bottomLeftScaleY: 1,
      bottomRightScaleX: 1,
      bottomRightScaleY: 1,
    ),
    OrigamiStep(
      topLeftScaleX: 0.76,
      topLeftScaleY: 0.58,
      topRightScaleX: 0.58,
      topRightScaleY: 0.76,
      bottomLeftScaleX: 0.58,
      bottomLeftScaleY: 0.76,
      bottomRightScaleX: 0.76,
      bottomRightScaleY: 0.58,
    ),
    OrigamiStep(
      topLeftScaleX: 0.52,
      topLeftScaleY: 0.88,
      topRightScaleX: 0.88,
      topRightScaleY: 0.52,
      bottomLeftScaleX: 0.88,
      bottomLeftScaleY: 0.52,
      bottomRightScaleX: 0.52,
      bottomRightScaleY: 0.88,
    ),
    OrigamiStep(
      topLeftScaleX: 0.84,
      topLeftScaleY: 0.48,
      topRightScaleX: 0.48,
      topRightScaleY: 0.84,
      bottomLeftScaleX: 0.48,
      bottomLeftScaleY: 0.84,
      bottomRightScaleX: 0.84,
      bottomRightScaleY: 0.48,
    ),
    OrigamiStep(
      topLeftScaleX: 0.68,
      topLeftScaleY: 0.76,
      topRightScaleX: 0.76,
      topRightScaleY: 0.68,
      bottomLeftScaleX: 0.76,
      bottomLeftScaleY: 0.68,
      bottomRightScaleX: 0.68,
      bottomRightScaleY: 0.76,
    ),
    OrigamiStep(
      topLeftScaleX: 1,
      topLeftScaleY: 1,
      topRightScaleX: 1,
      topRightScaleY: 1,
      bottomLeftScaleX: 1,
      bottomLeftScaleY: 1,
      bottomRightScaleX: 1,
      bottomRightScaleY: 1,
    ),
  ];

  OrigamiPanelScale scaleFor(OrigamiQuadrant quadrant) {
    switch (quadrant) {
      case OrigamiQuadrant.topLeft:
        return OrigamiPanelScale(scaleX: topLeftScaleX, scaleY: topLeftScaleY);
      case OrigamiQuadrant.topRight:
        return OrigamiPanelScale(
          scaleX: topRightScaleX,
          scaleY: topRightScaleY,
        );
      case OrigamiQuadrant.bottomLeft:
        return OrigamiPanelScale(
          scaleX: bottomLeftScaleX,
          scaleY: bottomLeftScaleY,
        );
      case OrigamiQuadrant.bottomRight:
        return OrigamiPanelScale(
          scaleX: bottomRightScaleX,
          scaleY: bottomRightScaleY,
        );
    }
  }

  OrigamiStep lerpTo(OrigamiStep other, double t) {
    return OrigamiStep(
      topLeftScaleX: lerpDouble(topLeftScaleX, other.topLeftScaleX, t)!,
      topLeftScaleY: lerpDouble(topLeftScaleY, other.topLeftScaleY, t)!,
      topRightScaleX: lerpDouble(topRightScaleX, other.topRightScaleX, t)!,
      topRightScaleY: lerpDouble(topRightScaleY, other.topRightScaleY, t)!,
      bottomLeftScaleX: lerpDouble(
        bottomLeftScaleX,
        other.bottomLeftScaleX,
        t,
      )!,
      bottomLeftScaleY: lerpDouble(
        bottomLeftScaleY,
        other.bottomLeftScaleY,
        t,
      )!,
      bottomRightScaleX: lerpDouble(
        bottomRightScaleX,
        other.bottomRightScaleX,
        t,
      )!,
      bottomRightScaleY: lerpDouble(
        bottomRightScaleY,
        other.bottomRightScaleY,
        t,
      )!,
    );
  }

  static double _readDouble(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.parse(value);
    }
    throw FormatException('OrigamiStep is missing a valid "$key" value.');
  }
}
