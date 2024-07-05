import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/services.dart';

class DocumentTable extends StatelessWidget {
  final Pratica pratica;
  const DocumentTable({super.key, required this.pratica});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Documento>>(
      stream: RetrieveObjectFromDb().streamDocumenti(pratica.id),
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
              documentiBriefDescription: documentiBriefDescription,
              pratica: pratica);
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
    required this.pratica,
    required this.documenti,
    required this.documentiFilename,
    required this.documentiData,
    required this.documentiBriefDescription,
  });

  final Pratica pratica;
  final List<Documento> documenti;
  final List<String> documentiFilename;
  final List<DateTime> documentiData;
  final List<String> documentiBriefDescription;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columns: const [
        DataColumn2(label: Text('Filename'), size: ColumnSize.L),
        DataColumn2(label: Text('Data')),
        DataColumn2(label: Text('Descrizione'), size: ColumnSize.L),
        DataColumn2(label: Text('Azioni')),
      ],
      rows: List<DataRow>.generate(
          documenti.length,
          (index) {
            String docId = documenti[index].filename;
            return DataRow(
              cells: [
                DataCell(Text(documentiFilename[index])),
                DataCell(Text(documentiData[index].toString())),
                DataCell(Text(documentiBriefDescription[index])),
                DataCell(Row(children: [
                  IconButton(
                    onPressed: () async {
                      Documento documento = await RetrieveObjectFromDb().getDocumento(pratica.id, docId);
                      Provider.of<DashboardProvider>(context, listen: false)
                                .setDocumento(documento);
                      Provider.of<DashboardProvider>(context, listen: false)
                                .setPratica(pratica);
                            debugPrint(pratica.id.toString());
                      Navigator.pushNamed(context, "/dashboard/document/update");
                    },
                    icon: const Icon(Icons.edit),
                    tooltip: "Modifica",
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      DocumentoDb().deleteDocumentFromPraticaid(
                          pratica.id, docId);
                    },
                    icon: const Icon(Icons.delete),
                    tooltip: "Elimina",
                  ),
                ]))
              ],
            );
          }),
    );
  }
}
