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
        body: Column(
      children: [
        dataTableExp(pratica, documento, context),
        Text("test")
      ],
    ));
  }

  dataTableExp(Pratica pratica, Documento documento, BuildContext context) {
    return DataTable(columns: const [
      DataColumn(
        label: Text("")
      ),
      DataColumn(label: Text("")),
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
      DataRow(cells:[
        const DataCell(Text("Descrizione")),
        DataCell(FutureBuilder<String>(
      future: getTextDocumentFuture(context, pratica, documento),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return SelectableText(snapshot.data ?? "Nessun testo disponibile");
        } else if (snapshot.hasError) {
          return Text("Errore nel caricamento della descrizione: ${snapshot.error}");
        } else {
          return const CircularProgressIndicator();
        }
      },
    )), 
      ]
      )
    ]);

    
  }

  Future<Widget> buildDescriptionCell(BuildContext context, Pratica pratica, Documento documento) async {
    // Handle loading and error state directly
    try {
      final descriptionText = await getTextDocumentFuture(context, pratica, documento);
      return Text(descriptionText);
    } catch (e) {
      return Text("Errore nel caricamento della descrizione: $e");
    }
  }
  

  Future<String> getTextDocumentFuture(
      BuildContext context, Pratica pratica, Documento documento) async {
    return StorageService()
        .getTextDocument(await textDocumentPath(context, pratica, documento));
  }

  Future<String> textDocumentPath(
      BuildContext context, Pratica pratica, Documento documento) async {
    String path = CloudStorageConstants().getRiassuntoPath(
        await AccountDb().getAccountName(),
        pratica.id.toString(),
        TransformDocumentName(documento.filename).getRootFilename());
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
