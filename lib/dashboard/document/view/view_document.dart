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
    final Documento documento =
        Provider.of<DashboardProvider>(context).documento;
    return Scaffold(
        body: DataTable2(columns: const [
      DataColumn2(
        label: Text("Campo"),
        size: ColumnSize.S,
      ),
      DataColumn(label: Text("Valore")),
    ], rows: [
      DataRow(cells: [
        const DataCell(Text("Pratica")),
        DataCell(Text(pratica.titolo.toString()))
      ]),
      DataRow(cells: [
        const DataCell(Text("Documento")),
        DataCell(Text(documento.filename.toString()))
      ]),
      DataRow(cells: [
        const DataCell(Text("Data")),
        DataCell(Text(documento.data.toString()))
      ]),
      DataRow(cells: [
        const DataCell(Text("Descrizione breve")),
        DataCell(Text(documento.brief_description.toString()))
      ]),
      DataRow(cells: [
        const DataCell(Text("Descrizione")),
        DataCell(FutureBuilder<String>(
          future: getTextDocumentFuture(context, pratica, documento),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(snapshot.data.toString());
            } else if (snapshot.hasError) {
              return Text("Errore: ${snapshot.error}");
            } else {
              return const CircularProgressIndicator();
            }
          },
        )),
      ]),
    ]));
  }

  Future<String> getTextDocumentFuture(
      BuildContext context, Pratica pratica, Documento documento) async {
    return StorageService().getTextDocument(
        await textDocumentPath(context, pratica, documento));
  }

  String textDocumentFilename(Documento documento) {
      String filename = TransformDocumentName(documento.filename).getTxtVersion();
      debugPrint("FILENAME: $filename");
      return filename;
  }

  Future<String> textDocumentPath(
      BuildContext context, Pratica pratica, Documento documento) async {
    String path = CloudStorageConstants().getRiassuntoPath(
        await AccountDb().getAccountName(),
        pratica.id.toString(),
        TransformDocumentName(documento.filename).getRootFilename());
    debugPrint("PATH: $path");
    return path;
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
