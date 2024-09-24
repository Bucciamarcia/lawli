import 'package:cloud_functions/cloud_functions.dart';

class Trascrizione {
  String? text;
  String? shortSummary;
  String? longSummary;

  Trascrizione({
    this.text,
    this.shortSummary,
    this.longSummary,
  });

  Future<String> getShortSummary() async {
    var result = await FirebaseFunctions.instance
        .httpsCallable("get_short_transcription_summary")
        .call(
      {
        "text": text,
      },
    );
    String shortSummary = result.data;
    if (shortSummary.isEmpty) {
      throw Exception("Errore durante la generazione del riassunto breve");
    } else {
      return shortSummary;
    }
  }

  Future<String> getLongSummary() async {
    var result = await FirebaseFunctions.instance
        .httpsCallable("get_long_transcription_summary")
        .call(
      {
        "text": text,
      },
    );
    String longSummary = result.data;
    if (longSummary.isEmpty) {
      throw Exception("Errore durante la generazione del riassunto lungo");
    } else {
      return longSummary;
    }
  }
}
