import 'package:flutter/material.dart';
import "package:lawli/strumenti_gratis/calcolo_interessi_legali/main.dart";
import "../../shared/shared.dart";
import "../../services/services.dart";

class CalcoloInteressiLegaliScreen extends StatelessWidget {
  const CalcoloInteressiLegaliScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: ResponsiveLayout.mainWindowPadding(context),
          child: const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: LegalInterestCalculatorMain(),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Calcolo Interessi Legali"),
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
