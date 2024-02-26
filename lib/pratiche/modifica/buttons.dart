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
                  context, "/assistiti", (route) => false);
            },
            child: const Text("Cancella"),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              AddAssistitoToFirebase(formData: widget.formData, id: widget.id).addAssistito();
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
          title: const Text("Assistito aggiunto"),
          content: const Text("L'assistito è stato aggiunto correttamente"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/assistiti", (route) => false);
              },
              child: const Text("Chiudi"),
            ),
          ],
        );
      },
    );
  }
}

class AddAssistitoToFirebase {
  final ModificaPraticaFormState formData;
  final double id;

  const AddAssistitoToFirebase({required this.formData, required this.id});


  Future<void> addAssistito() async {
    final account = await FirestoreService().retrieveAccountObject();
    final assistiti = account.collection("assistiti");
    final assistito = _buildAssistitoMap(id, formData);

    await assistiti.doc(id.toString()).set(assistito);
  }

  Map<String, dynamic> _buildAssistitoMap(
      double assistitoId, ModificaPraticaFormState formData) {
    // Builds and returns the assistito map from formData
    return {
      "id": id,
      "titolo": formData.titoloController.text,
      "descrizione": formData.descrizioneController.text,
      "assistitoId": formData.assistitoIdController.text,
      
    };
  }
}
