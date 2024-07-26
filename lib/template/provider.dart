import 'package:flutter/material.dart';
import 'package:lawli/services/models.dart';

class TemplateProvider extends ChangeNotifier {

  Pratica? selectedPratica;

  void setPratica(Pratica pratica) {
    selectedPratica = pratica;
    debugPrint("Pratica selezionata: ${selectedPratica!.titolo}");
    notifyListeners();
  }

}