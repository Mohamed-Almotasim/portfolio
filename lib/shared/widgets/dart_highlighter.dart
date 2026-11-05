import 'package:flutter/painting.dart';
import 'package:portfolio/core/theme/code_syntax.dart';

const _keywords = {
  'abstract', 'as', 'async', 'await', 'break', 'case', 'class', 'const', //
  'continue', 'default', 'else', 'enum', 'extends', 'false', 'final', 'for',
  'if', 'import', 'in', 'is', 'late', 'mixin', 'new', 'null', 'override',
  'required', 'return', 'static', 'super', 'switch', 'this', 'true', 'var',
  'void', 'while', 'with', 'yield',
};

// Order matters: comments and strings win over anything inside them.
final _token = RegExp(
  r'(//[^\n]*)' // 1 comment
  r"|('(?:[^'\\\n]|\\.)*'|"
  '"'
  r'(?:[^"\\\n]|\\.)*")' // 2 string
  r'|(\b\d+(?:\.\d+)?\b)' // 3 number
  r'|(\b[A-Za-z_]\w*\b)', // 4 identifier
);

/// Small regex highlighter, good enough for trimmed Dart excerpts:
/// keywords, types (Capitalised), strings, numbers and line comments.
List<TextSpan> highlightDart(String code, CodeSyntax c) {
  final spans = <TextSpan>[];
  var last = 0;
  void add(String text, Color color) => spans.add(
    TextSpan(
      text: text,
      style: TextStyle(color: color),
    ),
  );

  for (final m in _token.allMatches(code)) {
    if (m.start > last) add(code.substring(last, m.start), c.plain);
    final text = m[0]!;
    final color = m[1] != null
        ? c.comment
        : m[2] != null
        ? c.string
        : m[3] != null
        ? c.number
        : _keywords.contains(text)
        ? c.keyword
        : text.startsWith(RegExp('_?[A-Z]'))
        ? c.type
        : c.plain;
    add(text, color);
    last = m.end;
  }
  if (last < code.length) add(code.substring(last), c.plain);
  return spans;
}
