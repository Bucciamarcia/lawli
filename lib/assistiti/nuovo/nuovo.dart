import 'package:flutter/material.dart';
import "../../../shared/shared.dart";
import "../../../services/services.dart";
import "customTextField.dart";
import "buttons.dart";

class NuovoAssistitoScreen extends StatefulWidget {
  const NuovoAssistitoScreen({super.key});

  @override
  State<NuovoAssistitoScreen> createState() => _NuovoAssistitoScreenState();
}

class _NuovoAssistitoScreenState extends State<NuovoAssistitoScreen> {
  final NuovoAssistitoFormState formState = NuovoAssistitoFormState();

  Scaffold body(BuildContext context) {
    List<Widget> formInputs = [
      Text(
        "Aggiungi un nuovo assistito",
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
      CustomTextField(
        controller: formState.capController,
        labelText: "CAP",
      ),
      CustomTextField(
        controller: formState.countryController,
        labelText: "Nazione",
      ),
      const SizedBox(height: 20),
      NuovoAssistitoFormButtons(formData: formState),


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

class NuovoAssistitoFormState {
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
  final TextEditingController countryController =
      TextEditingController(text: "Italia");

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
