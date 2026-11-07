import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/shared/demo/source_snippet.dart';

void main() {
  test('extractLines returns the lines from the given line, dedented', () {
    const source = 'class A {\n  void a() {\n    b();\n  }\n}\n';
    expect(extractLines(source, 2, count: 3), 'void a() {\n  b();\n}');
  });
}
