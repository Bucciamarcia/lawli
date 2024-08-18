import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class LegalInterestCalculatorMain extends StatefulWidget {
  const LegalInterestCalculatorMain({super.key});

  @override
  State<LegalInterestCalculatorMain> createState() =>
      _LegalInterestCalculatorMainState();
}

class _LegalInterestCalculatorMainState
    extends State<LegalInterestCalculatorMain> {
  String initialCapital = "0";
  DateTime? initialDate;
  DateTime? finalDate;
  List<List<String>> capitalizzazioneOptions = [
    ["Nessuna", "L'interesse viene calcolato solo sul capitale iniziale"],
    ["Trimestrale", "L'interesse viene calcolato ogni 3 mesi"],
    ["Semestrale", "L'interesse viene calcolato ogni 6 mesi"],
    ["Annuale", "L'interesse viene calcolato ogni anno"],
  ];
  String capitalizzazione = "";

  @override
  void initState() {
    super.initState();
    capitalizzazione = capitalizzazioneOptions[0][0];
    debugPrint("Set initial capitalizzazione: $capitalizzazione");
  }

  void updateInitialCapital(String value) {
    setState(() {
      debugPrint("Initial capital: $value");
      initialCapital = value;
    });
  }

  void updateInitialDate(DateTime? date) {
    setState(() {
      debugPrint("Initial date: $date");
      initialDate = date;
    });
  }

  void updateFinalDate(DateTime? date) {
    setState(() {
      debugPrint("Final date: $date");
      finalDate = date;
    });
  }

  void updateCapitalizzazione(String value) {
    setState(() {
      debugPrint("Capitalizzazione: $value");
      capitalizzazione = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return IntrinsicWidth(
      child: Center(
        child: Card(
          color: colorScheme.surface,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  "Calcolo interessi legali",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _optionRow(
                  context,
                  "Capitale iniziale €",
                  _numberSelector(context, updateInitialCapital, hintText: "0"),
                ),
                _optionRow(
                  context,
                  "Data inizio",
                  _dateSelector(context, updateInitialDate, displayDate: initialDate),
                ),
                _optionRow(
                  context,
                  "Data fine",
                  _dateSelector(context, updateFinalDate, displayDate: finalDate),
                ),
                Text(
                  "Capitalizzazione",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                _widgetCapitalizzazione(context),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text("Calcola"),
                  onPressed: () {
                    double result = _calculateResult();
                    debugPrint("Calculated result: $result");
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _optionRow(BuildContext context, String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: Row(children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 25),
        child,
      ]),
    );
  }

  /// Shows a field where only numbers can be inserted.
  Widget _numberSelector(BuildContext context, void Function(String) onChanged,
      {String hintText = ""}) {
    return Expanded(
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  /// Shows a date picker and shows the selected date if present.
  Widget _dateSelector(
      BuildContext context, void Function(DateTime?) onchanged, {required DateTime? displayDate}) {
    return Expanded(
      child: Row(children: [
        Text(displayDate != null
            ? DateFormat('dd/MM/yyyy').format(displayDate)
            : ""),
        displayDate != null
            ? const SizedBox(width: 20)
            : const SizedBox(width: 0),
        ElevatedButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: const Text("Seleziona data"),
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(2024, 12, 31),
              initialDate: DateTime.now(),
            );
            if (picked != null) {
              onchanged(picked);
            }
          },
        ),
      ]),
    );
  }

  Widget _widgetCapitalizzazione(BuildContext context) {
    return IntrinsicWidth(
      child: Column(children: <Widget>[
        for (List<String> option in capitalizzazioneOptions)
          RadioListTile(
            title: Text(option[0]),
            subtitle: Text(option[1]),
            value: option[0],
            groupValue: capitalizzazione,
            onChanged: (String? value) {
              updateCapitalizzazione(value ?? "");
            },
          )
      ]),
    );
  }

  double _calculateResult() {
    return 0;
  }
}
