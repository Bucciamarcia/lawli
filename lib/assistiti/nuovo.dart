import 'package:flutter/material.dart';
import "../../shared/shared.dart";
import "../../services/services.dart";

class NuovoAssistitoScreen extends StatefulWidget {
  const NuovoAssistitoScreen({super.key});

  @override
  State<NuovoAssistitoScreen> createState() => _NuovoAssistitoScreenState();
}

/* Collect these fields:

  final String firstName;
  final String lastName;
  final String businessName;
  final String email;
  final String description;
  final String phone;
  final String address;
  final String city;
  final String province;
  final double cap;
  final String country;
 */
class _NuovoAssistitoScreenState extends State<NuovoAssistitoScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _capController = TextEditingController();
  final _countryController = TextEditingController(text: "Italia");

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Column(
          children: [
            Text(
              "Aggiungi un nuovo assistito",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            const Text("Nome e cognome sono obbligatori."),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: "Nome"),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: "Cognome"),
                  ),
                )
              ],
            ),
            TextField(
              controller: _businessNameController,
              decoration:
                  const InputDecoration(labelText: "Ragione sociale / P. IVA"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Descrizione"),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Telefono"),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "Indirizzo"),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: "Città"),
            ),
            TextField(
              controller: _provinceController,
              decoration: const InputDecoration(labelText: "Provincia"),
            ),
            TextField(
              controller: _capController,
              decoration: const InputDecoration(labelText: "CAP"),
            ),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: "Nazione"),
            ),
          ],
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
