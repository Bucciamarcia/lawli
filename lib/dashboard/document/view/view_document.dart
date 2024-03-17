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
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "Riassunto del documento",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          SizedBox(
            height: 300,
            child: Row(
              children: [
                dataTableExp(pratica, documento, context),
                const SizedBox(
                  width: 20,
                ),
                riassuntoContainer(context, pratica, documento),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Flexible riassuntoContainer(
      BuildContext context, Pratica pratica, Documento documento) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<String>(
          future: getTextDocumentFuture(context, pratica, documento),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return SelectableText(
                  snapshot.data ?? "Nessun testo disponibile");
            } else if (snapshot.hasError) {
              return Text(
                  "Errore nel caricamento della descrizione: ${snapshot.error}");
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  // Everything below this is about the table at the top

  dataTableExp(Pratica pratica, Documento documento, BuildContext context) {
    String urlDocumento = StorageService().getOriginalDocumentUrl(
        documento.filename, pratica.id, Provider.of<DashboardProvider>(context).accountName);
    debugPrint("URL DOCUMENTO: $urlDocumento");
    return DataTable(columns: const [
      DataColumn(label: Text("")),
      DataColumn(label: Text("")),
    ], rows: [
      DataRow(cells: [
        const DataCell(Text("Pratica")),
        DataCell(SelectableText(pratica.titolo.toString()))
      ]),
      DataRow(cells: [
        const DataCell(Text("Documento")),
        DataCell(SelectableText(documento.filename.toString()))
      ]),
      DataRow(cells: [
        const DataCell(Text("Data")),
        DataCell(SelectableText(documento.data.toString()))
      ]),
      DataRow(cells: [
        const DataCell(Text("Descrizione breve")),
        DataCell(SelectableText(documento.brief_description.toString()))
      ]),
    ]);
  }

  Future<Widget> buildDescriptionCell(
      BuildContext context, Pratica pratica, Documento documento) async {
    // Handle loading and error state directly
    try {
      final descriptionText =
          await getTextDocumentFuture(context, pratica, documento);
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
        title: const Text("Dettagli del documento"),
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
