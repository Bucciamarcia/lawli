import 'package:flutter/material.dart';
import '../services/firestore.dart';

class BottoneCancellaAssistito {
  final double assistitoId;
  final String assistitoNome;
  final String assistitoCognome;

  BottoneCancellaAssistito({required this.assistitoId, required this.assistitoNome, required this.assistitoCognome});


  void showConfirmPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conferma cancellazione"),
            content: Text("Sei sicuro di voler cancellare l'assistito '$assistitoNome $assistitoCognome'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () {
                AssistitoDb().deleteAssistito(assistitoId);
                Navigator.of(context).pop();
              },
              child: const Text("Conferma"),
            ),
          ],
        );
      },
    );
  }
}