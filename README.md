# lawli

An AI CRM for lawyers.

# Environment variables

Google Functions requires a .env.yaml file. Rename .env.yaml.template from `functions/` and enter the variables.

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

# Deploy

```bash
flutter build web &&
firebase deploy &&
cd functions &&
(gcloud functions deploy get_txt_from_docai_json --trigger-topic=documentai_pdf_new_doc --env-vars-file .env.yaml --gen2 --runtime=python311 --entry-point=get_txt_from_docai_json --region=europe-west3 & 
gcloud functions deploy generate_document_summary --trigger-topic=generate_document_summary --env-vars-file .env.yaml --gen2 --runtime=python311 --entry-point=generate_document_summary --region=europe-west3 &)
wait
cd ..
```

Change the timeout of the functions to 120 seconds (must do it manually b/c firebase doesn't have that on cli).