import 'package:flutter/material.dart';
import '../services/firestore.dart';

class BottoneCancellaPratica {
  final double praticaId;
  final String titolo;

  BottoneCancellaPratica({required this.praticaId, required this.titolo});


  void showConfirmPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conferma cancellazione"),
            content: Text("Sei sicuro di voler cancellare la pratica '$titolo'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () {
                AssistitoDb().deletePratica(praticaId);
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, "/pratiche", (route) => false);
              },
              child: const Text("Conferma"),
            ),
          ],
        );
      },
    );
  }
}