import 'package:flutter/material.dart';

class AccountInfoProvider extends ChangeNotifier {
  String displayName = "";
  String address = "";

  void setDisplayName(String value) {
    displayName = value;
    notifyListeners();
  }

}