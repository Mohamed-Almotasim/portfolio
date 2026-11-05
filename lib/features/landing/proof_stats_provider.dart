import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/proof_stat.dart';
import 'package:portfolio/features/app_simulator/demo_count.dart';
import 'package:portfolio/features/work/case_studies_provider.dart';

/// Known content stats plus counts derived from what this site actually shows.
final proofStatsProvider = Provider<List<ProofStat>>((ref) {
  final demos = liveDemoCount;
  return [
    ...content.proofStats.where((s) => s.value != null),
    ProofStat(
      label: 'Case studies',
      value: '${ref.watch(caseStudiesProvider).length}',
    ),
    ProofStat(label: 'Live demos on this site', value: '$demos'),
  ];
});
