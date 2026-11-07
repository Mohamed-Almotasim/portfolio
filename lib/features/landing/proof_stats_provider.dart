import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/proof_stat.dart';

/// Only stats with a real value; nothing is counted from the site itself.
final proofStatsProvider = Provider<List<ProofStat>>(
  (ref) => content.proofStats.where((s) => s.value != null).toList(),
);
