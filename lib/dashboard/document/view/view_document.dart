import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lawli/services/cloud_storage.dart';
import 'package:provider/provider.dart';
import "../../../services/services.dart";
import '../../../shared/shared.dart';

class ViewDocumentScreen extends StatelessWidget {
  const ViewDocumentScreen({super.key});

  Scaffold body(BuildContext context) {
    final Pratica pratica = Provider.of<DashboardProvider>(context).pratica;
    final Documento documento = Provider.of<DashboardProvider>(context).documento;
    final String accountName = Provider.of<DashboardProvider>(context).accountName;
    return Scaffold(
      body: DataTable2(
        columns: const [
          DataColumn2(
            label: Text("Campo"),
            size: ColumnSize.S,
          ),
          DataColumn(label: Text("Valore")),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text("Pratica")),
              DataCell(Text(pratica.titolo.toString()))
            ]
          ),
          DataRow(
            cells: [
              const DataCell(Text("Documento")),
              DataCell(Text(documento.filename.toString()))
            ]
          ),
          DataRow(
            cells: [
              const DataCell(Text("Data")),
              DataCell(Text(documento.data.toString()))
            ]
          ),
          DataRow(
            cells: [
              const DataCell(Text("Descrizione breve")),
              DataCell(Text(documento.brief_description.toString()))
            ]
          ),
          DataRow(
            cells: [
              const DataCell(Text("Descrizione")),
              DataCell(
                FutureBuilder<String>(
                  future: StorageService().getTextDocument(
                    CloudStorageConstants().getRiassuntoPath(
                      Provider.of<DashboardProvider>(context).accountName,
                      pratica.id.toString(),
                      TransformDocumentName(documento.filename).getRootFilename()
                    ),
                    TransformDocumentName(documento.filename).getTxtVersion()
                  ),
                  builder:(context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      debugPrint("ACCOUNT NAME: $accountName");
                      return Text(snapshot.data.toString());
                    } else if (snapshot.hasError) {
                      return Text("Errore: ${snapshot.error}");
                    } else {
                      return const CircularProgressIndicator();
                    }

                  },
                )
              ),
            ]
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Assistiti"),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return DesktopVersion(body: body(context), appBar: appBar(context));
        } else {
          return MobileVersion(body: body(context), appBar: appBar(context));
        }
      },
    );
  }
}