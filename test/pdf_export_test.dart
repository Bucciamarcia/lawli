import "package:lawli/template/editor/pdf_export.dart";
import "package:test/test.dart";

void main() {
  group("Test export pdf", () {
    test("Test export pdf", () async {
      String text = "Ill.mo Signor Presidente,\npuih (Codice fiscale: pouhi) nato a pouh, il pouh e res.te in pouih, elettivamente domiciliato in pouh presso lo studio dell'Avv. poi (C.F. pouh) dal quale è rappresentato e difeso in virtù di mandato a margine del presente atto,\nPremesso\n- che la parte ricorrente è creditrice nei confronti di hpo per uhpoi della complessiva somma di Euro: piouh come da seguente specifica:\n a) pi\n b) puoh\n c) ouih\n- che il credito fatto valere risulta dalla documentazione che si produce\n- che sono risultati infruttuosi i tentativi di composizione bonaria;\n- ciò premesso,\nChiede\nChe la S.V. Ill.ma voglia ingiungere a pouih di pagare, alla parte ricorrente, la somma di Euro po oltre interessi legali dalla data della domanda sino al saldo effettivo oltre le spese, competenze e onorari della presente fase monitoria.\nSi deposita:\n1) iuh;\n2) poih;\n3) po.\niuhp, oih\nAvv. poi\n\nIl Presidente del Tribunale di h\nLetto il ricorso che precede, ritenuta la propria competenza ed esaminata la documentazione prodotta, visti gli artt. 633 ss. c.p.c.\nIngiunge a\npoih\npoh\ndi pagare in solido a poih entro quaranta giorni dalla notificazione del presente atto la somma di Euro poi, oltre agli interessi legali dal h sino alla data del saldo effettivo ed oltre alle spese legali del presente procedimento che si liquidano in complessivi Euro poih di cui Euro ioph per spese, Euro oih per compensi professionali oltre al rimborso delle spese generali nella misura del 12,5 %, oltre C.A.P. ed I.V.A. ai sensi di legge, con espresso avvertimento che nel termine di quaranta giorni dalla notifica del presente decreto potrà essere proposta opposizione ex art. 645 c.p.c. e che in difetto di pagamento il creditore potrà procedere ad esecuzione forzata ai sensi di legge.\npoih, li poiuh";

      PdfExporter exporter = PdfExporter(templateText: text);
      exporter.export();

      expect(null, null);
    },);
  },);
}