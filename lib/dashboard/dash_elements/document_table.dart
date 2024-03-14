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
          List<String> documentiFilename = documenti.map((doc) => doc.filename).toList();
          List<String> documentiBriefDescription = documenti.map((doc) => doc.brief_description).toList();
          List<DateTime> documentiData = documenti.map((doc) => doc.data).toList();
          return DataTable2(
            columns: const [
              DataColumn2(label: Text('Filename')),
              DataColumn2(label: Text('Data')),
              DataColumn2(label: Text('Descrizione')),
            ],
            rows: List<DataRow>.generate(documenti.length, (index) => DataRow(
              cells: [
                DataCell(Text(documentiFilename[index])),
                DataCell(Text(documentiData[index].toString())),
                DataCell(Text(documentiBriefDescription[index])),
              ],
            )),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
