import "sentenza_object.dart";
import "package:flutter/services.dart";
import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  final List<Sentenza> sentenze;

  const ResultBox({super.key, required this.sentenze});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: ListView.builder(
          itemCount: sentenze.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final Sentenza sentenza = sentenze[index];
            return Card(
              elevation: 5,
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        sentenza.titolo,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(sentenza.corte, textAlign: TextAlign.end),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Punteggio di similarità: ${similarityPercentage(sentenza.distance)}%"),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.open_in_new_rounded),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(sentenza.titolo),
                            content: SingleChildScrollView(
                              child: SelectableText(sentenza.contenuto),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Chiudi"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: sentenza.contenuto));
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Testo copiato"),
                                          content: const Text(
                                              "Il testo è stato copiato negli appunti."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Chiudi"),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: const Text("Copia"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            );
          },
        ));
  }

  // Returns a % score of similarity, approximated to 2 decimal places
  double similarityPercentage(double distance) {
    double score = 1 - distance;
    return (score * 10000).roundToDouble() / 100;
  }
}