import 'package:flutter/material.dart';
import "../../shared/shared.dart";
import "../../services/services.dart";
import "motore_ricerca_sentenze.dart";

String infoBox = """La funzionalità ricerca sentenze è un motore di ricerca per sentenze di tribulale.
Puoi cercare sentenze di tribunale, appello o cassazione.
Puoi cercare per per testo (parola chiave, frase o paragrafo), per documento caricato o per pratica.

Nota che questa funzionalità NON è una ricerca per parola chiave: verranno restituite sentenze con un contesto simile a quello cercato. Quindi cercando "incidente stradale in autostrada", verranno restituite sentenze che parlano di incidenti stradali in autostrada, ma non necessariamente con queste parole. Se non ci sono abbastanza sentenze riguardanti incidenti in autostrada, verranno restituite sentenze che parlano di incidenti stradali in generale.

Allo stesso modo, se si cerca per documento o pratica, verranno restituite le sentenze più simili al documento o pratica selezionata, ossia con un contesto simile.

Questa funzionalità è più utile di una ricerca per parola chiave, perché permette di trovare sentenze simili a quanto cercato, anche se non contengono le parole esatte cercate.""";


class RicercaSentenzeScreen extends StatelessWidget {
  const RicercaSentenzeScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.topCenter,
          padding: ResponsiveLayout.mainWindowPadding(context),
          child: ListView(
            padding: const EdgeInsets.only(left: 50, right: 150),
            children: [
              const SizedBox(height: 20),
              InfoBox(
              text: infoBox,
              ),
              const SizedBox(height: 20),
              const MotoreRicercaSentenze()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Ricerca sentenze"),
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

class InfoBox extends StatelessWidget {
  final String text;
  const InfoBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColorLight, width: 3),
          borderRadius: BorderRadius.circular(20)),
      child: Text(text),
    );
  }
}
