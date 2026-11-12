import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/portfolio_content_ar.dart' as ar;
import 'package:portfolio/core/content/proof_stat.dart';
import 'package:portfolio/core/state/locale_provider.dart';

/// Only stats with a real value; nothing is counted from the site itself.
final proofStatsProvider = Provider<List<ProofStat>>(
  (ref) => (ref.watch(isArabicProvider) ? ar.proofStats : content.proofStats)
      .where((s) => s.value != null)
      .toList(),
);
