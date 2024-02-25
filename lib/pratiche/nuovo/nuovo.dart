import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "../../../shared/shared.dart";
import "../../../services/services.dart";
import "custom_text_field.dart";
import "buttons.dart";

class NuovaPraticaScreen extends StatefulWidget {
  const NuovaPraticaScreen({super.key});

  @override
  State<NuovaPraticaScreen> createState() => _NuovaPraticaScreenState();
}

class _NuovaPraticaScreenState extends State<NuovaPraticaScreen> {
  final NuovaPraticaFormState formState = NuovaPraticaFormState();

  Scaffold body(BuildContext context) {
    List<Widget> formInputs = [
      Text(
        "Aggiungi una nuova pratica",
        style: Theme.of(context).textTheme.displayLarge,
      ),
      const SizedBox(height: 20),
      
      CustomDropdownField(controller: formState.assistitoIdController, labelText: "Assistito"),

      CustomTextField(
        controller: formState.titoloController,
        labelText: "Titolo",
      ),
      CustomTextField(
        controller: formState.descrizioneController,
        labelText: "Descrizione",
      ),
      const SizedBox(height: 20),
      NuovaPraticaFormButtons(formData: formState, pageContext: context),


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

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Assistiti"),
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

class NuovaPraticaFormState {
  final TextEditingController assistitoIdController = TextEditingController();
  final TextEditingController titoloController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();

  void clearAll() {
    assistitoIdController.clear();
    titoloController.clear();
    descrizioneController.clear();
  }
}
