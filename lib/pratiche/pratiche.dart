import 'package:flutter/material.dart';
import "../../shared/shared.dart";
import "../../services/services.dart";

class PraticheScreen extends StatelessWidget {
  const PraticheScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Column(
          children: [
            Text(
              "Pratiche",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/pratiche/nuovo");
              },
              child: const Text("Nuova pratica"),
              
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
        title: const Text("Pratiche"),
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
