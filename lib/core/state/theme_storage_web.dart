import 'package:web/web.dart' as web;

// localStorage throws when the browser blocks site data; then just don't remember.
String? _read(String key) {
  try {
    return web.window.localStorage.getItem(key);
  } catch (_) {
    return null;
  }
}

void _write(String key, String value) {
  try {
    web.window.localStorage.setItem(key, value);
  } catch (_) {}
}

String? readStoredThemeMode() => _read('themeMode');

void writeStoredThemeMode(String value) => _write('themeMode', value);

String? readStoredLocale() => _read('locale');

void writeStoredLocale(String value) => _write('locale', value);
