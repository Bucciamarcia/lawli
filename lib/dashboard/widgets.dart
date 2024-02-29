import 'package:flutter/material.dart';
import 'package:lawli/services/services.dart';
import 'package:expandable_text/expandable_text.dart';

class ExpandableOverview extends StatelessWidget {
  final String content;
  const ExpandableOverview({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("La causa in breve",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              )),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 600,
              child: Center(
                child: ExpandableText(
                  content,
                  expandText: "Mostra di più",
                  collapseText: "Mostra di meno",
                  maxLines: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Documenti extends StatelessWidget {
  final Pratica pratica;
  const Documenti({super.key, required this.pratica});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Documenti", style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),
            Column(children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[700],
                  ),
                  child: Text(
                    "Nuovo Documento",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.white),
                  ))
            ])
          ],
        ),
      ),
    );
  }
}
