import "package:flutter/material.dart";
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:lawli/services/models.dart';

class RicercaSentenzeProvider extends ChangeNotifier {
  String corte = "tutte";

  void setCorte(String c) {
    corte = c;
    notifyListeners();
  }
}

class DashboardProvider extends ChangeNotifier {
  double idPratica = kDebugMode ? 1 : 0;

  Pratica pratica = kDebugMode
      ? Pratica(id: 1, assistitoId: 2, titolo: "Pratica Mario Rossi")
      : Pratica();

  Documento documento = kDebugMode
      ? Documento(
          filename: "Gmail - New Order Confirmation_ IN139829.pdf",
          brief_description: "Conferma ordine Analogue Seduction",
          data: DateTime.now())
      : Documento(data: DateTime.now());

  String accountName = kDebugMode ? "lawli" : "";

  Map? timeline;

  void setIdPratica(double id) {
    idPratica = id;
    notifyListeners();
  }

  void setPratica(Pratica p) {
    pratica = p;
    notifyListeners();
  }

  void setDocumento(Documento d) {
    documento = d;
    notifyListeners();
  }

  void setAccountName(String name) {
    accountName = name;
    try {
      notifyListeners();
    } catch (e) {
      debugPrint("Error notifying listeners on setAccountName: $e");
    }
  }

  void setTimeline(Map t) {
    timeline = t;
    notifyListeners();
  }

}
