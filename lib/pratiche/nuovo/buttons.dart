import 'package:flutter/material.dart';
import "package:lawli/services/firestore.dart";
import "nuovo.dart";

class NuovaPraticaFormButtons extends StatefulWidget {
  final NuovaPraticaFormState formData;
  final BuildContext pageContext;
  final double userId;

  const NuovaPraticaFormButtons(
      {super.key, required this.formData, required this.pageContext, required this.userId});

  @override
  State<NuovaPraticaFormButtons> createState() =>
      _NuovaPraticaFormButtonsState();
}

class _NuovaPraticaFormButtonsState extends State<NuovaPraticaFormButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/pratiche", (route) => false);
            },
            child: const Text("Cancella"),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              debugPrint("User ID: ${widget.userId}");
              AddPraticaToFirebase(formData: widget.formData, assistitoId: widget.userId).addPratica();
              postAdditionPushAndRemove();
            },
            child: const Text("Salva"),
          ),
        ),
      ],
    );
  }

  Future<dynamic> postAdditionPushAndRemove() {
    return showDialog(
      context: widget.pageContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("pratica aggiunto"),
          content: const Text("L'pratica è stato aggiunto correttamente"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/pratiche", (route) => false);
              },
              child: const Text("Chiudi"),
            ),
          ],
        );
      },
    );
  }
}

class AddPraticaToFirebase {
  final NuovaPraticaFormState formData;
  final double assistitoId;

  const AddPraticaToFirebase({required this.formData, required this.assistitoId});

  Future<void> addPratica() async {
    final account = await FirestoreService().retrieveAccountObject();
    final pratiche = account.collection("pratiche");
    final titolo = formData.titoloController.text;
    final descrizione = formData.descrizioneController.text;
    final double praticaId = await _getPraticaId(account);
    final pratica = _buildPraticaMap(titolo, descrizione, praticaId);
    final documentName = praticaId.toString();

    await pratiche.doc(documentName).set(pratica);
    final praticaData = await account.get();
    final listaPratiche = praticaData.data()?['lista_pratiche'];

    if (listaPratiche != null) {
      final updatedListaPratiche = [...listaPratiche, "${pratica['titolo']}"];
      await account.update({
        "lista_pratiche": updatedListaPratiche,
      });
    } else {
      await account.update({
        "lista_pratiche": ["${pratica['titolo']}"],
      });
    }

  }

  Map<String, dynamic> _buildPraticaMap(
      String titolo, String descrizione, double praticaId) {
    return {
      "assistitoId": assistitoId,
      "titolo": titolo,
      "descrizione": descrizione,
      "id": praticaId
    };
  }


  Future<double> _getPraticaId(account) async {
    final stats = account.collection("stats");
    final docRef = stats.doc("pratiche counter");
    final docSnapshot = await docRef.get(); // Get the document snapshot

    if (!docSnapshot.exists) {
      await docRef.set({
        "total counter": 1,
        "active pratiche": 1
      }); // Initialize if not exists
      return 1; // Make sure to return a double
    } else {
      final pratiche = docSnapshot.data(); // Get the data from the snapshot
      final praticaId = pratiche["total counter"] + 1;
      final activepratiche = pratiche["active pratiche"] + 1;
      await docRef.set({
        "total counter": praticaId,
        "active pratiche": activepratiche
      }); // Update the counter
      return praticaId
          .toDouble(); // Ensure the return type matches the method signature
    }
  }



}
