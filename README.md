# lawli

An AI CRM for lawyers.

## Environment variables

Google Functions requires a .env.yaml file. Rename .env.yaml.template from `functions/` and enter the variables.

## Layout builder

Code for each new page:

```dart
import 'package:flutter/material.dart';
import "../../shared/shared.dart";
import "../../services/services.dart";

class UploadFileScreen extends StatelessWidget {
  const UploadFileScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: ResponsiveLayout.mainWindowPadding(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Text(
                  "OK!",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
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
```

The reason for this code is that there is a different menu on desktop.

## Weaviate database
Need to inizialize the weaviate DB once. In functions/weaviate_setup_template_collection.py

## Deploy

From the main project folder.

```bash
flutter build web &&
firebase deploy &&
cd functions &&
(gcloud functions deploy get_txt_from_docai_json --trigger-topic=documentai_pdf_new_doc --env-vars-file .env.yaml --gen2 --runtime=python311 --entry-point=get_txt_from_docai_json --region=europe-west3 & 
gcloud functions deploy generate_document_summary --trigger-topic=generate_document_summary --env-vars-file .env.yaml --gen2 --runtime=python311 --entry-point=generate_document_summary --region=europe-west3 &)
wait
cd ..
```

## Pubsub storage

Need  to set up a pubsub notification for google cloud storage for generate document summary and documentai pdf to doc:

`gcloud storage buckets notifications create gs://lawli-bab83.appspot.com/ --topic="topic" --object-prefix=accounts/ --event-types=OBJECT_FINALIZE`