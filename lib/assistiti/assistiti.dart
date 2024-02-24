import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../../shared/shared.dart";
import "../../services/services.dart";

class AssistitiScreen extends StatelessWidget {
  const AssistitiScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Column(
          children: [
            Text(
              "Assistiti",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/assistiti/nuovo");
              },
              child: const Text("Nuovo assistito"),
              
            ),
            Expanded(
              child: AssistitiTable(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Assistiti"),
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

class AssistitiTable extends StatefulWidget {
  @override
  _AssistitiTableState createState() => _AssistitiTableState();
}

class _AssistitiTableState extends State<AssistitiTable> {
  int _rowsPerPage = 10;
  int _rowsOffset = 0;
  List<DocumentSnapshot> _assistiti = [];

  @override
  void initState() {
    super.initState();
    _loadAssistiti();
  }

  void _loadAssistiti() {
    FirebaseFirestore.instance
        .collection('accounts/lawli/assistiti')
        .orderBy('id')
        .startAt([_rowsOffset])
        .limit(_rowsPerPage)
        .get()
        .then((querySnapshot) {
          setState(() {
            _assistiti = querySnapshot.docs;
          });
        });
  }

  void _changePage(int page) {
    setState(() {
      _rowsOffset = page * _rowsPerPage;
    });
    _loadAssistiti();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: const Text('Elenco Assistiti'),
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Nome')),
        DataColumn(label: Text('Cognome')),
        DataColumn(label: Text('Descrizione')),
      ],
      source: _AssistitiDataSource(context, _assistiti),
      onRowsPerPageChanged: (r) {
        setState(() {
          _rowsPerPage = r ?? _rowsPerPage;
        });
      },
      rowsPerPage: _rowsPerPage,
      availableRowsPerPage: const [5, 10, 20],
      onPageChanged: (rowIndex) {
        if (rowIndex ~/ _rowsPerPage != _rowsOffset ~/ _rowsPerPage) {
          _changePage(rowIndex ~/ _rowsPerPage);
        }
      },
    );
  }
}


class _AssistitiDataSource extends DataTableSource {
  final BuildContext context;
  final List<DocumentSnapshot> _assistiti;

  _AssistitiDataSource(this.context, this._assistiti);

  @override
  DataRow getRow(int index) {
    final assistito = _assistiti[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(assistito['id'].toString())),
        DataCell(Text(assistito['nome'])),
        DataCell(Text(assistito['cognome'])),
        DataCell(Text(assistito['descrizione'])),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _assistiti.length;

  @override
  int get selectedRowCount => 0;
}
