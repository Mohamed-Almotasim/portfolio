import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/code_syntax.dart';
import 'package:portfolio/shared/widgets/dart_highlighter.dart';

void main() {
  const syntax = CodeSyntax.standard;

  Color? colorOf(String code, String token) => highlightDart(code, syntax)
      .firstWhere((s) => s.text == token, orElse: () => const TextSpan())
      .style
      ?.color;

  test('keywords', () {
    expect(colorOf('final x = 1;', 'final'), syntax.keyword);
    expect(colorOf('return null;', 'return'), syntax.keyword);
  });

  test('strings, including quotes inside the other quote style', () {
    expect(colorOf("Text('it\"s')", "'it\"s'"), syntax.string);
  });

  test('line comments run to the end of the line', () {
    expect(colorOf('a(); // done\nb();', '// done'), syntax.comment);
  });

  test('capitalised identifiers are types; numbers are numbers', () {
    expect(colorOf('Padding(padding: 16)', 'Padding'), syntax.type);
    expect(colorOf('width: 16.5', '16.5'), syntax.number);
  });

  test('round-trips the code exactly', () {
    const code = "class A {\n  // hi\n  final s = 'x';\n}";
    expect(highlightDart(code, syntax).map((s) => s.text).join(), code);
  });
}
