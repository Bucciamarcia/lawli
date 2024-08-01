import 'package:flutter/material.dart';
import "package:lawli/template/editor/main_editor.dart";
import "../../../shared/shared.dart";
import "../../../services/services.dart";

class TemplateEditorScreen extends StatelessWidget {
  final Template template;
  const TemplateEditorScreen({super.key, required this.template});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    "Template: ${template.title}",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                TemplateDocumentView(templateText: template.text)
              ],
            ),
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
