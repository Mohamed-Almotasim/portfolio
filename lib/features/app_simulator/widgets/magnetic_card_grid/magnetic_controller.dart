import 'package:flutter/material.dart';

import 'magnetic_model.dart';

const double _magneticRadius = 150;
const double _maxMagneticOffset = 14;
const double _maxHoverOffset = 6;
const double _maxRotationRadians = 0.17;
const double _baseScale = 1;
const double _maxHoverScale = 1.07;

class MagneticCardVisualState {
  const MagneticCardVisualState({
    this.translation = Offset.zero,
    this.scale = 1,
    this.rotationX = 0,
    this.rotationY = 0,
    this.shadowBlur = 18,
    this.shadowOffset = const Offset(0, 10),
    this.shadowOpacity = 0.14,
    this.glowOpacity = 0,
    this.parallaxOffset = Offset.zero,
  });

  final Offset translation;
  final double scale;
  final double rotationX;
  final double rotationY;
  final double shadowBlur;
  final Offset shadowOffset;
  final double shadowOpacity;
  final double glowOpacity;
  final Offset parallaxOffset;

  static MagneticCardVisualState lerp(
    MagneticCardVisualState a,
    MagneticCardVisualState b,
    double t,
  ) {
    return MagneticCardVisualState(
      translation: Offset.lerp(a.translation, b.translation, t)!,
      scale: _lerpDouble(a.scale, b.scale, t),
      rotationX: _lerpDouble(a.rotationX, b.rotationX, t),
      rotationY: _lerpDouble(a.rotationY, b.rotationY, t),
      shadowBlur: _lerpDouble(a.shadowBlur, b.shadowBlur, t),
      shadowOffset: Offset.lerp(a.shadowOffset, b.shadowOffset, t)!,
      shadowOpacity: _lerpDouble(a.shadowOpacity, b.shadowOpacity, t),
      glowOpacity: _lerpDouble(a.glowOpacity, b.glowOpacity, t),
      parallaxOffset: Offset.lerp(a.parallaxOffset, b.parallaxOffset, t)!,
    );
  }

  static double _lerpDouble(double a, double b, double t) {
    return a + ((b - a) * t);
  }
}

class MagneticCardGridController extends ChangeNotifier {
  MagneticCardGridController({required List<MagneticCardData> cards})
    : cards = List<MagneticCardData>.unmodifiable(cards);

  final List<MagneticCardData> cards;

  final Map<int, Rect> _cardRects = <int, Rect>{};
  final Map<int, Offset> _localPointers = <int, Offset>{};
  Offset? _cursorPosition;
  int? _hoveredIndex;
  int? _pressedIndex;

  void updateCursor(Offset? cursorPosition) {
    _cursorPosition = cursorPosition;
    notifyListeners();
  }

  void registerCardRect(int index, Rect rect) {
    final previous = _cardRects[index];
    if (previous == rect) {
      return;
    }

    _cardRects[index] = rect;
  }

  void setHovered(int index, bool isHovered) {
    if (isHovered) {
      _hoveredIndex = index;
    } else if (_hoveredIndex == index) {
      _hoveredIndex = null;
      _localPointers.remove(index);
    }

    notifyListeners();
  }

  void updateLocalPointer(int index, Offset localPointer) {
    _localPointers[index] = localPointer;
    notifyListeners();
  }

  void setPressed(int index, bool isPressed) {
    _pressedIndex = isPressed
        ? index
        : (_pressedIndex == index ? null : _pressedIndex);
    notifyListeners();
  }

  MagneticCardVisualState stateFor(int index) {
    final rect = _cardRects[index];
    if (rect == null) {
      return const MagneticCardVisualState();
    }

    final cursor = _cursorPosition;
    final localPointer = _localPointers[index];
    final center = rect.center;
    final size = rect.size;

    if (cursor == null) {
      return _pressedIndex == index
          ? const MagneticCardVisualState(scale: 0.98)
          : const MagneticCardVisualState();
    }

    final delta = cursor - center;
    final distance = delta.distance;
    final magneticStrength = distance < _magneticRadius
        ? (1 - (distance / _magneticRadius)).clamp(0.0, 1.0)
        : 0.0;

    Offset translation = Offset.zero;
    if (distance > 0.001 && magneticStrength > 0) {
      translation = Offset(
        (delta.dx / distance) * magneticStrength * _maxMagneticOffset,
        (delta.dy / distance) * magneticStrength * _maxMagneticOffset,
      );
    }

    var scale = _baseScale + (magneticStrength * 0.02);
    var rotationX = 0.0;
    var rotationY = 0.0;
    var parallaxOffset = Offset.zero;
    var shadowBlur = 18 + (magneticStrength * 8);
    var shadowOffset = Offset(0, 10 + (magneticStrength * 5));
    var shadowOpacity = 0.14 + (magneticStrength * 0.06);
    var glowOpacity = magneticStrength * 0.14;

    if (_hoveredIndex == index && localPointer != null) {
      final normalizedX = ((localPointer.dx / size.width) * 2) - 1;
      final normalizedY = ((localPointer.dy / size.height) * 2) - 1;

      scale = _maxHoverScale;
      rotationX = (-normalizedY * _maxRotationRadians).clamp(
        -_maxRotationRadians,
        _maxRotationRadians,
      );
      rotationY = (normalizedX * _maxRotationRadians).clamp(
        -_maxRotationRadians,
        _maxRotationRadians,
      );
      translation += Offset(
        normalizedX * _maxHoverOffset,
        normalizedY * _maxHoverOffset,
      );
      parallaxOffset = Offset(normalizedX * 8, normalizedY * 6);
      shadowBlur = 30;
      shadowOffset = const Offset(0, 16);
      shadowOpacity = 0.24;
      glowOpacity = 0.28;
    }

    if (_pressedIndex == index) {
      scale -= 0.03;
      translation += const Offset(0, 4);
    }

    return MagneticCardVisualState(
      translation: translation,
      scale: scale,
      rotationX: rotationX,
      rotationY: rotationY,
      shadowBlur: shadowBlur,
      shadowOffset: shadowOffset,
      shadowOpacity: shadowOpacity,
      glowOpacity: glowOpacity,
      parallaxOffset: parallaxOffset,
    );
  }
}
