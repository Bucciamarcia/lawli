import "package:flutter/material.dart";
import 'package:flutter/foundation.dart' show kDebugMode;

class DashboardProvider extends ChangeNotifier {

  double idPratica = kDebugMode ? 1 : 0;
  String idDocument = "none";

  void setIdPratica(double id) {
    idPratica = id;
    notifyListeners();
  }

  void setIdDocument(String idDoc) {
    idDocument = idDoc;
    notifyListeners();
  }
}