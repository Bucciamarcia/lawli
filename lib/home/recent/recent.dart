import 'package:flutter/material.dart';
import "../../shared/shared.dart";

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: const Center(
          child: Text(
              "Qui potrai vedere le pratiche recenti per un accesso rapido."),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text('Pratiche recenti'),
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
