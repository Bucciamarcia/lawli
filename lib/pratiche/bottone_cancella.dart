import 'package:flutter/material.dart';
import '../services/firestore.dart';

class BottoneCancellaPratica {
  final double praticaId;
  final String titolo;
  final String descrizione;

  BottoneCancellaPratica({required this.praticaId, required this.titolo, required this.descrizione});


  void showConfirmPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conferma cancellazione"),
            content: Text("Sei sicuro di voler cancellare l'assistito '$titolo $descrizione'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () {
                AssistitoDb().deleteAssistito(praticaId);
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, "/assistiti", (route) => false);
              },
              child: const Text("Conferma"),
            ),
          ],
        );
      },
    );
  }
}