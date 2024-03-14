import "package:flutter/material.dart";
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:lawli/services/models.dart';

class DashboardProvider extends ChangeNotifier {

  double idPratica = kDebugMode ? 1 : 0;
  String idDocument = "0";
  Pratica pratica = Pratica();
  Documento documento = Documento(data: DateTime.now());

  void setIdPratica(double id) {
    idPratica = id;
    notifyListeners();
  }

  void setPratica (Pratica p) {
    pratica = p;
    notifyListeners();
  }

  void setDocumento (Documento d) {
    documento = d;
    notifyListeners();
  }

  void setIdDocument(String idDoc) {
    idDocument = idDoc;
    notifyListeners();
  }
}