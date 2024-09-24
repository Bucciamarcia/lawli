import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lawli/services/text_extractor.dart';
import 'package:lawli/shared/shared.dart';
import 'package:lawli/shared/upload_file.dart';
import 'package:lawli/strumenti_gratis/calcolo_interessi_legali/calcolatore.dart';
import 'package:lawli/strumenti_gratis/calcolo_interessi_legali/result_widget.dart';

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: colorScheme.primary, width: 2),
                          left:
                              BorderSide(color: colorScheme.primary, width: 2),
                          right:
                              BorderSide(color: colorScheme.primary, width: 2),
                          top: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Text(
                          "Carica un documento",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          "Carica un documento e l'AI estrapolerà i dati necessari per il calcolo degli interessi legali.",
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        FileUploader(
                            labelText: "Carica un file",
                            helperText: "",
                            buttonText: "Seleziona",
                            allowedExtensions: const ["pdf", "docx", "txt"],
                            onFileSelected: _fileSelected)
                      ],
                    ),
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
                  _dateSelector(context, updateInitialDate,
                      displayDate: initialDate),
                ),
                _optionRow(
                  context,
                  "Data fine",
                  _dateSelector(context, updateFinalDate,
                      displayDate: finalDate),
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
                    onPressed: () async {
                      if (initialDate == null ||
                          finalDate == null ||
                          initialCapital.isEmpty ||
                          initialCapital == "0") {
                        ConfirmationMessage.show(context, "Errore",
                            "Assicurati di aver inserito tutti i dati correttamente.");
                        return;
                      }
                      OverlayEntry? overlay = CircularProgress.show(context);
                      try {
                        TabellaInteressi results = await _calculateResult();
                        debugPrint(
                            "Calculated result: ${results.totaleDovuto}");
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Risultato"),
                              content: InteressiLegaliResults(results: results),
                            );
                          },
                        );
                      } catch (e) {
                        debugPrint("Error: $e");
                        ConfirmationMessage.show(context, "Errore",
                            "Errore durante il calcolo degli interessi legali. Assicurati di aver inserito tutti i dati correttamente.");
                      } finally {
                        overlay?.remove();
                        overlay = null;
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fileSelected(PlatformFile? file) async {
    if (file == null || file.bytes == null || file.extension == null) {
      return;
    }

    OverlayEntry? overlay = CircularProgress.show(context);

    final String extension = file.extension!;
    final Uint8List data = file.bytes!;
    String text = TextExtractor().extractText(data, extension);
    var response = await FirebaseFunctions.instance
        .httpsCallable("calcolo_interessi_legali_data")
        .call({"text": text});
    Map<String, dynamic> callData = response.data;
    String initialDate = callData["data_iniziale"];
    String finalDate = callData["data_finale"];
    double initialCapital = callData["capitale_iniziale"];
    String capitalizzazione = callData["capitalizzazione"];

    debugPrint("Initial date: $initialDate");
    debugPrint("Final date: $finalDate");
    debugPrint("Initial capital: $initialCapital");
    debugPrint("Capitalizzazione: $capitalizzazione");

    if (initialDate != "") {
      DateTime initialDateObj = _parseDate(initialDate);
      updateInitialDate(initialDateObj);
    }
    if (finalDate != "") {
      DateTime finalDateObj = _parseDate(finalDate);
      updateFinalDate(finalDateObj);
    }
    if (initialCapital != 0) {
      updateInitialCapital(initialCapital.toString());
    }
    if (capitalizzazione != "") {
      updateCapitalizzazione(capitalizzazione);
    }

    overlay?.remove();
    overlay = null;
  }

  DateTime _parseDate(String date) {
    List<String> parts = date.split('/');
    String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
    return DateTime.parse(formattedDate);
  }

  Widget _optionRow(BuildContext context, String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: SizedBox(
        height: 100,
        child: Column(children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 25),
          child,
        ]),
      ),
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
  Widget _dateSelector(BuildContext context, void Function(DateTime?) onchanged,
      {required DateTime? displayDate}) {
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

  Future<TabellaInteressi> _calculateResult() async {
    late final double intCapitalizzazione;
    if (capitalizzazione == "Nessuna") {
      intCapitalizzazione = 0;
    } else if (capitalizzazione == "Trimestrale") {
      intCapitalizzazione = 3;
    } else if (capitalizzazione == "Semestrale") {
      intCapitalizzazione = 6;
    } else if (capitalizzazione == "Annuale") {
      intCapitalizzazione = 12;
    }
    Calcolatore calcolatore = Calcolatore(
      initialCapital: double.parse(initialCapital),
      initialDate: initialDate!,
      finalDate: finalDate!,
      capitalizzazione: intCapitalizzazione,
    );
    TabellaInteressi tabella = await calcolatore.run();
    return tabella;
  }
}
