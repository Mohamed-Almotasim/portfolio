import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/theme_storage.dart'
    if (dart.library.js_interop) 'package:portfolio/core/state/theme_storage_web.dart';

/// Follows the OS until the visitor picks; the pick is kept in localStorage.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() =>
      ThemeMode.values.asNameMap()[readStoredThemeMode()] ?? ThemeMode.system;

  void set(ThemeMode mode) {
    state = mode;
    writeStoredThemeMode(mode.name);
  }

  /// Flips whatever is currently shown, so it also works from [ThemeMode.system].
  void toggle(Brightness current) =>
      set(current == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
