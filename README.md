# lawli

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Layout builder

Code for each new page:

```dart
import 'package:flutter/material.dart';
import "../../shared/shared.dart";
import "../../services/services.dart";

class UploadFileScreen extends StatelessWidget {
  const UploadFileScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: ResponsiveLayout.mainWindowPadding(context),
        child: Column(
          children: [
            Text(
              "Assistiti",
              style: Theme.of(context).textTheme.displayLarge,
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
```

The reason for this code is that there is a different menu on desktop.

## Deploy gcloud pubsub triggered functions

These have to be deployed separately because they don't use firebase but gcloud:

```bash
gcloud functions deploy get_txt_from_docai_json --trigger-topic=documentai_pdf_new_doc --gen2 --runtime=python311 --entry-point=get_txt_from_docai_json --region=europe-west3

gcloud functions deploy generate_document_summary --trigger-topic=generate_document_summary --gen2 --runtime=python311 --entry-point=generate_document_summary --region=europe-west3
```