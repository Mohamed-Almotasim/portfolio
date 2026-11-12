import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/theme_storage.dart'
    if (dart.library.js_interop) 'package:portfolio/core/state/theme_storage_web.dart';

/// English until the visitor picks Arabic; the pick is kept in localStorage.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() =>
      readStoredLocale() == 'ar' ? const Locale('ar') : const Locale('en');

  void set(Locale locale) {
    state = locale;
    writeStoredLocale(locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// Content providers pick the Arabic copy on this.
final isArabicProvider = Provider<bool>(
  (ref) => ref.watch(localeProvider).languageCode == 'ar',
);
