import 'package:flutter/material.dart';
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