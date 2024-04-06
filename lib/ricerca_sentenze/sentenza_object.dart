class Sentenza {
  final String corte;
  final String contenuto;
  final String titolo;

  Sentenza({required this.corte, required this.contenuto, required this.titolo});

  Sentenza getSentenzaFromMap(Map<String, String> sentenzaMap) {
    return Sentenza(
      corte: sentenzaMap['corte']!,
      contenuto: sentenzaMap['contenuto']!,
      titolo: sentenzaMap['titolo']!,
    );
  }
}