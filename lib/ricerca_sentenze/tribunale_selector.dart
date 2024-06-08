import 'package:flutter/material.dart';
import 'package:lawli/services/provider.dart';
import 'package:provider/provider.dart';

class TribunaleSelector extends StatelessWidget {
  const TribunaleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Seleziona la corte:"),
        const SizedBox(width: 10),
        DropdownButton(
            focusColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down),
            value: Provider.of<RicercaSentenzeProvider>(context).corte,
            items: const [
              DropdownMenuItem(value: "tutte", child: Text("tutte")),
              DropdownMenuItem(value: "tribunale", child: Text("tribunale")),
              DropdownMenuItem(value: "appello", child: Text("appello")),
              DropdownMenuItem(value: "cassazione", child: Text("cassazione")),
            ],
            onChanged: (value) {
              Provider.of<RicercaSentenzeProvider>(context, listen: false)
                  .setCorte(value.toString());
            }),
      ],
    );
  }
}
