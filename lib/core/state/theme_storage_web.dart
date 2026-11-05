import 'package:web/web.dart' as web;

const _key = 'themeMode';

// localStorage throws when the browser blocks site data; then just don't remember.
String? readStoredThemeMode() {
  try {
    return web.window.localStorage.getItem(_key);
  } catch (_) {
    return null;
  }
}

void writeStoredThemeMode(String value) {
  try {
    web.window.localStorage.setItem(_key, value);
  } catch (_) {}
}
