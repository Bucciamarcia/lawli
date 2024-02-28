import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "../../../shared/shared.dart";
import "../../../services/services.dart";
import "custom_text_field.dart";
import "buttons.dart";

class ModificaAssistitoScreen extends StatefulWidget {
  final Assistito assistito;
  const ModificaAssistitoScreen({super.key, required this.assistito});

  @override
  State<ModificaAssistitoScreen> createState() => _ModificaAssistitoScreenState();
}

class _ModificaAssistitoScreenState extends State<ModificaAssistitoScreen> {
    final ModificaAssistitoFormState formState = ModificaAssistitoFormState();

    @override
    // Fill the form with the assistito's data
  void initState() {
    super.initState();
    formState.defineControllers(widget.assistito);
  }

  Scaffold body(BuildContext context) {
    List<Widget> formInputs = [
      Text(
        "Modifica assistito",
        style: Theme.of(context).textTheme.displayLarge,
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: formState.firstNameController,
              labelText: "Nome",
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomTextField(
              controller: formState.lastNameController,
              labelText: "Cognome",
            ),
          ),
        ],
      ),
      CustomTextField(
        controller: formState.businessNameController,
        labelText: "Ragione sociale / P. IVA",
      ),
      CustomTextField(
        controller: formState.emailController,
        labelText: "Email",
      ),
      CustomTextField(
        controller: formState.descriptionController,
        labelText: "Descrizione",
      ),
      CustomTextField(
        controller: formState.phoneController,
        labelText: "Telefono",
      ),
      CustomTextField(
        controller: formState.addressController,
        labelText: "Indirizzo",
      ),
      CustomTextField(
        controller: formState.cityController,
        labelText: "Città",
      ),
      CustomTextField(
        controller: formState.provinceController,
        labelText: "Provincia",
      ),
      TextFormField(
        controller: formState.capController,
        decoration: const InputDecoration(labelText: "CAP"),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
      ),
      CustomTextField(
        controller: formState.countryController,
        labelText: "Nazione",
      ),
      const SizedBox(height: 20),
      ModificaAssistitoFormButtons(formData: formState, pageContext: context, id: widget.assistito.id),


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

class ModificaAssistitoFormState {

  defineControllers(Assistito assistito) {
    firstNameController.text = assistito.nome;
    lastNameController.text = assistito.cognome;
    businessNameController.text = assistito.ragioneSociale;
    emailController.text = assistito.email;
    descriptionController.text = assistito.descrizione;
    phoneController.text = assistito.telefono;
    addressController.text = assistito.indirizzo;
    cityController.text = assistito.citta;
    provinceController.text = assistito.provincia;
    capController.text = assistito.cap;
    countryController.text = assistito.nazione;
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController capController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  void clearAll() {
    firstNameController.clear();
    lastNameController.clear();
    businessNameController.clear();
    emailController.clear();
    descriptionController.clear();
    phoneController.clear();
    addressController.clear();
    cityController.clear();
    provinceController.clear();
    capController.clear();
    countryController.clear();
  }
}
