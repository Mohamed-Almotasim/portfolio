import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Footage files that really exist under `assets/projects/`, read from the
/// asset manifest. main.dart warms it before the first frame. Any failure
/// reads as "no footage", so a missing file never reaches a widget.
final projectAssetsProvider = FutureProvider<Set<String>>((ref) async {
  try {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    return {
      for (final a in manifest.listAssets())
        if (a.startsWith('assets/projects/')) a,
    };
  } catch (_) {
    return const {};
  }
});
