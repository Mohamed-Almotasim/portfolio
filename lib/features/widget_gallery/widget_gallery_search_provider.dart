import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/widget_gallery/ui_pattern.dart';

final uiPatternsSearchProvider = StateProvider<String>((ref) => '');

/// `null` means "All".
final uiPatternsCategoryProvider = StateProvider<UiPatternCategory?>(
  (ref) => null,
);
