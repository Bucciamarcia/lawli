import "package:flutter/material.dart";
import "package:lawli/services/services.dart";
import "package:provider/provider.dart";

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
      future: RetrieveObjectFromDb().getPratiche(),
      builder: (BuildContext context, AsyncSnapshot<List<Pratica>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<DataRow> dataRows = snapshot.data!.map<DataRow>((Pratica pratica) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(pratica.titolo)),
                DataCell(Text(pratica.descrizione)),
                DataCell(
                  FutureBuilder<String>(
                    future: getNomeCompleto(pratica),
                    builder: (context, nomeCompletoSnapshot) {
                      if (nomeCompletoSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (nomeCompletoSnapshot.hasError) {
                        return const Text("Error retrieving name");
                      } else {
                        return Text(nomeCompletoSnapshot.data!);
                      }
                    },
                  ),
                ),
                DataCell(ElevatedButton(
                  onPressed: () async {
                    Provider.of<DashboardProvider>(context, listen: false)
                        .setIdPratica(pratica.id);
                    Provider.of<DashboardProvider>(context, listen: false)
                        .setPratica(pratica);
                    debugPrint(pratica.id.toString());
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/dashboard", (route) => false);
                  },
                  child: const Text("Apri"),
                )),
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
                                praticaId: pratica.id, titolo: pratica.titolo)
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
      },
    );
  }

  Future<String> getNomeCompleto(Pratica pratica) async {
    final assistito = await RetrieveObjectFromDb()
        .getAssistito(pratica.assistitoId.toString());
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
    DataColumn(label: Text("Apri")),
    DataColumn(label: Text("Azioni"))
  ];
}
