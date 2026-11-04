import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeveloperModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void set(bool enabled) => state = enabled;
}

final developerModeProvider = NotifierProvider<DeveloperModeNotifier, bool>(
  DeveloperModeNotifier.new,
);
