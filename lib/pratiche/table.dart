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
          // Convert your list of Pratica to List<DataRow>
          List<DataRow> dataRows =
              snapshot.data!.map<DataRow>((Pratica pratica) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(pratica.titolo)),
                DataCell(Text(pratica.descrizione)),
                DataCell(Text(pratica.assistitoId.toString())),
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
                                titolo: pratica.titolo,
                                descrizione: pratica.descrizione)
                            .showConfirmPopup(context);
                      },
                    ),
                  ],
                )),
              ],
            );
          }).toList();

          // Return your DataTable or whatever widget you're populating
          return DataTable(rows: dataRows, columns: TableData().dataColumns);
        }
      },
    );
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
      label: Text("ID Assistito"),
    ),
    DataColumn(label: Text("Azioni"))
  ];
}
