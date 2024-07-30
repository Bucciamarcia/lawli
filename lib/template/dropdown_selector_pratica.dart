import 'package:flutter/material.dart';
import 'package:lawli/ricerca_sentenze/motore_ricerca_sentenze.dart';
import 'package:lawli/services/models.dart';
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
      onChangedAction: (value) {
        Provider.of<TemplateProvider>(context, listen: false)
            .setPratica(value as Pratica);
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
