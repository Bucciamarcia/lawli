import 'package:flutter/material.dart';
import 'package:lawli/services/models.dart';

class TemplateProvider extends ChangeNotifier {

  Pratica? selectedPratica;
  bool isSearchBoxEmpty = true;
  bool isSearching = false;
  bool resultsExist = false;

  void setPratica(Pratica pratica) {
    selectedPratica = pratica;
    debugPrint("Pratica selezionata: ${selectedPratica!.titolo}");
    notifyListeners();
  }

  void setSearchBoxEmpty(bool value) {
    isSearchBoxEmpty = value;
    notifyListeners();
  }

  void setSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  void setResultsExist(bool value) {
    resultsExist = value;
    notifyListeners();
  }

}