import 'package:flutter/material.dart';

class TrascrizioneAudioVideoProvider extends ChangeNotifier {
  String? trascrizione;

  void setTrascrizione(String t) {
    trascrizione = t;
    debugPrint("Changed trascrizione to: $t");
    notifyListeners();
  }
}
