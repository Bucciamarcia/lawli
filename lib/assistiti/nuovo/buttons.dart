import 'package:flutter/material.dart';
import "nuovo.dart";

class NuovoAssistitoFormButtons extends StatefulWidget {
  final NuovoAssistitoFormState formData;

  const NuovoAssistitoFormButtons({super.key, required this.formData});

  @override
  State<NuovoAssistitoFormButtons> createState() => _NuovoAssistitoFormButtonsState();
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
              print(widget.formData.countryController.text); // Now reflects changes
            },
            child: const Text("Salva"),
          ),
        ),
      ],
    );
  }
}