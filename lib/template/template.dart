import 'package:flutter/material.dart';
import "package:lawli/template/template_main.dart";
import "package:provider/provider.dart";
import "../../shared/shared.dart";
import "../../services/services.dart";
import "provider.dart";

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: ResponsiveLayout.mainWindowPadding(context),
          child: Column(
            children: [
              Text(
                "Template",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ChangeNotifierProvider(
                  create:(context) => TemplateProvider(),
                  child: const TemplateHomeWidget()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Template"),
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
