import 'package:flutter/material.dart';
import 'package:lawli/services/services.dart';
import "widgets.dart";

class MainWindow extends StatelessWidget {
  const MainWindow({
    super.key,
    required this.pratica,
  });

  final Pratica pratica;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: ResponsiveLayout.mainWindowPadding(context),
          child: Column(
            children: [
              Text(
                pratica.titolo,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              const ExpandableOverview(
                content: "Contenuto",
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  height: 600,
                  child: Row(
                    children: [Documenti(pratica: pratica), const SizedBox(height: 20, width: 20,), ChatBot(pratica: pratica)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
