import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/widget_gallery/ui_pattern.dart';

class UiPatternsSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final uiPatternsSearchProvider =
    NotifierProvider<UiPatternsSearchNotifier, String>(
      UiPatternsSearchNotifier.new,
    );

/// `null` means "All".
class UiPatternsCategoryNotifier extends Notifier<UiPatternCategory?> {
  @override
  UiPatternCategory? build() => null;

  void setCategory(UiPatternCategory? category) => state = category;
}

final uiPatternsCategoryProvider =
    NotifierProvider<UiPatternsCategoryNotifier, UiPatternCategory?>(
      UiPatternsCategoryNotifier.new,
    );
