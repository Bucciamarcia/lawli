import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import 'package:lawli/services/models.dart';
import "dart:convert";
import 'package:cloud_functions/cloud_functions.dart';
import "package:lawli/ricerca_sentenze/sentenza_object.dart";

class RicercaSentenzeProvider extends ChangeNotifier {
  String corte = "tutte";
  bool isSearchingSentenze = false;
  List<Sentenza> similarSentenze = [];
  Pratica? selectedPratica;
  Documento? selectedDocumento;

  void setCorte(String c) {
    corte = c;
    notifyListeners();
  }

  Future<List<Sentenza>> fetchSimilarSentenze(String text, String corte) async {
    List<Sentenza> sentenze = [];
    var result = await FirebaseFunctions.instance
        .httpsCallable("get_similar_sentences")
        .call(
      {
        "text": text,
        "corte": corte,
      },
    );
    var data = result.data;
    List<dynamic> dataList = jsonDecode(data);
    for (dynamic o in dataList) {
      sentenze.add(
        Sentenza(
          contenuto: o["contenuto"],
          corte: o["corte"],
          titolo: o["titolo"],
          distance: o["distance"],
        ),
      );
    }
    return sentenze;
  }

  Future<void> searchSentenze(String text, String corte) async {
    isSearchingSentenze = true;
    notifyListeners();
    try {
    List<Sentenza> sentenze = await fetchSimilarSentenze(text, corte);
    similarSentenze = sentenze;
    } catch (e) {
      debugPrint("Error fetching similar sentenze: $e");
    } finally {
      isSearchingSentenze = false;
      notifyListeners();
    }
  }

  void setIsSearchingSentenze(bool b) {
    isSearchingSentenze = b;
    notifyListeners();
  }

  void setSelectedPratica(Pratica p) {
    selectedPratica = p;
    debugPrint("Selected pratica: ${selectedPratica!.titolo}");
    notifyListeners();
  }

  void setSelectedDocumento(Documento d) {
    selectedDocumento = d;
    debugPrint("Selected documento: ${selectedDocumento!.filename}");
    notifyListeners();
  }
}

class DashboardProvider extends ChangeNotifier {
  double idPratica = kDebugMode ? 1 : 0;

  Pratica pratica = kDebugMode
      ? Pratica(id: 1, assistitoId: 2, titolo: "Pratica Mario Rossi")
      : Pratica();

  Documento documento = Documento(data: DateTime.now());

  String accountName = "";

  Map? timeline;

  void setIdPratica(double id) {
    idPratica = id;
    notifyListeners();
  }

  void setPratica(Pratica p) {
    pratica = p;
    debugPrint("Set pratica: ${pratica.titolo}");
    notifyListeners();
  }

  void setDocumento(Documento d) {
    documento = d;
    debugPrint("Set documento: ${documento.filename}");
    notifyListeners();
  }

  void setAccountName(String name) {
    accountName = name;
    try {
      notifyListeners();
      debugPrint("Set account name to $name");
    } catch (e) {
      debugPrint("Error notifying listeners on setAccountName: $e");
    }
  }

  void setTimeline(Map t) {
    timeline = t;
    notifyListeners();
  }
}
