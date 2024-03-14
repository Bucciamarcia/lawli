import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../../../services/services.dart";
import '../../../shared/shared.dart';

class UpdateDocumentScreen extends StatelessWidget {
  const UpdateDocumentScreen({super.key});

  Scaffold body(BuildContext context) {
    final praticaId = Provider.of<DashboardProvider>(context).idPratica;
    final documentId = Provider.of<DashboardProvider>(context).idDocument;
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Column(
          children: [
            Text(
              "Pratica: ${praticaId} - Documento: ${documentId}",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
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