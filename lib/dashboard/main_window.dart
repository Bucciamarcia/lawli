import 'package:flutter/material.dart';
import 'package:lawli/services/services.dart';

class MainWindow extends StatelessWidget {
  const MainWindow({
    super.key,
    required this.pratica,
  });

  final Pratica pratica;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: ResponsiveLayout.mainWindowPadding(context),
      child: Text(
        pratica.titolo,
        style: Theme.of(context).textTheme.displayLarge,
      ),
    ));
  }
}