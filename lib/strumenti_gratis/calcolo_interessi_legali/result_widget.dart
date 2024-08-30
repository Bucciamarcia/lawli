import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawli/strumenti_gratis/calcolo_interessi_legali/calcolatore.dart';

class InteressiLegaliResults extends StatelessWidget {
  final TabellaInteressi results;
  final formatter = NumberFormat("#,##0.00", "it_IT");
  InteressiLegaliResults({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    late final String capitalizzazione;
    if (results.capitalizzazione == 0) {
      capitalizzazione = "Nessuna";
    } else if (results.capitalizzazione == 3) {
      capitalizzazione = "Trimestrale";
    } else if (results.capitalizzazione == 6) {
      capitalizzazione = "Semestrale";
    } else {
      capitalizzazione = "Annuale";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Capitale iniziale: ${formatter.format(results.capitaleIniziale)}",
        ),
        Text(
            "Data iniziale: ${DateFormat("dd/MM/yyyy").format(results.initialDate)}"),
        Text(
            "Data finale: ${DateFormat("dd/MM/yyyy").format(results.finalDate)}"),
        Text("Capitalizzazione: $capitalizzazione"),
        const Divider(
          thickness: 3,
          height: 20,
        ),
        Flexible(child: SingleChildScrollView(child: resultsTable())),
        const Divider(
          thickness: 3,
          height: 20,
        ),
        Text("Totale giorni: ${results.totaleGiorni}"),
        Text("Totale interessi: ${formatter.format(results.totaleInteressi)}"),
        Text("Importo totale: ${formatter.format(results.totaleDovuto)}"),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
              child: const Text("Chiudi"),
              onPressed: () => Navigator.of(context).pop()),
        ),
      ],
    );
  }

  DataTable resultsTable() {
    return DataTable(
        columns: const [
          DataColumn(label: Text("Da")),
          DataColumn(label: Text("A")),
          DataColumn(label: Text("Giorni")),
          DataColumn(label: Text("Capitale")),
          DataColumn(label: Text("Tasso interesse")),
          DataColumn(label: Text("Interessi periodo")),
        ],
        rows: results.righe
            .map((RigaInteressi riga) => DataRow(cells: [
                  DataCell(
                      Text(DateFormat("dd/MM/yyyy").format(riga.dataIniziale))),
                  DataCell(
                      Text(DateFormat("dd/MM/yyyy").format(riga.dataFinale))),
                  DataCell(Text(riga.giorni.toString())),
                  DataCell(Text("€ ${formatter.format(riga.capitale)}")),
                  DataCell(Text("${100 * riga.tasso}%")),
                  DataCell(Text("€ ${riga.interessi.toString()}")),
                ]))
            .toList());
  }
}
