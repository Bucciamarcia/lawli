import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import "../../shared/shared.dart";
import "../../services/services.dart";

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget body(BuildContext context) {
    final userPraticaId = Provider.of<DashboardProvider>(context).idPratica;
    debugPrint("userPraticaId: $userPraticaId");
    return FutureBuilder<Pratica>(
        future: RetrieveObjectFromDb().getPratica(userPraticaId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Pratica pratica = snapshot.data!;
            return Scaffold(
                body: Container(
              padding: ResponsiveLayout.mainWindowPadding(context),
              child: Text(
                pratica.titolo,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ));
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Container(
                padding: ResponsiveLayout.mainWindowPadding(context),
                child: Text(
                  "Error loading data",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Container(
                padding: ResponsiveLayout.mainWindowPadding(context),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Dashboard"),
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
