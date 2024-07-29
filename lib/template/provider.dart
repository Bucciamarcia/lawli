import 'package:flutter/material.dart';
import 'package:lawli/services/models.dart';

class TemplateProvider extends ChangeNotifier {
  Pratica? selectedPratica;
  bool _isSearchBoxEmpty = true;
  bool _isSearching = false;
  List<Template> _searchResults = [];

  bool get isSearchBoxEmpty => _isSearchBoxEmpty;
  bool get isSearching => _isSearching;
  List<Template> get searchResults => _searchResults;
  void setPratica(Pratica pratica) {
    selectedPratica = pratica;
    debugPrint("Pratica selezionata: ${selectedPratica!.titolo}");
    notifyListeners();
  }
  void setSearchBoxEmpty(bool value) {
    _isSearchBoxEmpty = value;
    notifyListeners();
  }

  void setSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  void setSearchResults(List<Template> results) {
    _searchResults = results;
    notifyListeners();
  }
}