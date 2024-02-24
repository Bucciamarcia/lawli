import 'package:flutter/material.dart';
import "package:lawli/services/firestore.dart";
import "nuovo.dart";

class NuovoAssistitoFormButtons extends StatefulWidget {
  final NuovoAssistitoFormState formData;
  final BuildContext pageContext;

  const NuovoAssistitoFormButtons(
      {super.key, required this.formData, required this.pageContext});

  @override
  State<NuovoAssistitoFormButtons> createState() =>
      _NuovoAssistitoFormButtonsState();
}

class _NuovoAssistitoFormButtonsState extends State<NuovoAssistitoFormButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              widget.formData.clearAll();
            },
            child: const Text("Cancella"),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              AddAssistitoToFirebase(formData: widget.formData).addAssistito();
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
  final NuovoAssistitoFormState formData;

  const AddAssistitoToFirebase({required this.formData});

  Future<double> _getAssistitoId(account) async {
    final stats = account.collection("stats");
    final docRef = stats.doc("assistiti counter");
    final docSnapshot = await docRef.get(); // Get the document snapshot

    if (!docSnapshot.exists) {
      await docRef.set({
        "total counter": 1,
        "active assistiti": 1
      }); // Initialize if not exists
      return 1; // Make sure to return a double
    } else {
      final assistiti = docSnapshot.data(); // Get the data from the snapshot
      final assistitoId = assistiti["total counter"] + 1;
      final activeAssistiti = assistiti["active assistiti"] + 1;
      await docRef.set({
        "total counter": assistitoId,
        "active assistiti": activeAssistiti
      }); // Update the counter
      return assistitoId
          .toDouble(); // Ensure the return type matches the method signature
    }
  }

  Future<void> addAssistito() async {
    final account = await FirestoreService().retrieveAccountObject();
    final assistiti = account.collection("assistiti");
    final double assistitoId = await _getAssistitoId(account);
    final assistito = _buildAssistitoMap(assistitoId, formData);
    final documentName = assistitoId.toString();

    await assistiti.doc(documentName).set(assistito);
  }

  Map<String, dynamic> _buildAssistitoMap(
      double assistitoId, NuovoAssistitoFormState formData) {
    // Builds and returns the assistito map from formData
    return {
      "id": assistitoId,
      "nome": formData.firstNameController.text,
      "cognome": formData.lastNameController.text,
      "ragione sociale": formData.businessNameController.text,
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
