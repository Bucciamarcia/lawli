import "package:flutter/material.dart";
import "package:lawli/strumenti_gratis/calcolo_interessi_legali/models.dart";

/// The class that calculates the legal interest.
/// 
/// Uses a factory constructor to create an instance of the class: [create].
/// Initialize with `Calcolatore.create()` and then call the method run() to get the result.
class Calcolatore {
  final double initialCapital;
  final DateTime initialDate;
  final DateTime finalDate;
  final double capitalizzazione;
  TassoInteresseLegaleOperations? tassoInteresseLegaleOperations;

  Calcolatore({
    required this.initialCapital,
    required this.initialDate,
    required this.finalDate,
    required this.capitalizzazione,
    this.tassoInteresseLegaleOperations,
  });

  Future<TabellaInteressi> run() async {
    tassoInteresseLegaleOperations ??= TassoInteresseLegaleOperations();
    final tassi = await tassoInteresseLegaleOperations!.getTassiInteresseLegale();
    if (capitalizzazione == 0) {
      debugPrint("Starting no capitalizzazione");
      return _noCapitalizzazione();
    } else {
      return TabellaInteressi(
        riga: [],
        initialDate: initialDate,
        finalDate: finalDate,
        capitalizzazione: capitalizzazione,
        capitaleIniziale: 0,
        totaleGiorni: 0,
        totaleInteressi: 0,
      );
    }
  }

  TabellaInteressi _noCapitalizzazione() {
    return TabellaInteressi(
      riga: [],
      initialDate: initialDate,
      finalDate: finalDate,
      capitalizzazione: 0,
      capitaleIniziale: 0,
      totaleGiorni: 0,
      totaleInteressi: 0,
    );
  }
}

class TabellaInteressi {
  final List<RigaInteressi> riga;
  final double capitaleIniziale;
  final DateTime initialDate;
  final DateTime finalDate;
  final double capitalizzazione;
  final double totaleGiorni;
  final double totaleInteressi;

  TabellaInteressi({
    required this.riga,
    required this.capitaleIniziale,
    required this.initialDate,
    required this.finalDate,
    required this.capitalizzazione,
    required this.totaleGiorni,
    required this.totaleInteressi,
  });

  double get totaleDovuto => capitaleIniziale + totaleInteressi;
}

class RigaInteressi {
  final DateTime dataIniziale;
  final DateTime dataFinale;
  final double capitale;
  final double tasso;
  final double giorni;
  final double interessi;

  RigaInteressi({
    required this.dataIniziale,
    required this.dataFinale,
    required this.capitale,
    required this.tasso,
    required this.giorni,
    required this.interessi,
  });
}
