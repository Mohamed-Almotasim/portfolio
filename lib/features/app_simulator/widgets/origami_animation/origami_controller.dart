import 'package:flutter/material.dart';

import 'package:portfolio/features/app_simulator/widgets/origami_animation/origami_model.dart';

class OrigamiAnimationController extends ChangeNotifier {
  OrigamiAnimationController({
    required TickerProvider vsync,
    List<OrigamiStep>? steps,
    Duration stepDuration = const Duration(milliseconds: 600),
    this.stepDelay = const Duration(milliseconds: 140),
    Curve curve = Curves.easeInOut,
    double speed = 1,
  }) : _steps = List<OrigamiStep>.unmodifiable(
         steps == null || steps.isEmpty ? OrigamiStep.defaultSequence : steps,
       ),
       _baseStepDuration = stepDuration,
       _animationController = AnimationController(
         vsync: vsync,
         duration: stepDuration,
       ) {
    _progress = CurvedAnimation(parent: _animationController, curve: curve);
    _animationController.addListener(notifyListeners);
    _animationController.addStatusListener(_handleStatusChange);
    setSpeed(speed, notify: false);
    _configureSegment(0);
    _animationController.forward();
  }

  final List<OrigamiStep> _steps;
  final Duration stepDelay;
  final Duration _baseStepDuration;
  final AnimationController _animationController;
  late final Animation<double> _progress;

  int _fromIndex = 0;
  int _toIndex = 1;
  int _direction = 1;
  int _delayToken = 0;
  bool _isDisposed = false;
  bool _isPaused = false;
  bool _isWaitingForDelay = false;
  double _speed = 1;

  Listenable get listenable => this;

  bool get isPaused => _isPaused;

  bool get isReversed => _direction == -1;

  double get speed => _speed;

  double get scrubValue => _canonicalPosition / _steps.length;

  OrigamiStep get currentStep {
    return _steps[_fromIndex].lerpTo(_steps[_toIndex], _progress.value);
  }

  void pause() {
    if (_isPaused) {
      return;
    }

    _isPaused = true;
    _delayToken += 1;
    _animationController.stop();
    notifyListeners();
  }

  void resume() {
    if (!_isPaused) {
      return;
    }

    _isPaused = false;

    if (_isWaitingForDelay ||
        _animationController.status == AnimationStatus.completed) {
      _isWaitingForDelay = false;
      _advanceToNextSegment();
    } else {
      _animationController.forward();
    }

    notifyListeners();
  }

  void toggleDirection() {
    final shouldContinue = !_isPaused;
    final canonicalPosition = _canonicalPosition;

    _direction *= -1;
    _syncToCanonical(canonicalPosition);

    if (shouldContinue) {
      _animationController.stop();
      _animationController.forward(from: _animationController.value);
    }

    notifyListeners();
  }

  void scrubBy(double delta) {
    final currentPosition = _canonicalPosition;
    final nextPosition = _wrapCanonical(currentPosition + delta);
    pause();
    _syncToCanonical(nextPosition);
    notifyListeners();
  }

  void setScrubValue(double value) {
    final canonicalPosition = _wrapCanonical(
      value.clamp(0.0, 0.999999) * _steps.length,
    );
    pause();
    _syncToCanonical(canonicalPosition);
    notifyListeners();
  }

  void setSpeed(double value, {bool notify = true}) {
    _speed = value.clamp(0.35, 2.4);
    final nextDuration = Duration(
      microseconds: (_baseStepDuration.inMicroseconds / _speed).round(),
    );
    _animationController.duration = nextDuration;

    if (!_isPaused) {
      _animationController.stop();
      _animationController.forward(from: _animationController.value);
    }

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> _handleStatusChange(AnimationStatus status) async {
    if (status != AnimationStatus.completed || _isDisposed) {
      return;
    }

    final delayToken = ++_delayToken;
    _isWaitingForDelay = true;
    notifyListeners();
    await Future<void>.delayed(stepDelay);

    if (_isDisposed || _isPaused || delayToken != _delayToken) {
      return;
    }

    _isWaitingForDelay = false;
    _advanceToNextSegment();
    notifyListeners();
  }

  void _advanceToNextSegment() {
    _fromIndex = _toIndex;
    _toIndex = _wrapIndex(_fromIndex + _direction);
    _animationController.forward(from: 0);
  }

  void _configureSegment(int fromIndex) {
    _fromIndex = _wrapIndex(fromIndex);
    _toIndex = _wrapIndex(_fromIndex + _direction);
  }

  void _syncToCanonical(double canonicalPosition) {
    final progress = canonicalPosition - canonicalPosition.floorToDouble();
    if (_direction == 1) {
      _fromIndex = canonicalPosition.floor() % _steps.length;
      _toIndex = _wrapIndex(_fromIndex + 1);
      _animationController.value = progress;
      return;
    }

    final adjustedFrom = progress == 0
        ? canonicalPosition.floor()
        : canonicalPosition.ceil();
    _fromIndex = _wrapIndex(adjustedFrom);
    _toIndex = _wrapIndex(_fromIndex - 1);
    _animationController.value = progress == 0
        ? 0
        : adjustedFrom - canonicalPosition;
  }

  double get _canonicalPosition {
    final progress = _progress.value;
    final rawPosition = _direction == 1
        ? _fromIndex + progress
        : _fromIndex - progress;
    return _wrapCanonical(rawPosition);
  }

  int _wrapIndex(int index) {
    final count = _steps.length;
    return ((index % count) + count) % count;
  }

  double _wrapCanonical(double value) {
    final count = _steps.length.toDouble();
    final wrapped = value % count;
    return wrapped < 0 ? wrapped + count : wrapped;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.removeListener(notifyListeners);
    _animationController.removeStatusListener(_handleStatusChange);
    _animationController.dispose();
    super.dispose();
  }
}
