import 'package:flutter/material.dart';
import "package:lawli/services/firestore.dart";
import "modifica.dart";

class ModificaPraticaFormButtons extends StatefulWidget {
  final double id;
  final ModificaPraticaFormState formData;
  final BuildContext pageContext;

  const ModificaPraticaFormButtons(
      {super.key, required this.formData, required this.pageContext, required this.id});

  @override
  State<ModificaPraticaFormButtons> createState() =>
      ModificaPraticaFormButtonsState();
}

class ModificaPraticaFormButtonsState extends State<ModificaPraticaFormButtons> {
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
              AddPraticaToFirebase(formData: widget.formData, id: widget.id).addPratica();
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
          title: const Text("Pratica aggiunta"),
          content: const Text("La pratica è stato aggiunta correttamente"),
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
  final ModificaPraticaFormState formData;
  final double id;

  const AddPraticaToFirebase({required this.formData, required this.id});

  Future<void> addPratica() async {
    final account = await FirestoreService().retrieveAccountObject();
    final pratiche = account.collection("pratiche");
    final pratica = _buildPraticaMap(id, formData);

    await pratiche.doc(id.toString()).set(pratica);
  }

  Map<String, dynamic> _buildPraticaMap(
      double praticaId, ModificaPraticaFormState formData) {
    // Builds and returns the pratica map from formData
    return {
      "id": id,
      "titolo": formData.titoloController.text,
      "descrizione": formData.descrizioneController.text,
      "assistitoId": double.parse(formData.assistitoIdController.text),
      
    };
  }
}