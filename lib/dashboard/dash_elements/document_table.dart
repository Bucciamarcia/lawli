import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../services/firestore.dart';
import '../../services/models.dart';

class DocumentTable extends StatelessWidget {
  final Pratica pratica;
  const DocumentTable({super.key, required this.pratica});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Documento>>(
      future: RetrieveObjectFromDb().getDocumenti(pratica.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Documento> documenti = snapshot.data!;
          List<String> documentiFilename =
              documenti.map((doc) => doc.filename).toList();
          List<String> documentiBriefDescription =
              documenti.map((doc) => doc.brief_description).toList();
          List<DateTime> documentiData =
              documenti.map((doc) => doc.data).toList();
          return DataTableEntry(
              documenti: documenti,
              documentiFilename: documentiFilename,
              documentiData: documentiData,
              documentiBriefDescription: documentiBriefDescription);
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class DataTableEntry extends StatelessWidget {
  const DataTableEntry({
    super.key,
    required this.documenti,
    required this.documentiFilename,
    required this.documentiData,
    required this.documentiBriefDescription,
  });

  final List<Documento> documenti;
  final List<String> documentiFilename;
  final List<DateTime> documentiData;
  final List<String> documentiBriefDescription;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columns: const [
        DataColumn2(label: Text('Filename')),
        DataColumn2(label: Text('Data')),
        DataColumn2(label: Text('Descrizione')),
        DataColumn2(label: Text('Azioni')),
      ],
      rows: List<DataRow>.generate(
          documenti.length,
          (index) => DataRow(
                cells: [
                  DataCell(Text(documentiFilename[index])),
                  DataCell(Text(documentiData[index].toString())),
                  DataCell(Text(documentiBriefDescription[index])),
                  DataCell(Row(children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      tooltip: "Modifica",
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                      tooltip: "Elimina",
                    ),
                  ]))
                ],
              )),
    );
  }
}
