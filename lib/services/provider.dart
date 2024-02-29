import "package:flutter/material.dart";
import 'package:flutter/foundation.dart' show kDebugMode;

class DashboardProvider extends ChangeNotifier {

  double idPratica = kDebugMode ? 1 : 0;

  void setIdPratica(double id) {
    idPratica = id;
    notifyListeners();
  }
}