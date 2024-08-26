import "package:flutter_test/flutter_test.dart";
import "package:lawli/strumenti_gratis/calcolo_interessi_legali/calcolatore.dart";
import "package:lawli/strumenti_gratis/calcolo_interessi_legali/models.dart";
import "package:mockito/mockito.dart";
import "package:mockito/annotations.dart";

import "capitalizzazione_test.mocks.dart";

@GenerateMocks([TassoInteresseLegaleOperations])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("Tests the calculator of the tool calcolo interessi legali", () {
    late MockTassoInteresseLegaleOperations mockTassoInteresseLegale;

    setUp(() {
      mockTassoInteresseLegale = MockTassoInteresseLegaleOperations();
    });

    test("Tests random mocktassi to ensure initialization", () {
      expect(mockTassi.length, 22);
      expect(mockTassi[0].interesse, 5.0);
      expect(mockTassi[0].norma, "Art. 1284 cod.civ.");
      expect(mockTassi[1].interesse, 10.0);
      expect(mockTassi[1].norma, "L. 353/90 e L.408/90");
    });

    group(
      "No capitalizzazione tests",
      () {
        test(
          "2005 a 2012",
          () async {
            when(mockTassoInteresseLegale.getTassiInteresseLegale())
                .thenAnswer((_) async => mockTassi);

            Calcolatore calcolatore = Calcolatore(
              initialCapital: 100000,
              initialDate: DateTime(2005, 05, 20),
              finalDate: DateTime(2012, 03, 08),
              capitalizzazione: 0,
              tassoInteresseLegaleOperations: mockTassoInteresseLegale,
            );

            TabellaInteressi run = await calcolatore.run();

            expect(run.righe.length, 5);
            expect(run.capitaleIniziale, 100000);
            expect(run.initialDate, DateTime(2005, 05, 20));
            expect(run.finalDate, DateTime(2012, 03, 08));
            expect(run.capitalizzazione, 0);
            expect(run.righe[0].dataIniziale, DateTime(2005, 05, 20));
            expect(run.righe[0].dataFinale, DateTime(2007, 12, 31));
            expect(run.righe[0].capitale, 100000);
            expect(run.righe[0].tasso, 2.5);
            expect(run.righe[0].giorni, 955);
            expect(run.righe[0].interessi, 6541.10);
            expect(run.righe[1].dataIniziale, DateTime(2008, 1, 1));
            expect(run.righe[1].dataFinale, DateTime(2009, 12, 31));
            expect(run.righe[1].capitale, 100000);
            expect(run.righe[1].tasso, 3);
            expect(run.righe[1].giorni, 731);
            expect(run.righe[1].interessi, 6008.22);
            expect(run.righe[2].dataIniziale, DateTime(2010, 01, 01));
            expect(run.righe[2].dataFinale, DateTime(2010, 12, 31));
            expect(run.righe[2].capitale, 100000);
            expect(run.righe[2].tasso, 1);
            expect(run.righe[2].giorni, 365);
            expect(run.righe[2].interessi, 1000);
            expect(run.righe[3].dataIniziale, DateTime(2011, 01, 01));
            expect(run.righe[3].dataFinale, DateTime(2011, 12, 31));
            expect(run.righe[3].capitale, 100000);
            expect(run.righe[3].tasso, 1.5);
            expect(run.righe[3].giorni, 365);
            expect(run.righe[3].interessi, 1500);
            expect(run.righe[4].dataIniziale, DateTime(2012, 01, 01));
            expect(run.righe[4].dataFinale, DateTime(2012, 03, 08));
            expect(run.righe[4].capitale, 100000);
            expect(run.righe[4].tasso, 2.5);
            expect(run.righe[4].giorni, 68);
            expect(run.righe[4].interessi, 465.75);
            expect(run.totaleGiorni, 2484);
            expect(run.totaleInteressi, 15515.07);
            expect(run.totaleDovuto, 115515.07);
          },
        );
        test(
          "Stesso anno 2012",
          () async {
            when(mockTassoInteresseLegale.getTassiInteresseLegale())
                .thenAnswer((_) async => mockTassi);

            Calcolatore calcolatore = Calcolatore(
              initialCapital: 100000,
              initialDate: DateTime(2012, 05, 20),
              finalDate: DateTime(2012, 09, 23),
              capitalizzazione: 0,
              tassoInteresseLegaleOperations: mockTassoInteresseLegale,
            );

            TabellaInteressi run = await calcolatore.run();

            expect(run.righe.length, 1);
            expect(run.capitaleIniziale, 100000);
            expect(run.initialDate, DateTime(2012, 05, 20));
            expect(run.finalDate, DateTime(2012, 09, 23));
            expect(run.capitalizzazione, 0);
            expect(run.righe[0].dataIniziale, DateTime(2012, 05, 20));
            expect(run.righe[0].dataFinale, DateTime(2012, 09, 23));
            expect(run.righe[0].capitale, 100000);
            expect(run.righe[0].tasso, 2.5);
            expect(run.righe[0].giorni, 126);
            expect(run.righe[0].interessi, 863.01);
            expect(run.totaleGiorni, 126);
            expect(run.totaleInteressi, 863.01);
            expect(run.totaleDovuto, 100863.01);
          },
        );
        test("Inizio primo gennaio", () async {
          when(mockTassoInteresseLegale.getTassiInteresseLegale())
              .thenAnswer((_) async => mockTassi);

          Calcolatore calcolatore = Calcolatore(
            initialCapital: 100000,
            initialDate: DateTime(2012, 01, 01),
            finalDate: DateTime(2012, 09, 30),
            capitalizzazione: 0,
            tassoInteresseLegaleOperations: mockTassoInteresseLegale,
          );

          TabellaInteressi run = await calcolatore.run();

          expect(run.righe.length, 1);
          expect(run.capitaleIniziale, 100000);
          expect(run.initialDate, DateTime(2012, 01, 01));
          expect(run.finalDate, DateTime(2012, 09, 30));
          expect(run.capitalizzazione, 0);
          expect(run.righe[0].dataIniziale, DateTime(2012, 01, 01));
          expect(run.righe[0].dataFinale, DateTime(2012, 09, 30));
          expect(run.righe[0].capitale, 100000);
          expect(run.righe[0].tasso, 2.5);
          expect(run.righe[0].giorni, 273);
          expect(run.righe[0].interessi, 1869.86);
          expect(run.totaleGiorni, 273);
          expect(run.totaleInteressi, 1869.86);
          expect(run.totaleDovuto, 101869.86);
        });
        test("Fine 31 dicembre", () async {
          when(mockTassoInteresseLegale.getTassiInteresseLegale())
              .thenAnswer((_) async => mockTassi);

          Calcolatore calcolatore = Calcolatore(
              initialCapital: 100000,
              initialDate: DateTime(2012, 05, 20),
              finalDate: DateTime(2012, 12, 31),
              capitalizzazione: 0,
              tassoInteresseLegaleOperations: mockTassoInteresseLegale);

          TabellaInteressi run = await calcolatore.run();

          expect(run.righe.length, 1);
          expect(run.capitaleIniziale, 100000);
          expect(run.initialDate, DateTime(2012, 05, 20));
          expect(run.finalDate, DateTime(2012, 12, 31));
          expect(run.capitalizzazione, 0);
          expect(run.righe[0].dataIniziale, DateTime(2012, 05, 20));
          expect(run.righe[0].dataFinale, DateTime(2012, 12, 31));
          expect(run.righe[0].capitale, 100000);
          expect(run.righe[0].tasso, 2.5);
          expect(run.righe[0].giorni, 225);
          expect(run.righe[0].interessi, 1541.10);
          expect(run.totaleGiorni, 225);
          expect(run.totaleInteressi, 1541.10);
          expect(run.totaleDovuto, 101541.10);
        });
        test("Anno spezzato", () async {
          when(mockTassoInteresseLegale.getTassiInteresseLegale())
              .thenAnswer((_) async => mockTassi);
          Calcolatore calcolatore = Calcolatore(
            initialCapital: 100000,
            initialDate: DateTime(1990, 05, 20),
            finalDate: DateTime(1991, 03, 08),
            capitalizzazione: 0,
            tassoInteresseLegaleOperations: mockTassoInteresseLegale,
          );

          TabellaInteressi run = await calcolatore.run();

          expect(run.righe.length, 2);
          expect(run.capitaleIniziale, 100000);
          expect(run.initialDate, DateTime(1990, 05, 20));
          expect(run.finalDate, DateTime(1991, 03, 08));
          expect(run.capitalizzazione, 0);
          expect(run.righe[0].dataIniziale, DateTime(1990, 05, 20));
          expect(run.righe[0].dataFinale, DateTime(1990, 12, 15));
          expect(run.righe[0].capitale, 100000);
          expect(run.righe[0].tasso, 5.0);
          expect(run.righe[0].giorni, 209);
          expect(run.righe[0].interessi, 2863.01);
          expect(run.righe[1].dataIniziale, DateTime(1990, 12, 16));
          expect(run.righe[1].dataFinale, DateTime(1991, 03, 08));
          expect(run.righe[1].capitale, 100000);
          expect(run.righe[1].tasso, 10.0);
          expect(run.righe[1].giorni, 83);
          expect(run.righe[1].interessi, 2273.97);
          expect(run.totaleGiorni, 292);
          expect(run.totaleInteressi, 5136.98);
          expect(run.totaleDovuto, 105136.98);
        });
      },
    );
    group("Capitalizzazione annuale", () {
      test("2005 a 2012", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime(2005, 05, 20),
          finalDate: DateTime(2012, 03, 08),
          capitalizzazione: 12,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 8);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime(2005, 05, 20));
        expect(run.finalDate, DateTime(2012, 03, 08));
        expect(run.capitalizzazione, 12);
        expect(run.righe[0].dataIniziale, DateTime(2005, 05, 20));
        expect(run.righe[0].dataFinale, DateTime(2005, 12, 31));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 2.5);
        expect(run.righe[0].giorni, 225);
        expect(run.righe[0].interessi, 1541.10);
        expect(run.righe[1].dataIniziale, DateTime(2006, 1, 1));
        expect(run.righe[1].dataFinale, DateTime(2006, 12, 31));
        expect(run.righe[1].capitale, 101541.10);
        expect(run.righe[1].tasso, 2.5);
        expect(run.righe[1].giorni, 365);
        expect(run.righe[1].interessi, 2538.53);
        expect(run.righe[2].dataIniziale, DateTime(2007, 01, 01));
        expect(run.righe[2].dataFinale, DateTime(2007, 12, 31));
        expect(run.righe[2].capitale, 104079.63);
        expect(run.righe[2].tasso, 2.5);
        expect(run.righe[2].giorni, 365);
        expect(run.righe[2].interessi, 2601.99);
        expect(run.righe[3].dataIniziale, DateTime(2008, 01, 01));
        expect(run.righe[3].dataFinale, DateTime(2008, 12, 31));
        expect(run.righe[3].capitale, 106681.62);
        expect(run.righe[3].tasso, 3);
        expect(run.righe[3].giorni, 366);
        expect(run.righe[3].interessi, 3209.22);
        expect(run.righe[4].dataIniziale, DateTime(2009, 01, 01));
        expect(run.righe[4].dataFinale, DateTime(2009, 12, 31));
        expect(run.righe[4].capitale, 109890.84);
        expect(run.righe[4].tasso, 3);
        expect(run.righe[4].giorni, 365);
        expect(run.righe[4].interessi, 3296.73);
        expect(run.righe[5].dataIniziale, DateTime(2010, 01, 01));
        expect(run.righe[5].dataFinale, DateTime(2010, 12, 31));
        expect(run.righe[5].capitale, 113187.57);
        expect(run.righe[5].tasso, 1);
        expect(run.righe[5].giorni, 365);
        expect(run.righe[5].interessi, 1131.88);
        expect(run.righe[6].dataIniziale, DateTime(2011, 01, 01));
        expect(run.righe[6].dataFinale, DateTime(2011, 12, 31));
        expect(run.righe[6].capitale, 114319.45);
        expect(run.righe[6].tasso, 1.5);
        expect(run.righe[6].giorni, 365);
        expect(run.righe[6].interessi, 1714.79);
        expect(run.righe[7].dataIniziale, DateTime(2012, 01, 01));
        expect(run.righe[7].dataFinale, DateTime(2012, 03, 08));
        expect(run.righe[7].capitale, 116034.24);
        expect(run.righe[7].tasso, 2.5);
        expect(run.righe[7].giorni, 68);
        expect(run.righe[7].interessi, 540.43);
        expect(run.totaleGiorni, 2484);
        expect(run.totaleInteressi, 16574.67);
        expect(run.totaleDovuto, 116574.67);
      });
      test(
        "Stesso anno 2012",
        () async {
          when(mockTassoInteresseLegale.getTassiInteresseLegale())
              .thenAnswer((_) async => mockTassi);

          Calcolatore calcolatore = Calcolatore(
            initialCapital: 100000,
            initialDate: DateTime(2012, 05, 20),
            finalDate: DateTime(2012, 09, 23),
            capitalizzazione: 12,
            tassoInteresseLegaleOperations: mockTassoInteresseLegale,
          );

          TabellaInteressi run = await calcolatore.run();

          expect(run.righe.length, 1);
          expect(run.capitaleIniziale, 100000);
          expect(run.initialDate, DateTime(2012, 05, 20));
          expect(run.finalDate, DateTime(2012, 09, 23));
          expect(run.capitalizzazione, 12);
          expect(run.righe[0].dataIniziale, DateTime(2012, 05, 20));
          expect(run.righe[0].dataFinale, DateTime(2012, 09, 23));
          expect(run.righe[0].capitale, 100000);
          expect(run.righe[0].tasso, 2.5);
          expect(run.righe[0].giorni, 126);
          expect(run.righe[0].interessi, 863.01);
          expect(run.totaleGiorni, 126);
          expect(run.totaleInteressi, 863.01);
          expect(run.totaleDovuto, 100863.01);
        },
      );
      test("Inizio primo gennaio", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime(2012, 01, 01),
          finalDate: DateTime(2013, 09, 30),
          capitalizzazione: 12,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 2);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime(2012, 01, 01));
        expect(run.finalDate, DateTime(2013, 09, 30));
        expect(run.capitalizzazione, 12);
        expect(run.righe[0].dataIniziale, DateTime(2012, 01, 01));
        expect(run.righe[0].dataFinale, DateTime(2012, 12, 31));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 2.5);
        expect(run.righe[0].giorni, 365);
        expect(run.righe[0].interessi, 2500);
        expect(run.righe[1].dataIniziale, DateTime(2013, 01, 01));
        expect(run.righe[1].dataFinale, DateTime(2013, 09, 30));
        expect(run.righe[1].capitale, 102500);
        expect(run.righe[1].tasso, 2.5);
        expect(run.righe[1].giorni, 272);
        expect(run.righe[1].interessi, 1909.59);
        expect(run.totaleGiorni, 637);
        expect(run.totaleInteressi, 4409.59);
        expect(run.totaleDovuto, 104409.59);
      });
      test("Fine 31 dicembre", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime(2012, 05, 20),
          finalDate: DateTime(2013, 12, 31),
          capitalizzazione: 12,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 2);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime(2012, 05, 20));
        expect(run.finalDate, DateTime(2013, 12, 31));
        expect(run.capitalizzazione, 12);
        expect(run.righe[0].dataIniziale, DateTime(2012, 05, 20));
        expect(run.righe[0].dataFinale, DateTime(2012, 12, 31));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 2.5);
        expect(run.righe[0].giorni, 225);
        expect(run.righe[0].interessi, 1541.10);
        expect(run.righe[1].dataIniziale, DateTime(2013, 01, 01));
        expect(run.righe[1].dataFinale, DateTime(2013, 12, 31));
        expect(run.righe[1].capitale, 101541.10);
        expect(run.righe[1].tasso, 2.5);
        expect(run.righe[1].giorni, 365);
        expect(run.righe[1].interessi, 2538.53);
        expect(run.totaleGiorni, 590);
        expect(run.totaleInteressi, 4079.63);
        expect(run.totaleDovuto, 104079.63);
      });
      test("Anno spezzato", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);
        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime(1990, 05, 20),
          finalDate: DateTime(1991, 03, 08),
          capitalizzazione: 12,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 3);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime(1990, 05, 20));
        expect(run.finalDate, DateTime(1991, 03, 08));
        expect(run.capitalizzazione, 12);
        expect(run.righe[0].dataIniziale, DateTime(1990, 05, 20));
        expect(run.righe[0].dataFinale, DateTime(1990, 12, 15));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 5.0);
        expect(run.righe[0].giorni, 209);
        expect(run.righe[0].interessi, 2863.01);
        expect(run.righe[1].dataIniziale, DateTime(1990, 12, 16));
        expect(run.righe[1].dataFinale, DateTime(1990, 12, 31));
        expect(run.righe[1].capitale, 100000);
        expect(run.righe[1].tasso, 10.0);
        expect(run.righe[1].giorni, 16);
        expect(run.righe[1].interessi, 438.36);
        expect(run.righe[2].dataIniziale, DateTime(1991, 01, 01));
        expect(run.righe[2].dataFinale, DateTime(1991, 03, 08));
        expect(run.righe[2].capitale, 103301.37);
        expect(run.righe[2].tasso, 10.0);
        expect(run.righe[2].giorni, 67);
        expect(run.righe[2].interessi, 1896.22);
        expect(run.totaleGiorni, 292);
        expect(run.totaleInteressi, 5197.59);
        expect(run.totaleDovuto, 105197.59);
      });
    });
  });
}

final mockTassi = [
  TassoInteresseLegale(
    inizio: DateTime(1942, 04, 21),
    fine: DateTime(1990, 12, 15),
    interesse: 5.0,
    norma: 'Art. 1284 cod.civ.',
  ),
  TassoInteresseLegale(
    inizio: DateTime(1990, 12, 16),
    fine: DateTime(1996, 12, 31),
    interesse: 10.0,
    norma: 'L. 353/90 e L.408/90',
  ),
  TassoInteresseLegale(
    inizio: DateTime(1997, 01, 01),
    fine: DateTime(1998, 12, 31),
    interesse: 5.0,
    norma: 'L. 662/96',
  ),
  TassoInteresseLegale(
    inizio: DateTime(1999, 01, 01),
    fine: DateTime(2000, 12, 31),
    interesse: 2.5,
    norma: 'Dm Tesoro 10/12/1998',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2001, 01, 01),
    fine: DateTime(2001, 12, 31),
    interesse: 3.5,
    norma: 'Dm Tesoro 11/12/2000',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2002, 01, 01),
    fine: DateTime(2003, 12, 31),
    interesse: 3.0,
    norma: 'Dm Economia 11/12/2001',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2004, 01, 01),
    fine: DateTime(2007, 12, 31),
    interesse: 2.5,
    norma: 'Dm Economia 01/12/2003',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2008, 01, 01),
    fine: DateTime(2009, 12, 31),
    interesse: 3.0,
    norma: 'Dm Economia 12/12/2007',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2010, 01, 01),
    fine: DateTime(2010, 12, 31),
    interesse: 1.0,
    norma: 'Dm Economia 04/12/2009',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2011, 01, 01),
    fine: DateTime(2011, 12, 31),
    interesse: 1.5,
    norma: 'Dm Economia 07/12/2010',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2012, 01, 01),
    fine: DateTime(2013, 12, 31),
    interesse: 2.5,
    norma: 'Dm Economia 12/12/2011',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2014, 01, 01),
    fine: DateTime(2014, 12, 31),
    interesse: 1.0,
    norma: 'Dm Economia 12/12/2013',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2015, 01, 01),
    fine: DateTime(2015, 12, 31),
    interesse: 0.5,
    norma: 'Dm Economia 11/12/2014',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2016, 01, 01),
    fine: DateTime(2016, 12, 31),
    interesse: 0.2,
    norma: 'Dm Economia 11/12/2015',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2017, 01, 01),
    fine: DateTime(2017, 12, 31),
    interesse: 0.1,
    norma: 'Dm Economia 7/12/2016',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2018, 01, 01),
    fine: DateTime(2018, 12, 31),
    interesse: 0.3,
    norma: 'Dm Economia 13/12/2017',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2019, 01, 01),
    fine: DateTime(2019, 12, 31),
    interesse: 0.8,
    norma: 'Dm Economia 12/12/2018',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2020, 01, 01),
    fine: DateTime(2020, 12, 31),
    interesse: 0.05,
    norma: 'Dm Economia 12/12/2019',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2021, 01, 01),
    fine: DateTime(2021, 12, 31),
    interesse: 0.01,
    norma: 'Dm Economia 11/12/2020',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2022, 01, 01),
    fine: DateTime(2022, 12, 31),
    interesse: 1.25,
    norma: 'Dm Economia 13/12/2021',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2023, 01, 01),
    fine: DateTime(2023, 12, 31),
    interesse: 5.0,
    norma: 'Dm Economia 13/12/2022',
  ),
  TassoInteresseLegale(
    inizio: DateTime(2024, 01, 01),
    fine: DateTime(2024, 12, 31),
    interesse: 2.5,
    norma: 'Dm Economia 29/11/2023',
  ),
];
