import 'dart:async';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lawli/dashboard/dash_elements/document_table.dart';
import 'package:lawli/services/services.dart';
import 'package:provider/provider.dart';
import '../services/cloud_storage.dart';

class ExpandableOverview extends StatelessWidget {
  const ExpandableOverview({super.key});

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
                            CopyIcon(
                              textToCopy: snapshot.data!,
                              onCopy: () {
                              },
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

class CopyIcon extends StatefulWidget {
  final String textToCopy;
  final Function onCopy;

  const CopyIcon({super.key, required this.textToCopy, required this.onCopy});

  @override
  State<CopyIcon> createState() => _CopyIconState();
}

class _CopyIconState extends State<CopyIcon> {
  bool _showCheckmark = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: widget.textToCopy));
        setState(() {
          _showCheckmark = true;
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            _showCheckmark = false;
          });
        });
        widget.onCopy();
      },
      icon: _showCheckmark == true
          ? const FaIcon(FontAwesomeIcons.check)
          : const FaIcon(FontAwesomeIcons.copy),
      color: _showCheckmark == true ? Colors.greenAccent[400] : Colors.blueAccent[400],
      tooltip: _showCheckmark == true ? "Testo copiato" : "Copia il testo",
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
                      onPressed: () async {
                        try {
                          var result = await FirebaseFunctions.instance
                              .httpsCallable("generate_timeline")
                              .call({
                              "accountName": accountName,
                              "praticaId": pratica.id.toString(),
                          });
                          debugPrint("DATA: ${result.data}");
                          debugPrint("Extracting new timeline");
                          var newTimeline = jsonDecode(result.data);
                          debugPrint("Updating timeline");
                          await updateTimeline(newTimeline, accountName, pratica.id);
                          debugPrint("Timeline updated");
                        } catch (e) {
                          debugPrint("Errore nella creazione della timeline: $e");
                        }
                      },
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
  Future<void> updateTimeline(newTimeline, String accountName, double praticaId) async {
    final path = "accounts/$accountName/pratiche/$praticaId";
    const fileName = "timeline.json";
    DocumentStorage().uploadJson(path, fileName, newTimeline);
  }
}

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Timeline",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: DocumentStorage().getJson(
                "accounts/${Provider.of<DashboardProvider>(context, listen: false).accountName}/pratiche/${Provider.of<DashboardProvider>(context, listen: false).idPratica}",
                "timeline.json",
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Errore nel caricamento della cronologia");
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.data == null) {
                    return const Text("Nessuna cronologia presente");
                  } else {
                    List timeline = snapshot.data!['timeline'];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: timeline.length,
                      itemBuilder: (context, index) {
                        final event = timeline[index];
                        return TimelineEventWidget(
                          date: event['data'],
                          event: event['evento'],
                          isLast: index == timeline.length - 1,
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineEventWidget extends StatelessWidget {
  final String date;
  final String event;
  final bool isLast;

  const TimelineEventWidget({
    super.key,
    required this.date,
    required this.event,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.blue.withOpacity(0.6),
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
