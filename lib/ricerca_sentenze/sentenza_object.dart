/// Represents a legal judgment.
class Sentenza {
  /// The court where the judgment was made.
  final String corte;

  /// The content of the judgment.
  final String contenuto;

  /// The title of the judgment.
  final String titolo;

  /// The distance of the vector: normalized 0-1, lower is closer.
  final double distance;

  /// Creates a new instance of the [Sentenza] class.
  Sentenza({
    required this.corte,
    required this.contenuto,
    required this.titolo,
    required this.distance,
  });
}