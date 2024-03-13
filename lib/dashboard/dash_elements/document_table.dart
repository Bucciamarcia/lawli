import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../services/firestore.dart';
import '../../services/models.dart';

class DocumentTable extends StatelessWidget {
  final Pratica pratica;
  const DocumentTable({super.key, required this.pratica});
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder <List<Documento>> (future: RetrieveObjectFromDb().getDocumenti(pratica.id), builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Documento> documenti = snapshot.data!;
        return Text("yayyy: $documenti");
      } else if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },);
  }
}