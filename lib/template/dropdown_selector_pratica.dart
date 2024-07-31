import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:lawli/ricerca_sentenze/motore_ricerca_sentenze.dart';
import 'package:lawli/services/cloud_storage.dart';
import 'package:lawli/services/models.dart';
import 'package:lawli/services/provider.dart';
import 'package:lawli/template/provider.dart';
import 'package:provider/provider.dart';

class DropdownSelectorPratica extends StatefulWidget {
  final AsyncSnapshot<List<Pratica>> snapshot;
  const DropdownSelectorPratica({
    super.key,
    required this.snapshot,
  });

  @override
  State<DropdownSelectorPratica> createState() =>
      _DropdownSelectorPraticaState();
}

class _DropdownSelectorPraticaState extends State<DropdownSelectorPratica> {
  @override
  Widget build(BuildContext context) {
    return DropdownSelector(
      preText: "Seleziona la pratica",
      snapshot: widget.snapshot,
      dropDownValue:
          Provider.of<TemplateProvider>(context, listen: true).selectedPratica,
      onChangedAction: (Pratica value) async {
        Provider.of<TemplateProvider>(context, listen: false)
            .setIsSearchingLikley(true);
        Provider.of<TemplateProvider>(context, listen: false).setPratica(value);
        await getLikelyTemplates(context, value);
        Provider.of<TemplateProvider>(context, listen: false)
            .setIsSearchingLikley(false);
      },
      dropDownItems: [
        for (Pratica pratica in widget.snapshot.data!)
          DropdownMenuItem(
            value: pratica,
            child: Text(pratica.titolo),
          )
      ],
    );
  }
}

Future<void> getLikelyTemplates(BuildContext context, Pratica pratica) async {
  String account =
      Provider.of<DashboardProvider>(context, listen: false).accountName;
  String riassuntoPath =
      "accounts/$account/pratiche/${pratica.id.toString()}/riassunto generale.txt";
  String riassuntoGenerale =
      await DocumentStorage().getTextDocument(riassuntoPath);
  var result = await FirebaseFunctions.instance
      .httpsCallable("get_likley_templates")
      .call({"query": riassuntoGenerale, "client": account});

  List<dynamic> data = result.data;
  List<Template> templates = [];
  for (var d in data) {
    if (d is Map<String, dynamic>) {
      // Convert Map<String, dynamic> to Map<String, String>
      Map<String, String> stringMap =
          d.map((key, value) => MapEntry(key, value.toString()));
      templates.add(Template.fromJson(stringMap));
    } else {
      throw Exception("Unexpected data format");
    }
  }
  Provider.of<TemplateProvider>(context, listen: false)
      .setLikelyTemplates(templates);
}
