import 'package:cloud_functions/cloud_functions.dart';
import "sentenza_object.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lawli/services/provider.dart';
import 'package:provider/provider.dart';

class MotoreRicercaSentenze extends StatefulWidget {
  const MotoreRicercaSentenze({super.key});

  @override
  State<MotoreRicercaSentenze> createState() => _MotoreRicercaSentenzeState();
}

class _MotoreRicercaSentenzeState extends State<MotoreRicercaSentenze>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RicercaSentenzeProvider(),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Parole chiave"),
              Tab(text: "Documento"),
              Tab(text: "Pratica"),
            ],
          ),
          SizedBox(
            height: 1200,
            child: TabBarView(
              controller: _tabController,
              children: const [
                RicercaParoleChiave(),
                RicercaDocumento(),
                Text("tab 3 content"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RicercaDocumento extends StatefulWidget {
  const RicercaDocumento({super.key});

  @override
  State<RicercaDocumento> createState() => _RicercaDocumentoState();
}

class _RicercaDocumentoState extends State<RicercaDocumento> {
  @override
  Widget build(BuildContext context) {
    return const Text("tab 2 content here");
  }
}

class RicercaParoleChiave extends StatefulWidget {
  const RicercaParoleChiave({super.key});

  @override
  State<RicercaParoleChiave> createState() => _RicercaParoleChiaveState();
}

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

Future<String?> textSendButtonPressed(String text, String corte) async {
  var result = await FirebaseFunctions.instance.httpsCallable("get_similar_sentences").call(
    {
      "text": text,
      "corte": corte,
    },
  );
  String resultData = result.data;
  return resultData;
}

class _RicercaParoleChiaveState extends State<RicercaParoleChiave> {
  final _textController = TextEditingController();
  String _resultText = ''; // Store the result string

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TribunaleSelector(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Inserisci il testo da cercare...',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            submitIconButton(_textController.text,
                clearController:
                    true),
          ],
        ),
        if (_resultText.isNotEmpty)
          ResultBox(resultText: _resultText),
      ],
    );
  }

  IconButton submitIconButton(String textToCompare,
      {bool clearController = false}) {
    return IconButton(
      icon: const Icon(Icons.send),
      style: ButtonStyle(iconSize: MaterialStateProperty.all(50)),
      tooltip: textToCompare.isNotEmpty
          ? 'Invia il testo'
          : 'Inserisci del testo per inviare',
      onPressed: textToCompare.isNotEmpty
          ? () async {
              // Only send if the input isn't empty
              final result = await textSendButtonPressed(textToCompare, Provider.of<RicercaSentenzeProvider>(context, listen: false).corte);
              if (clearController == true) {
                setState(() {
                  _resultText = result!;
                  _textController.clear(); // Clear input after sending
                });
              }
            }
          : null, // Disable the button if text is empty
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class ResultBox extends StatelessWidget {
  const ResultBox({
    super.key,
    required String resultText,
  }) : _resultText = resultText;

  final String _resultText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Row(
        children: [
          Expanded(child: SelectableText(_resultText)), // Make text selectable
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _resultText));
            },
          ),
        ],
      ),
    );
  }
}
