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
      expect(mockTassi[0].interesse, 0.05); // Changed from 5.0 to 0.05
      expect(mockTassi[0].norma, "Art. 1284 cod.civ.");
      expect(mockTassi[1].interesse, 0.10); // Changed from 10.0 to 0.10
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
              initialDate: DateTime.utc(2005, 05, 20),
              finalDate: DateTime.utc(2012, 03, 08),
              capitalizzazione: 0,
              tassoInteresseLegaleOperations: mockTassoInteresseLegale,
            );

            TabellaInteressi run = await calcolatore.run();

            expect(run.righe.length, 5);
            expect(run.capitaleIniziale, 100000);
            expect(run.initialDate, DateTime.utc(2005, 05, 20));
            expect(run.finalDate, DateTime.utc(2012, 03, 08));
            expect(run.capitalizzazione, 0);
            expect(run.righe[0].dataIniziale, DateTime.utc(2005, 05, 20));
            expect(run.righe[0].dataFinale, DateTime.utc(2007, 12, 31));
            expect(run.righe[0].capitale, 100000);
            expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
            expect(run.righe[0].giorni, 955);
            expect(run.righe[0].interessi, 6541.10);
            expect(run.righe[1].dataIniziale, DateTime.utc(2008, 1, 1));
            expect(run.righe[1].dataFinale, DateTime.utc(2009, 12, 31));
            expect(run.righe[1].capitale, 100000);
            expect(run.righe[1].tasso, 0.03); // Changed from 3 to 0.03
            expect(run.righe[1].giorni, 731);
            expect(run.righe[1].interessi, 6008.22);
            expect(run.righe[2].dataIniziale, DateTime.utc(2010, 01, 01));
            expect(run.righe[2].dataFinale, DateTime.utc(2010, 12, 31));
            expect(run.righe[2].capitale, 100000);
            expect(run.righe[2].tasso, 0.01); // Changed from 1 to 0.01
            expect(run.righe[2].giorni, 365);
            expect(run.righe[2].interessi, 1000);
            expect(run.righe[3].dataIniziale, DateTime.utc(2011, 01, 01));
            expect(run.righe[3].dataFinale, DateTime.utc(2011, 12, 31));
            expect(run.righe[3].capitale, 100000);
            expect(run.righe[3].tasso, 0.015); // Changed from 1.5 to 0.015
            expect(run.righe[3].giorni, 365);
            expect(run.righe[3].interessi, 1500);
            expect(run.righe[4].dataIniziale, DateTime.utc(2012, 01, 01));
            expect(run.righe[4].dataFinale, DateTime.utc(2012, 03, 08));
            expect(run.righe[4].capitale, 100000);
            expect(run.righe[4].tasso, 0.025); // Changed from 2.5 to 0.025
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
              initialDate: DateTime.utc(2012, 05, 20),
              finalDate: DateTime.utc(2012, 09, 23),
              capitalizzazione: 0,
              tassoInteresseLegaleOperations: mockTassoInteresseLegale,
            );

            TabellaInteressi run = await calcolatore.run();

            expect(run.righe.length, 1);
            expect(run.capitaleIniziale, 100000);
            expect(run.initialDate, DateTime.utc(2012, 05, 20));
            expect(run.finalDate, DateTime.utc(2012, 09, 23));
            expect(run.capitalizzazione, 0);
            expect(run.righe[0].dataIniziale, DateTime.utc(2012, 05, 20));
            expect(run.righe[0].dataFinale, DateTime.utc(2012, 09, 23));
            expect(run.righe[0].capitale, 100000);
            expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
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
            initialDate: DateTime.utc(2012, 01, 01),
            finalDate: DateTime.utc(2012, 09, 30),
            capitalizzazione: 0,
            tassoInteresseLegaleOperations: mockTassoInteresseLegale,
          );

          TabellaInteressi run = await calcolatore.run();

          expect(run.righe.length, 1);
          expect(run.capitaleIniziale, 100000);
          expect(run.initialDate, DateTime.utc(2012, 01, 01));
          expect(run.finalDate, DateTime.utc(2012, 09, 30));
          expect(run.capitalizzazione, 0);
          expect(run.righe[0].dataIniziale, DateTime.utc(2012, 01, 01));
          expect(run.righe[0].dataFinale, DateTime.utc(2012, 09, 30));
          expect(run.righe[0].capitale, 100000);
          expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
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
              initialDate: DateTime.utc(2012, 05, 20),
              finalDate: DateTime.utc(2012, 12, 31),
              capitalizzazione: 0,
              tassoInteresseLegaleOperations: mockTassoInteresseLegale);

          TabellaInteressi run = await calcolatore.run();

          expect(run.righe.length, 1);
          expect(run.capitaleIniziale, 100000);
          expect(run.initialDate, DateTime.utc(2012, 05, 20));
          expect(run.finalDate, DateTime.utc(2012, 12, 31));
          expect(run.capitalizzazione, 0);
          expect(run.righe[0].dataIniziale, DateTime.utc(2012, 05, 20));
          expect(run.righe[0].dataFinale, DateTime.utc(2012, 12, 31));
          expect(run.righe[0].capitale, 100000);
          expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
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
            initialDate: DateTime.utc(1990, 05, 20),
            finalDate: DateTime.utc(1991, 03, 08),
            capitalizzazione: 0,
            tassoInteresseLegaleOperations: mockTassoInteresseLegale,
          );

          TabellaInteressi run = await calcolatore.run();

          expect(run.righe.length, 2);
          expect(run.capitaleIniziale, 100000);
          expect(run.initialDate, DateTime.utc(1990, 05, 20));
          expect(run.finalDate, DateTime.utc(1991, 03, 08));
          expect(run.capitalizzazione, 0);
          expect(run.righe[0].dataIniziale, DateTime.utc(1990, 05, 20));
          expect(run.righe[0].dataFinale, DateTime.utc(1990, 12, 15));
          expect(run.righe[0].capitale, 100000);
          expect(run.righe[0].tasso, 0.05); // Changed from 5.0 to 0.05
          expect(run.righe[0].giorni, 209);
          expect(run.righe[0].interessi, 2863.01);
          expect(run.righe[1].dataIniziale, DateTime.utc(1990, 12, 16));
          expect(run.righe[1].dataFinale, DateTime.utc(1991, 03, 08));
          expect(run.righe[1].capitale, 100000);
          expect(run.righe[1].tasso, 0.10); // Changed from 10.0 to 0.10
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
          initialDate: DateTime.utc(2005, 05, 20),
          finalDate: DateTime.utc(2012, 03, 08),
          capitalizzazione: 12,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 8);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2005, 05, 20));
        expect(run.finalDate, DateTime.utc(2012, 03, 08));
        expect(run.capitalizzazione, 12);
        expect(run.righe[0].dataIniziale, DateTime.utc(2005, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(2005, 12, 31));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 225);
        expect(run.righe[0].interessi, 1541.10);
        expect(run.righe[1].dataIniziale, DateTime.utc(2006, 1, 1));
        expect(run.righe[1].dataFinale, DateTime.utc(2006, 12, 31));
        expect(run.righe[1].capitale, 101541.10);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 365);
        expect(run.righe[1].interessi, 2538.53);
        expect(run.righe[2].dataIniziale, DateTime.utc(2007, 01, 01));
        expect(run.righe[2].dataFinale, DateTime.utc(2007, 12, 31));
        expect(run.righe[2].capitale, 104079.63);
        expect(run.righe[2].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[2].giorni, 365);
        expect(run.righe[2].interessi, 2601.99);
        expect(run.righe[3].dataIniziale, DateTime.utc(2008, 01, 01));
        expect(run.righe[3].dataFinale, DateTime.utc(2008, 12, 31));
        expect(run.righe[3].capitale, 106681.62);
        expect(run.righe[3].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[3].giorni, 366);
        expect(run.righe[3].interessi, 3209.22);
        expect(run.righe[4].dataIniziale, DateTime.utc(2009, 01, 01));
        expect(run.righe[4].dataFinale, DateTime.utc(2009, 12, 31));
        expect(run.righe[4].capitale, 109890.84);
        expect(run.righe[4].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[4].giorni, 365);
        expect(run.righe[4].interessi, 3296.73);
        expect(run.righe[5].dataIniziale, DateTime.utc(2010, 01, 01));
        expect(run.righe[5].dataFinale, DateTime.utc(2010, 12, 31));
        expect(run.righe[5].capitale, 113187.57);
        expect(run.righe[5].tasso, 0.01); // Changed from 1 to 0.01
        expect(run.righe[5].giorni, 365);
        expect(run.righe[5].interessi, 1131.88);
        expect(run.righe[6].dataIniziale, DateTime.utc(2011, 01, 01));
        expect(run.righe[6].dataFinale, DateTime.utc(2011, 12, 31));
        expect(run.righe[6].capitale, 114319.45);
        expect(run.righe[6].tasso, 0.015); // Changed from 1.5 to 0.015
        expect(run.righe[6].giorni, 365);
        expect(run.righe[6].interessi, 1714.79);
        expect(run.righe[7].dataIniziale, DateTime.utc(2012, 01, 01));
        expect(run.righe[7].dataFinale, DateTime.utc(2012, 03, 08));
        expect(run.righe[7].capitale, 116034.24);
        expect(run.righe[7].tasso, 0.025); // Changed from 2.5 to 0.025
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
            initialDate: DateTime.utc(2012, 05, 20),
            finalDate: DateTime.utc(2012, 09, 23),
            capitalizzazione: 12,
            tassoInteresseLegaleOperations: mockTassoInteresseLegale,
          );

          TabellaInteressi run = await calcolatore.run();

          expect(run.righe.length, 1);
          expect(run.capitaleIniziale, 100000);
          expect(run.initialDate, DateTime.utc(2012, 05, 20));
          expect(run.finalDate, DateTime.utc(2012, 09, 23));
          expect(run.capitalizzazione, 12);
          expect(run.righe[0].dataIniziale, DateTime.utc(2012, 05, 20));
          expect(run.righe[0].dataFinale, DateTime.utc(2012, 09, 23));
          expect(run.righe[0].capitale, 100000);
          expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
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
          initialDate: DateTime.utc(2012, 01, 01),
          finalDate: DateTime.utc(2013, 09, 30),
          capitalizzazione: 12,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 2);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2012, 01, 01));
        expect(run.finalDate, DateTime.utc(2013, 09, 30));
        expect(run.capitalizzazione, 12);
        expect(run.righe[0].dataIniziale, DateTime.utc(2012, 01, 01));
        expect(run.righe[0].dataFinale, DateTime.utc(2012, 12, 31));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 365);
        expect(run.righe[0].interessi, 2500);
        expect(run.righe[1].dataIniziale, DateTime.utc(2013, 01, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2013, 09, 30));
        expect(run.righe[1].capitale, 102500);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 273);
        expect(run.righe[1].interessi, 1916.61);
        expect(run.totaleGiorni, 638);
        expect(run.totaleInteressi, 4416.61);
        expect(run.totaleDovuto, 104416.61);
      });
      test("Fine 31 dicembre", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2012, 05, 20),
          finalDate: DateTime.utc(2013, 12, 31),
          capitalizzazione: 12,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 2);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2012, 05, 20));
        expect(run.finalDate, DateTime.utc(2013, 12, 31));
        expect(run.capitalizzazione, 12);
        expect(run.righe[0].dataIniziale, DateTime.utc(2012, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(2012, 12, 31));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 225);
        expect(run.righe[0].interessi, 1541.10);
        expect(run.righe[1].dataIniziale, DateTime.utc(2013, 01, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2013, 12, 31));
        expect(run.righe[1].capitale, 101541.10);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
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
          initialDate: DateTime.utc(1990, 05, 20),
          finalDate: DateTime.utc(1991, 03, 08),
          capitalizzazione: 12,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 3);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(1990, 05, 20));
        expect(run.finalDate, DateTime.utc(1991, 03, 08));
        expect(run.capitalizzazione, 12);
        expect(run.righe[0].dataIniziale, DateTime.utc(1990, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(1990, 12, 15));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.05); // Changed from 5.0 to 0.05
        expect(run.righe[0].giorni, 209);
        expect(run.righe[0].interessi, 2863.01);
        expect(run.righe[1].dataIniziale, DateTime.utc(1990, 12, 16));
        expect(run.righe[1].dataFinale, DateTime.utc(1990, 12, 31));
        expect(run.righe[1].capitale, 100000);
        expect(run.righe[1].tasso, 0.10); // Changed from 10.0 to 0.10
        expect(run.righe[1].giorni, 16);
        expect(run.righe[1].interessi, 438.36);
        expect(run.righe[2].dataIniziale, DateTime.utc(1991, 01, 01));
        expect(run.righe[2].dataFinale, DateTime.utc(1991, 03, 08));
        expect(run.righe[2].capitale, 103301.37);
        expect(run.righe[2].tasso, 0.10); // Changed from 10.0 to 0.10
        expect(run.righe[2].giorni, 67);
        expect(run.righe[2].interessi, 1896.22);
        expect(run.totaleGiorni, 292);
        expect(run.totaleInteressi, 5197.59);
        expect(run.totaleDovuto, 105197.59);
      });
    });
    group("Capitalizzazione semestrale", () {
      test("2005 a 2012", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);
        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2005, 05, 20),
          finalDate: DateTime.utc(2012, 03, 08),
          capitalizzazione: 6,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 15);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2005, 05, 20));
        expect(run.finalDate, DateTime.utc(2012, 03, 08));
        expect(run.capitalizzazione, 6);
        expect(run.righe[0].dataIniziale, DateTime.utc(2005, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(2005, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 41);
        expect(run.righe[0].interessi, 280.82);
        expect(run.righe[1].dataIniziale, DateTime.utc(2005, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2005, 12, 31));
        expect(run.righe[1].capitale, 100280.82);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 184);
        expect(run.righe[1].interessi, 1263.81);
        expect(run.righe[2].dataIniziale, DateTime.utc(2006, 01, 01));
        expect(run.righe[2].dataFinale, DateTime.utc(2006, 06, 30));
        expect(run.righe[2].capitale, 101544.63);
        expect(run.righe[2].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[2].giorni, 181);
        expect(run.righe[2].interessi, 1258.88);
        expect(run.righe[3].dataIniziale, DateTime.utc(2006, 07, 01));
        expect(run.righe[3].dataFinale, DateTime.utc(2006, 12, 31));
        expect(run.righe[3].capitale, 102803.51);
        expect(run.righe[3].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[3].giorni, 184);
        expect(run.righe[3].interessi, 1295.61);
        expect(run.righe[4].dataIniziale, DateTime.utc(2007, 01, 01));
        expect(run.righe[4].dataFinale, DateTime.utc(2007, 06, 30));
        expect(run.righe[4].capitale, 104099.12);
        expect(run.righe[4].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[4].giorni, 181);
        expect(run.righe[4].interessi, 1290.54);
        expect(run.righe[5].dataIniziale, DateTime.utc(2007, 07, 01));
        expect(run.righe[5].dataFinale, DateTime.utc(2007, 12, 31));
        expect(run.righe[5].capitale, 105389.66);
        expect(run.righe[5].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[5].giorni, 184);
        expect(run.righe[5].interessi, 1328.20);
        expect(run.righe[6].dataIniziale, DateTime.utc(2008, 01, 01));
        expect(run.righe[6].dataFinale, DateTime.utc(2008, 06, 30));
        expect(run.righe[6].capitale, 106717.86);
        expect(run.righe[6].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[6].giorni, 182);
        expect(run.righe[6].interessi, 1596.38);
        expect(run.righe[7].dataIniziale, DateTime.utc(2008, 07, 01));
        expect(run.righe[7].dataFinale, DateTime.utc(2008, 12, 31));
        expect(run.righe[7].capitale, 108314.24);
        expect(run.righe[7].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[7].giorni, 184);
        expect(run.righe[7].interessi, 1638.07);
        expect(run.righe[8].dataIniziale, DateTime.utc(2009, 01, 01));
        expect(run.righe[8].dataFinale, DateTime.utc(2009, 06, 30));
        expect(run.righe[8].capitale, 109952.31);
        expect(run.righe[8].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[8].giorni, 181);
        expect(run.righe[8].interessi, 1635.73);
        expect(run.righe[9].dataIniziale, DateTime.utc(2009, 07, 01));
        expect(run.righe[9].dataFinale, DateTime.utc(2009, 12, 31));
        expect(run.righe[9].capitale, 111588.04);
        expect(run.righe[9].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[9].giorni, 184);
        expect(run.righe[9].interessi, 1687.58);
        expect(run.righe[10].dataIniziale, DateTime.utc(2010, 01, 01));
        expect(run.righe[10].dataFinale, DateTime.utc(2010, 06, 30));
        expect(run.righe[10].capitale, 113275.62);
        expect(run.righe[10].tasso, 0.01); // Changed from 1 to 0.01
        expect(run.righe[10].giorni, 181);
        expect(run.righe[10].interessi, 561.72);
        expect(run.righe[11].dataIniziale, DateTime.utc(2010, 07, 01));
        expect(run.righe[11].dataFinale, DateTime.utc(2010, 12, 31));
        expect(run.righe[11].capitale, 113837.34);
        expect(run.righe[11].tasso, 0.01); // Changed from 1 to 0.01
        expect(run.righe[11].giorni, 184);
        expect(run.righe[11].interessi, 573.86);
        expect(run.righe[12].dataIniziale, DateTime.utc(2011, 01, 01));
        expect(run.righe[12].dataFinale, DateTime.utc(2011, 06, 30));
        expect(run.righe[12].capitale, 114411.20);
        expect(run.righe[12].tasso, 0.015); // Changed from 1.5 to 0.015
        expect(run.righe[12].giorni, 181);
        expect(run.righe[12].interessi, 851.03);
        expect(run.righe[13].dataIniziale, DateTime.utc(2011, 07, 01));
        expect(run.righe[13].dataFinale, DateTime.utc(2011, 12, 31));
        expect(run.righe[13].capitale, 115262.23);
        expect(run.righe[13].tasso, 0.015); // Changed from 1.5 to 0.015
        expect(run.righe[13].giorni, 184);
        expect(run.righe[13].interessi, 871.57);
        expect(run.righe[14].dataIniziale, DateTime.utc(2012, 01, 01));
        expect(run.righe[14].dataFinale, DateTime.utc(2012, 03, 08));
        expect(run.righe[14].capitale, 116133.80);
        expect(run.righe[14].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[14].giorni, 68);
        expect(run.righe[14].interessi, 540.90);
        expect(run.totaleGiorni, 2484);
        expect(run.totaleInteressi, 16674.70);
        expect(run.totaleDovuto, 116674.70);
      });
      test("Stesso anno 2012", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2012, 05, 20),
          finalDate: DateTime.utc(2012, 09, 23),
          capitalizzazione: 6,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 2);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2012, 05, 20));
        expect(run.finalDate, DateTime.utc(2012, 09, 23));
        expect(run.capitalizzazione, 6);
        expect(run.righe[0].dataIniziale, DateTime.utc(2012, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(2012, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 41);
        expect(run.righe[0].interessi, 280.82);
        expect(run.righe[1].dataIniziale, DateTime.utc(2012, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2012, 09, 23));
        expect(run.righe[1].capitale, 100280.82);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 85);
        expect(run.righe[1].interessi, 583.83);
        expect(run.totaleGiorni, 126);
        expect(run.totaleInteressi, 864.65);
        expect(run.totaleDovuto, 100864.65);
      });
      test("Inizio primo gennaio", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2012, 01, 01),
          finalDate: DateTime.utc(2012, 09, 30),
          capitalizzazione: 6,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 2);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2012, 01, 01));
        expect(run.finalDate, DateTime.utc(2012, 09, 30));
        expect(run.capitalizzazione, 6);
        expect(run.righe[0].dataIniziale, DateTime.utc(2012, 01, 01));
        expect(run.righe[0].dataFinale, DateTime.utc(2012, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 181);
        expect(run.righe[0].interessi, 1239.73);
        expect(run.righe[1].dataIniziale, DateTime.utc(2012, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2012, 09, 30));
        expect(run.righe[1].capitale, 101239.73);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 92);
        expect(run.righe[1].interessi, 637.95);
        expect(run.totaleGiorni, 273);
        expect(run.totaleInteressi, 1877.68);
        expect(run.totaleDovuto, 101877.68);
      });
      test("Fine 31 dicembre", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2012, 05, 20),
          finalDate: DateTime.utc(2012, 12, 31),
          capitalizzazione: 6,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 2);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2012, 05, 20));
        expect(run.finalDate, DateTime.utc(2012, 12, 31));
        expect(run.capitalizzazione, 6);
        expect(run.righe[0].dataIniziale, DateTime.utc(2012, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(2012, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 41);
        expect(run.righe[0].interessi, 280.82);
        expect(run.righe[1].dataIniziale, DateTime.utc(2012, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2012, 12, 31));
        expect(run.righe[1].capitale, 100280.82);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 184);
        expect(run.righe[1].interessi, 1263.81);
        expect(run.totaleGiorni, 225);
        expect(run.totaleInteressi, 1544.63);
        expect(run.totaleDovuto, 101544.63);
      });
      test("Anno spezzato", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);
        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(1990, 05, 20),
          finalDate: DateTime.utc(1991, 03, 08),
          capitalizzazione: 6,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 4);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(1990, 05, 20));
        expect(run.finalDate, DateTime.utc(1991, 03, 08));
        expect(run.capitalizzazione, 6);
        expect(run.righe[0].dataIniziale, DateTime.utc(1990, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(1990, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.05); // Changed from 5.0 to 0.05
        expect(run.righe[0].giorni, 41);
        expect(run.righe[0].interessi, 561.64);
        expect(run.righe[1].dataIniziale, DateTime.utc(1990, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(1990, 12, 15));
        expect(run.righe[1].capitale, 100561.64);
        expect(run.righe[1].tasso, 0.05); // Changed from 5.0 to 0.05
        expect(run.righe[1].giorni, 168);
        expect(run.righe[1].interessi, 2314.30);
        expect(run.righe[2].dataIniziale, DateTime.utc(1990, 12, 16));
        expect(run.righe[2].dataFinale, DateTime.utc(1990, 12, 31));
        expect(run.righe[2].capitale, 100561.64);
        expect(run.righe[2].tasso, 0.10); // Changed from 10.0 to 0.10
        expect(run.righe[2].giorni, 16);
        expect(run.righe[2].interessi, 440.82);
        expect(run.righe[3].dataIniziale, DateTime.utc(1991, 01, 01));
        expect(run.righe[3].dataFinale, DateTime.utc(1991, 03, 08));
        expect(run.righe[3].capitale, 103316.76);
        expect(run.righe[3].tasso, 0.10); // Changed from 10.0 to 0.10
        expect(run.righe[3].giorni, 67);
        expect(run.righe[3].interessi, 1896.50);
        expect(run.totaleGiorni, 292);
        expect(run.totaleInteressi, 5213.26);
        expect(run.totaleDovuto, 105213.26);
      });
    });
    group("Capitalizzazione trimestrale", () {
      test("2007 a 2009", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);
        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2007, 05, 20),
          finalDate: DateTime.utc(2009, 08, 27),
          capitalizzazione: 3,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 10);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2007, 05, 20));
        expect(run.finalDate, DateTime.utc(2009, 08, 27));
        expect(run.capitalizzazione, 3);
        expect(run.righe[0].dataIniziale, DateTime.utc(2007, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(2007, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 41);
        expect(run.righe[0].interessi, 280.82);
        expect(run.righe[1].dataIniziale, DateTime.utc(2007, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2007, 09, 30));
        expect(run.righe[1].capitale, 100280.82);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 92);
        expect(run.righe[1].interessi, 631.91);
        expect(run.righe[2].dataIniziale, DateTime.utc(2007, 10, 01));
        expect(run.righe[2].dataFinale, DateTime.utc(2007, 12, 31));
        expect(run.righe[2].capitale, 100912.73);
        expect(run.righe[2].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[2].giorni, 92);
        expect(run.righe[2].interessi, 635.89);
        expect(run.righe[3].dataIniziale, DateTime.utc(2008, 01, 01));
        expect(run.righe[3].dataFinale, DateTime.utc(2008, 03, 31));
        expect(run.righe[3].capitale, 101548.62);
        expect(run.righe[3].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[3].giorni, 91);
        expect(run.righe[3].interessi, 759.53);
        expect(run.righe[4].dataIniziale, DateTime.utc(2008, 04, 01));
        expect(run.righe[4].dataFinale, DateTime.utc(2008, 06, 30));
        expect(run.righe[4].capitale, 102308.15);
        expect(run.righe[4].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[4].giorni, 91);
        expect(run.righe[4].interessi, 765.21);
        expect(run.righe[5].dataIniziale, DateTime.utc(2008, 07, 01));
        expect(run.righe[5].dataFinale, DateTime.utc(2008, 09, 30));
        expect(run.righe[5].capitale, 103073.36);
        expect(run.righe[5].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[5].giorni, 92);
        expect(run.righe[5].interessi, 779.40);
        expect(run.righe[6].dataIniziale, DateTime.utc(2008, 10, 01));
        expect(run.righe[6].dataFinale, DateTime.utc(2008, 12, 31));
        expect(run.righe[6].capitale, 103852.76);
        expect(run.righe[6].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[6].giorni, 92);
        expect(run.righe[6].interessi, 785.30);
        expect(run.righe[7].dataIniziale, DateTime.utc(2009, 01, 01));
        expect(run.righe[7].dataFinale, DateTime.utc(2009, 03, 31));
        expect(run.righe[7].capitale, 104638.06);
        expect(run.righe[7].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[7].giorni, 90);
        expect(run.righe[7].interessi, 774.03);
        expect(run.righe[8].dataIniziale, DateTime.utc(2009, 04, 01));
        expect(run.righe[8].dataFinale, DateTime.utc(2009, 06, 30));
        expect(run.righe[8].capitale, 105412.09);
        expect(run.righe[8].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[8].giorni, 91);
        expect(run.righe[8].interessi, 788.42);
        expect(run.righe[9].dataIniziale, DateTime.utc(2009, 07, 01));
        expect(run.righe[9].dataFinale, DateTime.utc(2009, 08, 27));
        expect(run.righe[9].capitale, 106200.51);
        expect(run.righe[9].tasso, 0.03); // Changed from 3 to 0.03
        expect(run.righe[9].giorni, 58);
        expect(run.righe[9].interessi, 506.27);
        expect(run.totaleGiorni, 830);
        expect(run.totaleInteressi, 6706.78);
        expect(run.totaleDovuto, 106706.78);
      });
      test("Stesso anno 2012", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2012, 05, 20),
          finalDate: DateTime.utc(2012, 09, 23),
          capitalizzazione: 3,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 2);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2012, 05, 20));
        expect(run.finalDate, DateTime.utc(2012, 09, 23));
        expect(run.capitalizzazione, 3);
        expect(run.righe[0].dataIniziale, DateTime.utc(2012, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(2012, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 41);
        expect(run.righe[0].interessi, 280.82);
        expect(run.righe[1].dataIniziale, DateTime.utc(2012, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2012, 09, 23));
        expect(run.righe[1].capitale, 100280.82);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 85);
        expect(run.righe[1].interessi, 583.83);
        expect(run.totaleGiorni, 126);
        expect(run.totaleInteressi, 864.65);
        expect(run.totaleDovuto, 100864.65);
      });
      test("Inizio primo gennaio", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2012, 01, 01),
          finalDate: DateTime.utc(2012, 09, 30),
          capitalizzazione: 3,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 3);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2012, 01, 01));
        expect(run.finalDate, DateTime.utc(2012, 09, 30));
        expect(run.capitalizzazione, 3);
        expect(run.righe[0].dataIniziale, DateTime.utc(2012, 01, 01));
        expect(run.righe[0].dataFinale, DateTime.utc(2012, 03, 31));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 90);
        expect(run.righe[0].interessi, 616.44);
        expect(run.righe[1].dataIniziale, DateTime.utc(2012, 04, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2012, 06, 30));
        expect(run.righe[1].capitale, 100616.44);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 91);
        expect(run.righe[1].interessi, 627.13);
        expect(run.righe[2].dataIniziale, DateTime.utc(2012, 07, 01));
        expect(run.righe[2].dataFinale, DateTime.utc(2012, 09, 30));
        expect(run.righe[2].capitale, 101243.57);
        expect(run.righe[2].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[2].giorni, 92);
        expect(run.righe[2].interessi, 637.97);
        expect(run.totaleGiorni, 273);
        expect(run.totaleInteressi, 1881.54);
        expect(run.totaleDovuto, 101881.54);
      });
      test("Fine 31 dicembre", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);

        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(2012, 05, 20),
          finalDate: DateTime.utc(2012, 12, 31),
          capitalizzazione: 3,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 3);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(2012, 05, 20));
        expect(run.finalDate, DateTime.utc(2012, 12, 31));
        expect(run.capitalizzazione, 3);
        expect(run.righe[0].dataIniziale, DateTime.utc(2012, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(2012, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[0].giorni, 41);
        expect(run.righe[0].interessi, 280.82);
        expect(run.righe[1].dataIniziale, DateTime.utc(2012, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(2012, 09, 30));
        expect(run.righe[1].capitale, 100280.82);
        expect(run.righe[1].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[1].giorni, 92);
        expect(run.righe[1].interessi, 631.91);
        expect(run.righe[2].dataIniziale, DateTime.utc(2012, 10, 01));
        expect(run.righe[2].dataFinale, DateTime.utc(2012, 12, 31));
        expect(run.righe[2].capitale, 100912.73);
        expect(run.righe[2].tasso, 0.025); // Changed from 2.5 to 0.025
        expect(run.righe[2].giorni, 92);
        expect(run.righe[2].interessi, 635.89);
        expect(run.totaleGiorni, 225);
        expect(run.totaleInteressi, 1548.62);
        expect(run.totaleDovuto, 101548.62);
      });
      test("Anno spezzato", () async {
        when(mockTassoInteresseLegale.getTassiInteresseLegale())
            .thenAnswer((_) async => mockTassi);
        Calcolatore calcolatore = Calcolatore(
          initialCapital: 100000,
          initialDate: DateTime.utc(1990, 05, 20),
          finalDate: DateTime.utc(1991, 03, 08),
          capitalizzazione: 3,
          tassoInteresseLegaleOperations: mockTassoInteresseLegale,
        );

        TabellaInteressi run = await calcolatore.run();

        expect(run.righe.length, 5);
        expect(run.capitaleIniziale, 100000);
        expect(run.initialDate, DateTime.utc(1990, 05, 20));
        expect(run.finalDate, DateTime.utc(1991, 03, 08));
        expect(run.capitalizzazione, 3);
        expect(run.righe[0].dataIniziale, DateTime.utc(1990, 05, 20));
        expect(run.righe[0].dataFinale, DateTime.utc(1990, 06, 30));
        expect(run.righe[0].capitale, 100000);
        expect(run.righe[0].tasso, 0.05); // Changed from 5.0 to 0.05
        expect(run.righe[0].giorni, 41);
        expect(run.righe[0].interessi, 561.64);
        expect(run.righe[1].dataIniziale, DateTime.utc(1990, 07, 01));
        expect(run.righe[1].dataFinale, DateTime.utc(1990, 09, 30));
        expect(run.righe[1].capitale, 100561.64);
        expect(run.righe[1].tasso, 0.05); // Changed from 5.0 to 0.05
        expect(run.righe[1].giorni, 92);
        expect(run.righe[1].interessi, 1267.35);
        expect(run.righe[2].dataIniziale, DateTime.utc(1990, 10, 01));
        expect(run.righe[2].dataFinale, DateTime.utc(1990, 12, 15));
        expect(run.righe[2].capitale, 101828.99);
        expect(run.righe[2].tasso, 0.05); // Changed from 5.0 to 0.05
        expect(run.righe[2].giorni, 76);
        expect(run.righe[2].interessi, 1060.14);
        expect(run.righe[3].dataIniziale, DateTime.utc(1990, 12, 16));
        expect(run.righe[3].dataFinale, DateTime.utc(1990, 12, 31));
        expect(run.righe[3].capitale, 101828.99);
        expect(run.righe[3].tasso, 0.10); // Changed from 10.0 to 0.10
        expect(run.righe[3].giorni, 16);
        expect(run.righe[3].interessi, 446.37);
        expect(run.righe[4].dataIniziale, DateTime.utc(1991, 01, 01));
        expect(run.righe[4].dataFinale, DateTime.utc(1991, 03, 08));
        expect(run.righe[4].capitale, 103335.50);
        expect(run.righe[4].tasso, 0.10); // Changed from 10.0 to 0.10
        expect(run.righe[4].giorni, 67);
        expect(run.righe[4].interessi, 1896.84);
        expect(run.totaleGiorni, 292);
        expect(run.totaleInteressi, 5232.34);
        expect(run.totaleDovuto, 105232.34);
      });
    });
  });
}

final mockTassi = [
  TassoInteresseLegale(
    inizio: DateTime.utc(1942, 04, 21),
    fine: DateTime.utc(1990, 12, 15),
    interesse: 0.05,
    norma: 'Art. 1284 cod.civ.',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(1990, 12, 16),
    fine: DateTime.utc(1996, 12, 31),
    interesse: 0.10,
    norma: 'L. 353/90 e L.408/90',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(1997, 01, 01),
    fine: DateTime.utc(1998, 12, 31),
    interesse: 0.05,
    norma: 'L. 662/96',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(1999, 01, 01),
    fine: DateTime.utc(2000, 12, 31),
    interesse: 0.025,
    norma: 'Dm Tesoro 10/12/1998',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2001, 01, 01),
    fine: DateTime.utc(2001, 12, 31),
    interesse: 0.035,
    norma: 'Dm Tesoro 11/12/2000',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2002, 01, 01),
    fine: DateTime.utc(2003, 12, 31),
    interesse: 0.03,
    norma: 'Dm Economia 11/12/2001',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2004, 01, 01),
    fine: DateTime.utc(2007, 12, 31),
    interesse: 0.025,
    norma: 'Dm Economia 01/12/2003',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2008, 01, 01),
    fine: DateTime.utc(2009, 12, 31),
    interesse: 0.03,
    norma: 'Dm Economia 12/12/2007',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2010, 01, 01),
    fine: DateTime.utc(2010, 12, 31),
    interesse: 0.01,
    norma: 'Dm Economia 04/12/2009',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2011, 01, 01),
    fine: DateTime.utc(2011, 12, 31),
    interesse: 0.015,
    norma: 'Dm Economia 07/12/2010',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2012, 01, 01),
    fine: DateTime.utc(2013, 12, 31),
    interesse: 0.025,
    norma: 'Dm Economia 12/12/2011',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2014, 01, 01),
    fine: DateTime.utc(2014, 12, 31),
    interesse: 0.01,
    norma: 'Dm Economia 12/12/2013',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2015, 01, 01),
    fine: DateTime.utc(2015, 12, 31),
    interesse: 0.005,
    norma: 'Dm Economia 11/12/2014',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2016, 01, 01),
    fine: DateTime.utc(2016, 12, 31),
    interesse: 0.002,
    norma: 'Dm Economia 11/12/2015',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2017, 01, 01),
    fine: DateTime.utc(2017, 12, 31),
    interesse: 0.001,
    norma: 'Dm Economia 7/12/2016',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2018, 01, 01),
    fine: DateTime.utc(2018, 12, 31),
    interesse: 0.003,
    norma: 'Dm Economia 13/12/2017',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2019, 01, 01),
    fine: DateTime.utc(2019, 12, 31),
    interesse: 0.008,
    norma: 'Dm Economia 12/12/2018',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2020, 01, 01),
    fine: DateTime.utc(2020, 12, 31),
    interesse: 0.0005,
    norma: 'Dm Economia 12/12/2019',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2021, 01, 01),
    fine: DateTime.utc(2021, 12, 31),
    interesse: 0.0001,
    norma: 'Dm Economia 11/12/2020',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2022, 01, 01),
    fine: DateTime.utc(2022, 12, 31),
    interesse: 0.0125,
    norma: 'Dm Economia 13/12/2021',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2023, 01, 01),
    fine: DateTime.utc(2023, 12, 31),
    interesse: 0.05,
    norma: 'Dm Economia 13/12/2022',
  ),
  TassoInteresseLegale(
    inizio: DateTime.utc(2024, 01, 01),
    fine: DateTime.utc(2024, 12, 31),
    interesse: 0.025,
    norma: 'Dm Economia 29/11/2023',
  ),
];