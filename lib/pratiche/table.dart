import "package:flutter/material.dart";
import "package:lawli/services/services.dart";

import "bottone_cancella.dart";
import "modifica/modifica.dart";

class PraticheTable extends StatefulWidget {
  const PraticheTable({super.key});

  @override
  State<PraticheTable> createState() => _PraticheTableState();
}

class _PraticheTableState extends State<PraticheTable> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BuildTable(),
    );
  }
}

class BuildTable extends StatelessWidget {
  const BuildTable({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pratica>>(
      future: RetrieveObjectFromDb().getPratiche(), // Your future here
      builder: (BuildContext context, AsyncSnapshot<List<Pratica>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return FutureBuilder<String>(
              // Nested FutureBuilder for nomeCompleto
              future: getNomeCompleto(snapshot),
              builder: (context, nomeCompletoSnapshot) {
                if (nomeCompletoSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Handle waiting for name
                } else if (nomeCompletoSnapshot.hasError) {
                  return const Text(
                      "Error retrieving name"); // Handle name retrieval errors
                } else {
                  // Build your rows using nomeCompletoSnapshot.data!
                  List<DataRow> dataRows =
                      snapshot.data!.map<DataRow>((Pratica pratica) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(pratica.titolo)),
                        DataCell(Text(pratica.descrizione)),
                        DataCell(Text(nomeCompletoSnapshot
                            .data!)), // Access the retrieved name
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: "Modifica",
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ModificaPraticaScreen(pratica: pratica),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: "Cancella",
                              onPressed: () {
                                BottoneCancellaPratica(
                                        praticaId: pratica.id,
                                        titolo: pratica.titolo)
                                    .showConfirmPopup(context);
                              },
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList();

                  return DataTable(
                      rows: dataRows, columns: TableData().dataColumns);
                }
              });
        }
      },
    );
  }

  Future<String> getNomeCompleto(AsyncSnapshot<List<Pratica>> snapshot) async {
    // Made async
    final assistito = await RetrieveObjectFromDb().getAssistito(
        snapshot.data!.first.assistitoId.toString()); // await keyword added
    return assistito.nomeCompleto;
  }
}

class TableData {
  List<DataColumn> dataColumns = const <DataColumn>[
    DataColumn(
      label: Text("Titolo"),
    ),
    DataColumn(
      label: Text("Descrizione"),
    ),
    DataColumn(
      label: Text("Assistito"),
    ),
    DataColumn(label: Text("Azioni"))
  ];
}
