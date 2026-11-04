import 'package:flutter/material.dart';

class GlassTiltVisualState {
  const GlassTiltVisualState({
    this.rotationX = 0,
    this.rotationY = 0,
    this.scale = 1,
    this.parallaxOffset = Offset.zero,
    this.glareAlignment = Alignment.center,
    this.shadowBlur = 18,
    this.shadowOffset = const Offset(0, 10),
    this.shadowOpacity = 0.16,
    this.borderGlowOpacity = 0.08,
  });

  final double rotationX;
  final double rotationY;
  final double scale;
  final Offset parallaxOffset;
  final Alignment glareAlignment;
  final double shadowBlur;
  final Offset shadowOffset;
  final double shadowOpacity;
  final double borderGlowOpacity;

  static GlassTiltVisualState lerp(
    GlassTiltVisualState a,
    GlassTiltVisualState b,
    double t,
  ) {
    return GlassTiltVisualState(
      rotationX: _lerpDouble(a.rotationX, b.rotationX, t),
      rotationY: _lerpDouble(a.rotationY, b.rotationY, t),
      scale: _lerpDouble(a.scale, b.scale, t),
      parallaxOffset: Offset.lerp(a.parallaxOffset, b.parallaxOffset, t)!,
      glareAlignment: Alignment.lerp(a.glareAlignment, b.glareAlignment, t)!,
      shadowBlur: _lerpDouble(a.shadowBlur, b.shadowBlur, t),
      shadowOffset: Offset.lerp(a.shadowOffset, b.shadowOffset, t)!,
      shadowOpacity: _lerpDouble(a.shadowOpacity, b.shadowOpacity, t),
      borderGlowOpacity: _lerpDouble(
        a.borderGlowOpacity,
        b.borderGlowOpacity,
        t,
      ),
    );
  }

  static double _lerpDouble(double a, double b, double t) {
    return a + ((b - a) * t);
  }
}

class GlassTiltCardController extends ChangeNotifier {
  static const double _maxRotation = 0.2;
  static const double _hoverScale = 1.03;

  Offset? _localPointer;
  bool _isHovered = false;
  bool _isPressed = false;

  bool get isHovered => _isHovered;

  void updatePointer(Offset? localPointer) {
    _localPointer = localPointer;
    notifyListeners();
  }

  void setHovered(bool value) {
    _isHovered = value;
    if (!value) {
      _localPointer = null;
    }
    notifyListeners();
  }

  void setPressed(bool value) {
    _isPressed = value;
    notifyListeners();
  }

  GlassTiltVisualState stateFor(Size size) {
    if (!_isHovered || _localPointer == null || size.isEmpty) {
      return GlassTiltVisualState(scale: _isPressed ? 0.99 : 1);
    }

    final normalizedX = ((_localPointer!.dx / size.width) * 2) - 1;
    final normalizedY = ((_localPointer!.dy / size.height) * 2) - 1;
    final clampedX = normalizedX.clamp(-1.0, 1.0);
    final clampedY = normalizedY.clamp(-1.0, 1.0);

    return GlassTiltVisualState(
      rotationX: (-clampedY * _maxRotation).clamp(-_maxRotation, _maxRotation),
      rotationY: (clampedX * _maxRotation).clamp(-_maxRotation, _maxRotation),
      scale: _isPressed ? 1.01 : _hoverScale,
      parallaxOffset: Offset(clampedX * 10, clampedY * 8),
      glareAlignment: Alignment(clampedX, clampedY),
      shadowBlur: 34,
      shadowOffset: const Offset(0, 18),
      shadowOpacity: 0.26,
      borderGlowOpacity: 0.22,
    );
  }
}
