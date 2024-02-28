import 'package:flutter/material.dart';
import "package:lawli/dashboard/main_window.dart";
import "package:provider/provider.dart";
import "../../shared/shared.dart";
import "../../services/services.dart";

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget body(BuildContext context) {
    final userPraticaId = Provider.of<DashboardProvider>(context).idPratica;
    debugPrint("userPraticaId: $userPraticaId");
    if (userPraticaId == 0) {
      return const CasoIdZero();
    } else {
    return FutureBuilder<Pratica>(
        future: RetrieveObjectFromDb().getPratica(userPraticaId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Pratica pratica = snapshot.data!;
            return MainWindow(pratica: pratica);
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Container(
                padding: ResponsiveLayout.mainWindowPadding(context),
                child: Text(
                  "Errore: ${snapshot.error}",
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

class CasoIdZero extends StatelessWidget {
  const CasoIdZero({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Errore: nessuna pratica selezionata",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              const Text(
                "Seleziona una pratica dalla sezione pratiche",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        ),
      );
  }
}
