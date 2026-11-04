/// A headline number for the landing page proof strip.
/// [value] is null until it's known; the UI hides stats without a value.
class ProofStat {
  const ProofStat({required this.label, this.value});

  final String label;
  final String? value;
}
