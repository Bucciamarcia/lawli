import "package:flutter/material.dart";
import "package:lawli/services/services.dart";

class AssistitiTable extends StatefulWidget {
  const AssistitiTable({super.key});

  @override
  State<AssistitiTable> createState() => _AssistitiTableState();
}

class _AssistitiTableState extends State<AssistitiTable> {

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BuildTable(),

      );
  }
}

class BuildTable extends StatelessWidget {
  const BuildTable({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Assistito>>(
  future: RetrieveObjectFromDb().getAssistiti(), // Your future here
  builder: (BuildContext context, AsyncSnapshot<List<Assistito>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator(); // Show loading indicator
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      // Convert your list of Assistito to List<DataRow>
      List<DataRow> dataRows = snapshot.data!.map<DataRow>((Assistito assistito) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(assistito.nome)), // Assuming Assistito has a firstName
            DataCell(Text(assistito.cognome)), // Assuming Assistito has a lastName
            DataCell(Text(assistito.descrizione)), // Assuming Assistito has a description
          ],
        );
      }).toList();

      // Return your DataTable or whatever widget you're populating
      return DataTable(rows: dataRows, columns: TableData().dataColumns);
    }
  },
);

  }
}

class TableData {

  List<DataColumn> dataColumns = const <DataColumn>[
    DataColumn(
      label: Text("Nome"),
    ),
    DataColumn(
      label: Text("Cognome"),
    ),
    DataColumn(
      label: Text("Descrizione")
    )
  ];


}