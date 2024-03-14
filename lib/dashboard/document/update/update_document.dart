import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../../../services/services.dart";
import '../../../shared/shared.dart';

class UpdateDocumentScreen extends StatelessWidget {
  const UpdateDocumentScreen({super.key});

  Scaffold body(BuildContext context) {
    final Pratica pratica = Provider.of<DashboardProvider>(context).pratica;
    final Documento documento = Provider.of<DashboardProvider>(context).documento;
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Column(
          children: [
            Text(
              "Pratica: ${pratica.id} - Documento: ${documento.filename}",
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