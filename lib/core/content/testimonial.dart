/// A client review, quoted as written. Shortened quotes mark the cuts
/// with "…"; nothing is reworded.
class Testimonial {
  const Testimonial({
    required this.quote,
    required this.author,
    required this.country,
    this.source = 'Fiverr',
  });

  final String quote;

  /// The reviewer's username on [source].
  final String author;
  final String country;
  final String source;
}
