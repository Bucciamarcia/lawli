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
    if (capitalizzazione == 0) {
      return await NoCapitalizzazione(
        initialCapital: initialCapital,
        initialDate: initialDate,
        finalDate: finalDate,
        capitalizzazione: capitalizzazione,
        tassoInteresseLegaleOperations: tassoInteresseLegaleOperations,
      ).calculate();
    } else {
      return TabellaInteressi(
        righe: [],
        initialDate: initialDate,
        finalDate: finalDate,
        capitalizzazione: capitalizzazione,
        capitaleIniziale: 0,
      );
    }
  }

  /// Returns a list of years between the initial and final date (included).
  List<int> getAnni() {
    List<int> anni = [];
    for (int i = initialDate.year; i <= finalDate.year; i++) {
      anni.add(i);
    }
    return anni;
  }
}

class NoCapitalizzazione extends Calcolatore {
  NoCapitalizzazione(
      {required super.initialCapital,
      required super.initialDate,
      required super.finalDate,
      required super.capitalizzazione,
      required super.tassoInteresseLegaleOperations});

  Future<TabellaInteressi> calculate() async {
    // Get all the legal interest rates from the Database.
    final List<TassoInteresseLegale> tassi =
        await tassoInteresseLegaleOperations!.getTassiInteresseLegale();
    int currentIndex =
        tassi.indexWhere((element) => element.fine.isAfter(initialDate));
    // The front end should have checked that the date is in range.
    if (currentIndex == -1) {
      throw Exception(
          "Error in calculate NoCapitalizzazione: startIndex not found");
    }
    List<RigaInteressi> righe = [];

    while (true) {
      // Fetch the interest rate for the current period.
      TassoInteresseLegale tassoCorrente = tassi[currentIndex];
      // Get the LATTEST date between the initial date and the start of the period.
      DateTime initialPeriodDate = initialDate.isAfter(tassoCorrente.inizio)
          ? initialDate
          : tassoCorrente.inizio;
      // Get the EARLIEST date between the final date and the end of the period.
      DateTime finalPeriodDate = tassoCorrente.fine.isBefore(finalDate)
          ? tassoCorrente.fine
          : finalDate;

      int days = _countDays(finalPeriodDate, initialPeriodDate);
/*    If the period starts on the initial date, add one day.
      This is because the interest is calculated on the day of the start, so the first day is included. */
      if (initialPeriodDate == tassoCorrente.inizio) {
        days++;
      }

      // The formula for calculating the interest is: (capital * interest rate * days) / 36500
      double interessi =
          initialCapital * tassoCorrente.interesse * days / 36500;
      interessi = double.parse(interessi.toStringAsFixed(2));

      // Add the row to the table.
      righe.add(
        RigaInteressi(
            capitale: initialCapital,
            dataIniziale: initialPeriodDate,
            dataFinale: finalPeriodDate,
            giorni: days,
            interessi: interessi,
            tasso: tassoCorrente.interesse),
      );
      currentIndex++;
      if (finalDate.isBefore(tassoCorrente.fine) ||
          currentIndex == tassi.length - 1) {
        break;
      }
    }

    return TabellaInteressi(
      righe: righe,
      initialDate: initialDate,
      finalDate: finalDate,
      capitalizzazione: capitalizzazione,
      capitaleIniziale: initialCapital,
    );
  }

  int _countDays(DateTime date1, DateTime date2) {
    Duration difference = date1.difference(date2);
    int days = difference.inDays.abs();
    return days;
  }
}

/// Contains the result table of the calculation.
/// For use in the UI.
class TabellaInteressi {
  final List<RigaInteressi> righe;
  final double capitaleIniziale;
  final DateTime initialDate;
  final DateTime finalDate;
  final double capitalizzazione;

  TabellaInteressi({
    required this.righe,
    required this.capitaleIniziale,
    required this.initialDate,
    required this.finalDate,
    required this.capitalizzazione,
  });

  /// Returns the total number of days in the table.
  /// This is the sum of the days of each row.
  int get totaleGiorni {
    int totale = 0;
    for (var riga in righe) {
      totale += riga.giorni;
    }
    return totale;
  }

  /// Returns the total interest in the table.
  /// This is the sum of the interest of each row.
  double get totaleInteressi {
    double totale = 0;
    for (var riga in righe) {
      totale += riga.interessi;
    }
    return totale;
  }

  /// Returns the total amount due.
  /// This is the sum of the initial capital and the total interest.
  double get totaleDovuto => capitaleIniziale + totaleInteressi;
}

/// The single line of the result table.
/// For use in the UI.
class RigaInteressi {
  final DateTime dataIniziale;
  final DateTime dataFinale;
  final double capitale;
  final double tasso;
  final int giorni;
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
