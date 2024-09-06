import 'package:flutter/material.dart';
import 'models.dart';

class TrascrizioneAudioVideoProvider extends ChangeNotifier {
  Trascrizione trascrizione = Trascrizione();

  void setTrascrizione(String t) {
    trascrizione.text = t;
    debugPrint("Changed trascrizione.text to: $t");
    notifyListeners();
  }
  void setShortSummary(String s) {
    trascrizione.shortSummary = s;
    debugPrint("Changed trascrizione.shortSummary to: $s");
    notifyListeners();
  }
  void setLongSummary(String l) {
    trascrizione.longSummary = l;
    debugPrint("Changed trascrizione.longSummary to: $l");
    notifyListeners();
  }
}
