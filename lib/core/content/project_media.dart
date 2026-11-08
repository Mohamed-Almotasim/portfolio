/// A moment in a project's video, shown as an Inspector tag in Inspect mode.
class InspectNote {
  const InspectNote(this.seconds, this.label);

  final double seconds;
  final String label;
}

/// Footage for a project in `assets/projects/`, named by [prefix]
/// (docs/MEDIA.md). Paths are where the files go; which of them really
/// exist is read from the asset manifest (`projectAssetsProvider`).
class ProjectMedia {
  const ProjectMedia({
    required this.prefix,
    required this.captions,
    this.notes = const [],
  });

  final String prefix;

  /// One per screenshot, in order.
  final List<String> captions;
  final List<InspectNote> notes;

  String get video => 'assets/projects/$prefix-video.mp4';

  List<String> get screenshots => [
    for (var i = 1; i <= 4; i++) 'assets/projects/$prefix-$i.png',
  ];

  /// Optional Lottie splash. shortcut: not played yet (no lottie package);
  /// add `lottie` and play it before the video once a splash file exists.
  String get splash => 'assets/projects/$prefix-splash.json';
}
