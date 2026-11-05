import 'package:flutter/services.dart';

/// Demo source files bundled as assets (see pubspec.yaml) so developer mode
/// shows the code that actually runs, not a hand-copied approximation.
const showcaseSnippetSources = [
  'lib/features/ui_showcase/demos/dashboard_card_demo.dart',
  'lib/features/ui_showcase/widgets/analytics_dashboard_demo.dart',
  'lib/features/ui_showcase/demos/theme_switcher_demo.dart',
  'lib/features/ui_showcase/demos/pricing_card_demo.dart',
  'lib/features/ui_showcase/demos/smart_search_demo.dart',
  'lib/shared/widgets/faq_accordion.dart',
];

const _start = '// #region snippet';
const _end = '// #endregion';

/// The code between `// #region snippet` and `// #endregion` markers,
/// dedented; several regions are joined with a `// …` line.
String extractSnippet(String source) {
  final regions = <List<String>>[];
  List<String>? current;
  for (final line in source.split('\n')) {
    final trimmed = line.trim();
    if (trimmed == _start) {
      current = [];
    } else if (trimmed == _end && current != null) {
      regions.add(current);
      current = null;
    } else {
      current?.add(line.trimRight());
    }
  }
  if (regions.isEmpty) {
    throw const FormatException('No "// #region snippet" found');
  }
  return regions.map(_dedent).join('\n\n// …\n\n');
}

String _dedent(List<String> lines) {
  final indent = lines
      .where((l) => l.trim().isNotEmpty)
      .map((l) => l.length - l.trimLeft().length)
      .fold<int?>(null, (min, n) => min == null || n < min ? n : min);
  return lines
      .map((l) => l.length >= (indent ?? 0) ? l.substring(indent ?? 0) : '')
      .join('\n')
      .trim();
}

Future<String> loadSnippet(String sourcePath) async =>
    extractSnippet(await rootBundle.loadString(sourcePath));
