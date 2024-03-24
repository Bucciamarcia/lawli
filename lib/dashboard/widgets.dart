import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lawli/dashboard/dash_elements/document_table.dart';
import 'package:lawli/services/services.dart';
import 'package:provider/provider.dart';
import '../services/cloud_storage.dart';

class ExpandableOverview extends StatefulWidget {
  const ExpandableOverview({super.key});

  @override
  State<ExpandableOverview> createState() => _ExpandableOverviewState();
}

class _ExpandableOverviewState extends State<ExpandableOverview> {
  bool _showCheckmark = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("La causa in breve",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              )),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 800,
              child: Center(
                child: FutureBuilder(
                  future: DocumentStorage().getTextDocument(
                      "accounts/${Provider.of<DashboardProvider>(context, listen: false).accountName}/pratiche/${Provider.of<DashboardProvider>(context, listen: false).idPratica}/riassunto generale.txt"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          "Errore nel caricamento del riassunto generale");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Text("Caricamento in corso...");
                    } else {
                      if (snapshot.data == null) {
                        return const Text("Nessun riassunto generale presente");
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ExpandableText(
                                snapshot.data!,
                                expandText: "Leggi di più",
                                collapseText: "Leggi di meno",
                                maxLines: 10,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: snapshot.data!),
                                );
                                setState(() {
                                  _showCheckmark = true;
                                });
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    _showCheckmark = false;
                                  });
                                });
                              },
                              icon: _showCheckmark == true
                                  ? const FaIcon(FontAwesomeIcons.check)
                                  : const FaIcon(FontAwesomeIcons.copy),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(5)),
                                  iconColor: MaterialStateProperty.all(
                                      Colors.blueAccent[400])),
                              tooltip: "Copia il testo",
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Documenti extends StatelessWidget {
  final Pratica pratica;
  const Documenti({super.key, required this.pratica});

  @override
  Widget build(BuildContext context) {
    final String accountName =
        Provider.of<DashboardProvider>(context, listen: false).accountName;
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Documenti", style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  // Upload new document button
                  child: DocumentiWidgetThreeButtons(
                      context: context,
                      onPressed: () =>
                          Navigator.pushNamed(context, "/dashboard/uploadfile"),
                      backgroundColor: Colors.lightBlue[700],
                      text: "Nuovo Documento",
                      textColor: Colors.white),
                ),
                // Recreate summary button
                DocumentiWidgetThreeButtons(
                    context: context,
                    onPressed: () async {
                      final List<Documento> docsForSummary =
                          await RetrieveObjectFromDb().getDocumenti(pratica.id);
                      final List<Documento> orderedDocs = DocumentManipulation()
                          .orderDocumentByDate(docsForSummary);
                      List<String> summaries = [];
                      for (Documento doc in orderedDocs) {
                        summaries.add(
                            await DocumentStorage(accountName: accountName)
                                .getSummaryTextFromDocumento(
                                    doc.filename, pratica.id));
                      }
                      try {
                        await FirebaseFunctions.instance
                            .httpsCallable("create_general_summary")
                            .call({
                          "partialSummarties": summaries,
                          "praticaId": pratica.id.toString(),
                          "accountName": accountName,
                        });
                      } catch (e) {
                        debugPrint(
                            "Errore nella creazione del riassunto generale: $e");
                      }
                    },
                    backgroundColor: Colors.grey,
                    text: "Ricrea Riassunto",
                    textColor: Colors.white),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  // Recreate timeline button
                  child: DocumentiWidgetThreeButtons(
                      context: context,
                      onPressed: () {},
                      backgroundColor: Colors.teal,
                      text: "Ricrea timeline",
                      textColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: DocumentTable(pratica: pratica),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentiWidgetThreeButtons extends StatelessWidget {
  const DocumentiWidgetThreeButtons({
    super.key,
    required this.context,
    required this.onPressed,
    required this.backgroundColor,
    required this.text,
    required this.textColor,
  });

  final BuildContext context;
  final dynamic onPressed;
  final dynamic backgroundColor;
  final String text;
  final dynamic textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
          ),
      child: Text(
        text,
        style:
            Theme.of(context).textTheme.labelSmall?.copyWith(color: textColor),
      ),
    );
  }
}

class ChatBot extends StatefulWidget {
  final Pratica pratica;
  const ChatBot({super.key, required this.pratica});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return const Expanded(child: Placeholder());
  }
}
