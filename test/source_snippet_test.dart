import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/shared/demo/source_snippet.dart';

void main() {
  group('extractSnippet', () {
    test('returns the lines between the region markers, dedented', () {
      const source = '''
class A {
  // #region snippet
  Widget build() {
    return Text('hi');
  }
  // #endregion
}
''';
      expect(
        extractSnippet(source),
        "Widget build() {\n  return Text('hi');\n}",
      );
    });

    test('joins several regions with an ellipsis comment', () {
      const source = '''
// #region snippet
a();
// #endregion
skipped();
// #region snippet
b();
// #endregion
''';
      expect(extractSnippet(source), 'a();\n\n// …\n\nb();');
    });

    test('throws when the source has no region', () {
      expect(() => extractSnippet('void main() {}'), throwsFormatException);
    });
  });

  test('every showcase demo marks a real snippet region in its source', () {
    for (final path in showcaseSnippetSources) {
      final source = File(path).readAsStringSync();
      expect(extractSnippet(source), isNotEmpty, reason: path);
    }
  });
}
