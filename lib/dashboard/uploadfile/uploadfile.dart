import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import "../../shared/shared.dart";
import "../../services/services.dart";
import "widgets.dart";

class UploadFileScreen extends StatelessWidget {
  const UploadFileScreen({super.key});

  Scaffold body(BuildContext context) {
    final double idPratica = context.watch<DashboardProvider>().idPratica;
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Text(
                "Aggiungi documento alla pratica",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FormData(idPratica: idPratica),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Get idPratica from Provider
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Aggiungi documento"),
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
