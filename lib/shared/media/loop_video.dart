import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

/// The little of a video player the project phone needs. Behind an
/// interface because video_player doesn't run in widget tests; tests
/// override [loopVideoFactoryProvider] with a fake.
abstract interface class LoopVideo implements Listenable {
  Future<void> initialize();
  bool get isReady;
  bool get isPlaying;

  /// Reached the end (not looping).
  bool get isCompleted;
  Duration get position;
  Duration get duration;
  Future<void> play();
  Future<void> pause();
  Future<void> seekTo(Duration position);

  /// The video frame, filling its box.
  Widget view();
  Future<void> dispose();
}

typedef LoopVideoFactory = LoopVideo Function(String asset);

final loopVideoFactoryProvider = Provider<LoopVideoFactory>(
  (ref) => _PlayerVideo.new,
);

/// Muted, inline, no controls: what browsers allow to autoplay.
class _PlayerVideo implements LoopVideo {
  _PlayerVideo(String asset)
    : _c = VideoPlayerController.asset(
        asset,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

  final VideoPlayerController _c;

  @override
  Future<void> initialize() async {
    await _c.initialize();
    await _c.setVolume(0); // also sets `muted` on web
  }

  @override
  bool get isReady => _c.value.isInitialized && !_c.value.hasError;
  @override
  bool get isPlaying => _c.value.isPlaying;
  @override
  bool get isCompleted => _c.value.isCompleted;
  @override
  Duration get position => _c.value.position;
  @override
  Duration get duration => _c.value.duration;
  @override
  Future<void> play() => _c.play();
  @override
  Future<void> pause() => _c.pause();
  @override
  Future<void> seekTo(Duration position) => _c.seekTo(position);
  @override
  void addListener(VoidCallback l) => _c.addListener(l);
  @override
  void removeListener(VoidCallback l) => _c.removeListener(l);
  @override
  Future<void> dispose() => _c.dispose();

  @override
  Widget view() => FittedBox(
    fit: BoxFit.cover,
    clipBehavior: Clip.hardEdge,
    child: SizedBox(
      width: _c.value.size.width,
      height: _c.value.size.height,
      child: VideoPlayer(_c),
    ),
  );
}
