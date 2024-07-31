import 'package:docx_to_text/docx_to_text.dart';
import "package:lawli/services/filepicker.dart";
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lawli/services/models.dart';
import 'package:lawli/shared/circular_progress_indicator.dart';
import 'package:lawli/shared/confirmation_message.dart';
import 'package:path/path.dart' as path;

class NuovoModelloButton extends StatelessWidget {
  const NuovoModelloButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Template> templates = [];
    int uploadedTemplates = 0;
    return ElevatedButton.icon(
      onPressed: () {
        CircularProgress.show(context);
        pickFile(context,
                allowedExtensions: ["txt", "docx"], allowMultiple: true)
            .then(
          (result) async {
            CircularProgress.pop(context);
            if (result != null) {
              List<PlatformFile> files = result.files;
              for (PlatformFile file in files) {
                debugPrint("File to process: ${file.name}");
                if (file.bytes == null ||
                    file.bytes!.isEmpty ||
                    file.extension != "txt" && file.extension != "docx") {
                  debugPrint("File extension not supported: ${file.extension}");
                  continue;
                }

                String text = file.extension == "txt"
                    ? String.fromCharCodes(file.bytes!)
                    : docxToText(file.bytes!);
                String title = path.basenameWithoutExtension(file.name);
                templates.add(
                  Template(title: title, text: text),
                );
                uploadedTemplates++;
              }
              if (uploadedTemplates == 0) {
                ConfirmationMessage.show(context, "Errore",
                    "Nessun file caricato. Caricare un file .docx o .txt (o più di uno)");
              } else if (uploadedTemplates == 1) {
                ConfirmationMessage.show(context, "Caricamento completato",
                    "Caricato il modello: ${templates[0].title}");
              } else {
                ConfirmationMessage.show(context, "Caricamento completato",
                    "Caricati $uploadedTemplates modelli");
              }
              for (Template template in templates) {
                try {
                  template
                      .processNew(context); // Sistema di merda, carica 1 alla volta su Weaviate. Da fare in batch.
                } catch (e) {
                  debugPrint("Errore durante getBriefDescription: $e");
                  ConfirmationMessage.show(context, "Errore",
                      "Errore durante il caricamento del template: ${template.title}");
                }
              }
              uploadedTemplates = 0;
              templates = [];
            } else {
              ConfirmationMessage.show(context, "Errore",
                  "Nessun file caricato. Caricare un file .docx o .txt (o più di uno)");
            }
          },
        );
      },
      label: const Text("Nuovo modello"),
      icon: const Icon(Icons.add),
    );
  }
}
