import "package:flutter/material.dart";

class DashboardProvider extends ChangeNotifier {
  double idPratica = 0;

  void setIdPratica(double id) {
    idPratica = id;
    notifyListeners();
  }
}