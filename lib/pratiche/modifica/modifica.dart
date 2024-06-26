import 'package:flutter/material.dart';
import "../../../shared/shared.dart";
import "../../../services/services.dart";
import "custom_text_field.dart";
import "buttons.dart";

class ModificaPraticaScreen extends StatefulWidget {
  final Pratica pratica;
  const ModificaPraticaScreen({super.key, required this.pratica});

  @override
  State<ModificaPraticaScreen> createState() => _ModificaPraticaScreenState();
}

class _ModificaPraticaScreenState extends State<ModificaPraticaScreen> {
  double userId = 0;
    final ModificaPraticaFormState formState = ModificaPraticaFormState();

    @override
    // Fill the form with the pratica's data
  void initState() {
    super.initState();
    formState.defineControllers(widget.pratica);
  }

  Scaffold body(BuildContext context) {
    List<Widget> formInputs = [
      Text(
        "Modifica pratica",
        style: Theme.of(context).textTheme.displayLarge,
      ),
      const SizedBox(height: 20),
      CustomTextField(
        controller: formState.titoloController,
        labelText: "Titolo",
      ),
      CustomTextField(
        controller: formState.descrizioneController,
        labelText: "Descrizione",
      ),
      CustomDropdownField(
          controller: formState.assistitoIdController,
          labelText: "Assistito",
          onValueChanged: (value) async {
            formState.assistitoIdController.text = value.toString();
            debugPrint("Assistito ID: ${formState.assistitoIdController.text}");
            var newUserId = await AssistitoDb().getIdFromNomeCognome(formState.assistitoIdController.text);
            debugPrint("User ID: $newUserId");
            updateUserId(newUserId);
            formState.assistitoIdController.text = newUserId.toString();
            udpateFormState(formState);
          }),
      const SizedBox(height: 20),

      
      ModificaPraticaFormButtons(formData: formState, pageContext: context, id: widget.pratica.id),


    ];

    return Scaffold(
      body: Container(
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Column(
          children: formInputs,
        ),
      ),
    );
  }

  void updateUserId(double newUserId) {
  setState(() {
    userId = newUserId;
  });
  }
  void udpateFormState(ModificaPraticaFormState formState) {
  setState(() {
    formState.assistitoIdController.text = userId.toString();
  });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Modifica pratica"),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return DesktopVersion(body: body(context), appBar: appBar(context));
        } else {
          return MobileVersion(body: body(context), appBar: appBar(context));
        }
      },
    );
  }

}

class ModificaPraticaFormState {

  defineControllers(Pratica pratica) {
    titoloController.text = pratica.titolo;
    descrizioneController.text = pratica.descrizione;
    assistitoIdController.text = pratica.assistitoId.toString();
  }

  final TextEditingController titoloController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController assistitoIdController = TextEditingController();

  void clearAll() {
    titoloController.clear();
    descrizioneController.clear();
    assistitoIdController.clear();
  }
}
