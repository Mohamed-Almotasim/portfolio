import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/core/theme/theme_tokens.dart';

/// Token overrides set from the inspector panel. Not persisted, and reset
/// whenever Inspector mode is switched on or off.
class ThemeTokensNotifier extends Notifier<ThemeTokens> {
  @override
  ThemeTokens build() {
    ref.watch(developerModeProvider);
    return const ThemeTokens();
  }

  void set(ThemeTokens tokens) => state = tokens;

  void reset() => state = const ThemeTokens();
}

final themeTokensProvider = NotifierProvider<ThemeTokensNotifier, ThemeTokens>(
  ThemeTokensNotifier.new,
);
