import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/content/project_media.dart';
import 'package:portfolio/core/state/project_assets_provider.dart';
import 'package:portfolio/features/landing/widgets/project_bench.dart';
import 'package:portfolio/features/work/widgets/project_phone.dart';
import 'package:portfolio/shared/media/loop_video.dart';

import 'helpers/pump_app.dart';

/// video_player doesn't run in tests; this stands in for it.
class FakeVideo extends ChangeNotifier implements LoopVideo {
  FakeVideo(this.asset, {this.fail = false});

  final String asset;
  final bool fail;
  bool ready = false, playing = false, completed = false, disposed = false;
  Duration pos = Duration.zero;

  @override
  Future<void> initialize() async {
    if (fail) throw Exception('cannot decode $asset');
    ready = true;
    notifyListeners();
  }

  @override
  bool get isReady => ready;
  @override
  bool get isPlaying => playing;
  @override
  bool get isCompleted => completed;
  @override
  Duration get position => pos;
  @override
  Duration get duration => const Duration(seconds: 10);
  @override
  Future<void> play() async => playing = true;
  @override
  Future<void> pause() async => playing = false;
  @override
  Future<void> seekTo(Duration p) async {
    pos = p;
    completed = false;
  }

  @override
  Widget view() => const SizedBox.expand(key: Key('fake-video'));

  @override
  Future<void> dispose() async {
    disposed = true;
    super.dispose();
  }

  void finish() {
    pos = duration;
    playing = false;
    completed = true;
    notifyListeners();
  }
}

const _dukkanShots = {
  'assets/projects/Dukkan-1.png',
  'assets/projects/Dukkan-2.png',
  'assets/projects/Dukkan-3.png',
  'assets/projects/Dukkan-4.png',
};
const _dukkanVideo = 'assets/projects/Dukkan-video.mp4';

const _size = Size(1440, 2600); // tall, so the bench is on screen
String _title(String name) => 'Pixel 8 · 412×915 · $name';
Finder inBench(Finder f) =>
    find.descendant(of: find.byType(ProjectBench), matching: f);

void main() {
  setUpAll(loadAppFonts);

  late List<FakeVideo> videos;
  setUp(() => videos = []);

  List<Override> media(Set<String> assets, {bool fail = false}) => [
    projectAssetsProvider.overrideWith((ref) async => assets),
    loopVideoFactoryProvider.overrideWithValue((asset) {
      final v = FakeVideo(asset, fail: fail);
      videos.add(v);
      return v;
    }),
  ];

  Future<void> pumpBench(
    WidgetTester tester,
    Set<String> assets, {
    bool fail = false,
  }) => pumpApp(
    tester,
    size: _size,
    overrides: media(assets, fail: fail),
  );

  FakeVideo live(String asset) =>
      videos.lastWhere((v) => v.asset == asset && !v.disposed);

  test('only screenshots that exist are shown, captioned by file number', () {
    const media = ProjectMedia(prefix: 'Dukkan', captions: ['a', 'b', 'c']);
    final f = Footage(media, {
      'assets/projects/Dukkan-1.png',
      'assets/projects/Dukkan-3.png',
    });
    expect(f.shots, hasLength(2));
    expect([f.caption(0), f.caption(1)], ['a', 'c']);
  });

  testWidgets('no media: an "awaiting footage" screen, no players', (
    tester,
  ) async {
    await pumpBench(tester, {});
    expect(find.text(_title('Dukkan')), findsOneWidget);
    expect(find.text('Awaiting footage'), findsOneWidget);
    expect(videos, isEmpty);
  });

  testWidgets('screenshots only: cycles them, no players', (tester) async {
    await pumpBench(tester, _dukkanShots);
    expect(find.text('Awaiting footage'), findsNothing);
    expect(inBench(find.textContaining('Fig. 1 · ')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2600));
    expect(inBench(find.textContaining('Fig. 2 · ')), findsOneWidget);
    expect(videos, isEmpty);
  });

  testWidgets('full media: the video plays, the next one is preloaded', (
    tester,
  ) async {
    await pumpBench(tester, {..._dukkanShots, _dukkanVideo});
    final v = live(_dukkanVideo);
    expect(v.ready, isTrue);
    expect(v.playing, isTrue);
    expect(find.byKey(const Key('fake-video')), findsOneWidget);
  });

  testWidgets('selecting a project switches title and row without moving '
      'the layout', (tester) async {
    await pumpBench(tester, {..._dukkanShots, _dukkanVideo});
    final phone = tester.getRect(find.byType(ProjectPhone));
    final row = tester.getRect(inBench(find.text('Recall')).first);

    await tester.tap(inBench(find.text('Recall')));
    await settle(tester);
    expect(find.text(_title('Recall')), findsOneWidget);
    expect(find.text(_title('Dukkan')), findsNothing);
    expect(tester.getRect(find.byType(ProjectPhone)), phone);
    expect(tester.getRect(inBench(find.text('Recall')).first), row);
    // The outgoing player is freed after the cross-fade.
    expect(videos.single.disposed, isTrue);
  });

  testWidgets('a finished video advances; interaction holds it for 5s', (
    tester,
  ) async {
    await pumpBench(tester, {..._dukkanShots, _dukkanVideo});
    live(_dukkanVideo).finish();
    await settle(tester);
    expect(find.text(_title('Recall')), findsOneWidget);

    // Back to Dukkan by hand: that interaction holds auto-advance.
    await tester.tap(inBench(find.text('Dukkan')));
    await settle(tester);
    live(_dukkanVideo).finish();
    await settle(tester);
    expect(find.text(_title('Dukkan')), findsOneWidget);
    expect(live(_dukkanVideo).playing, isTrue, reason: 'loops instead');

    await tester.pump(const Duration(seconds: 6));
    live(_dukkanVideo).finish();
    await settle(tester);
    expect(find.text(_title('Recall')), findsOneWidget);
  });

  testWidgets('reduced motion: no autoplay, no auto-advance', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpBench(tester, {..._dukkanShots, _dukkanVideo});
    final v = live(_dukkanVideo);
    expect(v.playing, isFalse);
    expect(find.bySemanticsLabel('Play'), findsWidgets);

    v.finish();
    await settle(tester);
    expect(find.text(_title('Dukkan')), findsOneWidget);
  });

  testWidgets('listed but missing or broken files never throw', (tester) async {
    final errors = await collectFlutterErrors(
      () => pumpBench(tester, {..._dukkanShots, _dukkanVideo}, fail: true),
    );
    await settle(tester);
    expect(errors, isEmpty);
    expect(tester.takeException(), isNull);
    // The broken video falls back to the screenshots.
    expect(find.byKey(const Key('fake-video')), findsNothing);
    expect(find.text('Awaiting footage'), findsNothing);
  });
}
