import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lawli/strumenti_gratis/ricerca_sentenze/tribunale_selector.dart';
import 'package:lawli/services/auth.dart';
import 'package:lawli/services/cloud_storage.dart';
import 'package:lawli/services/firestore.dart';
import 'package:lawli/services/text_extractor.dart';
import 'package:lawli/shared/upload_file.dart';
import '../../services/models.dart';
import "result_box.dart";
import "dart:convert";
import "sentenza_object.dart";
import "package:path/path.dart" as path;
import 'package:flutter/material.dart';
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
    _tabController = TabController(length: 2, vsync: this);
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
              Tab(text: "Testo"),
              Tab(text: "Documento"),
            ],
          ),
          SizedBox(
            height: 1300,
            child: TabBarView(
              controller: _tabController,
              children: const [
                RicercaParoleChiave(),
                RicercaDocumento(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RicercaParoleChiave extends StatefulWidget {
  const RicercaParoleChiave({super.key});

  @override
  State<RicercaParoleChiave> createState() => _RicercaParoleChiaveState();
}

Future<List<Sentenza>> textSendButtonPressed(String text, String corte) async {
  List<Sentenza> sentenze = [];
  var result = await FirebaseFunctions.instance
      .httpsCallable("get_similar_sentences")
      .call(
    {
      "text": text,
      "corte": corte,
    },
  );
  var data = result.data;
  List<dynamic> dataList = jsonDecode(data);
  for (dynamic o in dataList) {
    sentenze.add(
      Sentenza(
        contenuto: o["contenuto"],
        corte: o["corte"],
        titolo: o["titolo"],
        distance: o["distance"],
      ),
    );
  }
  return sentenze;
}

class _RicercaParoleChiaveState extends State<RicercaParoleChiave> {
  final _textController = TextEditingController();

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
            submitIconButton(_textController.text, clearController: true),
          ],
        ),
        if (Provider.of<RicercaSentenzeProvider>(context, listen: true)
                .similarSentenze
                .isNotEmpty &&
            Provider.of<RicercaSentenzeProvider>(context, listen: true)
                    .isSearchingSentenze ==
                false)
          ResultBox(
              sentenze:
                  Provider.of<RicercaSentenzeProvider>(context, listen: true)
                      .similarSentenze),
        if (Provider.of<RicercaSentenzeProvider>(context, listen: true)
            .isSearchingSentenze)
          const Column(
            children: [
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          ),
      ],
    );
  }

  IconButton submitIconButton(String textToCompare,
      {bool clearController = false}) {
    return IconButton(
      icon: const Icon(Icons.send),
      style: ButtonStyle(iconSize: WidgetStateProperty.all(50)),
      tooltip: textToCompare.isNotEmpty
          ? 'Invia il testo'
          : 'Inserisci del testo per inviare',
      onPressed: textToCompare.isNotEmpty
          ? () async {
              Provider.of<RicercaSentenzeProvider>(context, listen: false)
                  .searchSentenze(
                      textToCompare,
                      Provider.of<RicercaSentenzeProvider>(context,
                              listen: false)
                          .corte);
              if (clearController == true) {
                setState(() {
                  _textController.clear();
                });
              }
            }
          : null,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
    var ricercaSentenzeProvider =
        Provider.of<RicercaSentenzeProvider>(context, listen: true);

    if (AuthService().isGuest()) {
      try {
        return loggedOutDocumento(context);
      } catch (e) {
        debugPrint("Error in RicercaDocumento: $e");
        return const Text("Errore nel caricamento dei documenti");
      }
    } else {
      return loggedInDocumento(ricercaSentenzeProvider);
    }
  }

  Column loggedInDocumento(RicercaSentenzeProvider ricercaSentenzeProvider) {
    return Column(
      children: [
        const TribunaleSelector(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PraticaSelector(),
            DocumentoSelector(),
          ],
        ),
        const SizedBox(height: 20),
        ricercaDocumentoSendButton(),
        if (ricercaSentenzeProvider.isSearchingSentenze)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: CircularProgressIndicator(),
          ),
        if (!ricercaSentenzeProvider.isSearchingSentenze &&
            ricercaSentenzeProvider.similarSentenze.isNotEmpty)
          ResultBox(sentenze: ricercaSentenzeProvider.similarSentenze),
      ],
    );
  }

  Column loggedOutDocumento(BuildContext context) {
    return Column(
      children: [
        const TribunaleSelector(),
        FileUploader(
            labelText: "Carica un documento",
            helperText: "Carica un documento per cercare sentenze simili.",
            buttonText: "Carica documento",
            onFileSelected: loggedOutFileSelected),
        if (Provider.of<RicercaSentenzeProvider>(context, listen: true)
                .isSearchingSentenze ==
            true)
          const CircularProgressIndicator()
        else if (Provider.of<RicercaSentenzeProvider>(context, listen: true)
            .similarSentenze
            .isNotEmpty)
          ResultBox(
              sentenze:
                  Provider.of<RicercaSentenzeProvider>(context, listen: true)
                      .similarSentenze),
      ],
    );
  }

  void loggedOutFileSelected(PlatformFile? file) async {
    if (file == null || file.bytes == null) {
      return;
    } else {
      var provider =
          Provider.of<RicercaSentenzeProvider>(context, listen: false);
      provider.isSearchingSentenze = true;
      try {
        String extension = path.extension(file.name);
        Uint8List data = file.bytes!;
        String text = TextExtractor().extractText(data, extension);
        await provider.searchSentenze(text, provider.corte);
      } catch (e) {
        debugPrint("Error in onFileSelected: $e");
        rethrow;
      } finally {
        provider.isSearchingSentenze = false;
      }
    }
  }

  SizedBox ricercaDocumentoSendButton() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        child: const Row(
          children: [
            Text("Cerca sentenze", style: TextStyle(color: Colors.white)),
            SizedBox(width: 10),
            Icon(Icons.send, color: Colors.white),
          ],
        ),
        onPressed: () async {
          var provider =
              Provider.of<RicercaSentenzeProvider>(context, listen: false);
          Documento documentoSelected = provider.selectedDocumento!;
          Pratica praticaSelected = provider.selectedPratica!;
          String summary = await DocumentStorage().getSummaryTextFromDocumento(
              documentoSelected.filename, praticaSelected.id);

          // Ensure UI updates are managed correctly
          provider.isSearchingSentenze = true;

          try {
            await provider.searchSentenze(summary, provider.corte);
          } finally {
            provider.isSearchingSentenze = false;
          }
        },
      ),
    );
  }
}

class PraticaSelector extends StatelessWidget {
  const PraticaSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RetrieveObjectFromDb().getPratiche(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text("Errore nel caricamento delle pratiche");
        } else {
          return DropdownSelector(
              preText: "Seleziona la pratica",
              snapshot: snapshot,
              dropDownValue:
                  Provider.of<RicercaSentenzeProvider>(context, listen: true)
                      .selectedPratica,
              onChangedAction: (value) {
                Provider.of<RicercaSentenzeProvider>(context, listen: false)
                    .setSelectedPratica(value as Pratica);
              },
              dropDownItems: [
                for (Pratica pratica in snapshot.data!)
                  DropdownMenuItem(
                    value: pratica,
                    child: Text(pratica.titolo),
                  )
              ]);
        }
      },
    );
  }
}

class DocumentoSelector extends StatelessWidget {
  const DocumentoSelector({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<RicercaSentenzeProvider>(context, listen: true)
            .selectedPratica ==
        null) {
      return const Text("Seleziona una pratica per visualizzare i documenti");
    } else {
      return FutureBuilder(
          future: RetrieveObjectFromDb().getDocumenti(
              Provider.of<RicercaSentenzeProvider>(context, listen: false)
                  .selectedPratica!
                  .id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(
                "Errore nel caricamento dei documenti: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              );
            } else {
              return DropdownSelector(
                  preText: "Seleziona il documento",
                  snapshot: snapshot,
                  dropDownValue: Provider.of<RicercaSentenzeProvider>(context,
                          listen: true)
                      .selectedDocumento,
                  onChangedAction: (value) {
                    Provider.of<RicercaSentenzeProvider>(context, listen: false)
                        .setSelectedDocumento(value as Documento);
                  },
                  dropDownItems: [
                    for (Documento documento in snapshot.data!)
                      DropdownMenuItem(
                        value: documento,
                        child: Text(documento.filename),
                      )
                  ]);
            }
          });
    }
  }
}

class DropdownSelector extends StatelessWidget {
  final String preText;
  final AsyncSnapshot<List<Object>> snapshot;
  final dynamic dropDownValue;
  final Function onChangedAction;
  final List<DropdownMenuItem<Object>> dropDownItems;
  const DropdownSelector({
    super.key,
    required this.preText,
    required this.snapshot,
    this.dropDownValue,
    required this.onChangedAction,
    required this.dropDownItems,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(preText),
        const SizedBox(width: 10),
        DropdownButton(
          focusColor: Colors.white,
          hint: Text(preText),
          value: dropDownValue,
          items: dropDownItems,
          onChanged: (value) => onChangedAction(value),
        )
      ],
    );
  }
}
