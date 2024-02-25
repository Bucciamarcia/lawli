import 'package:flutter/material.dart';
import "package:lawli/services/firestore.dart";
import "modifica.dart";

class ModificaAssistitoFormButtons extends StatefulWidget {
  final double id;
  final ModificaAssistitoFormState formData;
  final BuildContext pageContext;

  const ModificaAssistitoFormButtons(
      {super.key, required this.formData, required this.pageContext, required this.id});

  @override
  State<ModificaAssistitoFormButtons> createState() =>
      ModificaAssistitoFormButtonsState();
}

class ModificaAssistitoFormButtonsState extends State<ModificaAssistitoFormButtons> {
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
  final ModificaAssistitoFormState formData;
  final double id;

  const AddAssistitoToFirebase({required this.formData, required this.id});


  Future<void> addAssistito() async {
    final account = await FirestoreService().retrieveAccountObject();
    final assistiti = account.collection("assistiti");
    final assistito = _buildAssistitoMap(id, formData);

    await assistiti.doc(id.toString()).set(assistito);
  }

  Map<String, dynamic> _buildAssistitoMap(
      double assistitoId, ModificaAssistitoFormState formData) {
    // Builds and returns the assistito map from formData
    return {
      "id": assistitoId,
      "nome": formData.firstNameController.text,
      "cognome": formData.lastNameController.text,
      "nomeCompleto": "${formData.firstNameController.text} ${formData.lastNameController.text}",
      "ragioneSociale": formData.businessNameController.text,
      "email": formData.emailController.text,
      "descrizione": formData.descriptionController.text,
      "telefono": formData.phoneController.text,
      "indirizzo": formData.addressController.text,
      "nazione": formData.countryController.text,
      "citta": formData.cityController.text,
      "cap": formData.capController.text,
    };
  }
}
