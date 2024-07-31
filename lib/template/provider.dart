import 'package:flutter/material.dart';
import 'package:lawli/services/models.dart';

class TemplateProvider extends ChangeNotifier {
  Pratica? selectedPratica;
  bool _isSearchBoxEmpty = true;
  bool _isSearching = false;
  List<Template> _searchResults = [];
  bool isSearchingLikley = false;
  List<Template> likelyTemplates = [];

  bool get isSearchBoxEmpty => _isSearchBoxEmpty;
  bool get isSearching => _isSearching;
  List<Template> get searchResults => _searchResults;
  void setPratica(Pratica pratica) {
    selectedPratica = pratica;
    if (selectedPratica != null) {
      debugPrint("Pratica selezionata: ${selectedPratica!.titolo}");
    }
    notifyListeners();
  }

  void setIsSearchingLikley(bool value) {
    isSearchingLikley = value;
    notifyListeners();
  }

  void refreshTemplates() {
    // This method doesn't need to do anything except notify listeners
    notifyListeners();
  }

  void setSearchBoxEmpty(bool value) {
    _isSearchBoxEmpty = value;
    notifyListeners();
  }

  void setLikelyTemplates(List<Template> templates) {
    likelyTemplates = templates;
    notifyListeners();
    debugPrint("Likely templates have been set.");
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
