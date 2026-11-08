import 'package:flutter/services.dart';

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

/// Files the inspector annotates with `source:`; bundled (pubspec.yaml) so
/// its Layout tab can show the real code at that line.
const inspectorSourceFiles = [
  'lib/features/landing/widgets/hero_section.dart',
  'lib/features/landing/widgets/project_bench.dart',
  'lib/features/work/widgets/project_phone.dart',
  'lib/features/landing/widgets/live_specimen.dart',
  'lib/features/landing/landing_page.dart',
  'lib/features/work/work_page.dart',
  'lib/shared/widgets/app_navbar.dart',
  'lib/features/playground/playground_page.dart',
  'lib/features/playground/specimen_page.dart',
  'lib/features/playground/specimens/one_codebase.dart',
  'lib/features/playground/specimens/role_based_ui.dart',
  'lib/features/playground/specimens/data_at_scale.dart',
  'lib/features/playground/specimens/offline_sync.dart',
  'lib/features/playground/specimens/rtl_localization.dart',
  'lib/features/playground/specimens/motion_lab.dart',
];

/// [count] lines of [source] starting at 1-based [line], dedented.
String extractLines(String source, int line, {int count = 14}) =>
    _dedent(source.split('\n').skip(line - 1).take(count).toList());

Future<String> loadLines(String sourcePath, int line) async =>
    extractLines(await rootBundle.loadString(sourcePath), line);
