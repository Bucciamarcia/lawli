import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lawli/shared/circular_progress_indicator.dart';
import 'package:lawli/shared/confirmation_message.dart';

class NuovoModelloButton extends StatelessWidget {
  const NuovoModelloButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> texts = [];
    int uploadedTemplates = 0;
    return ElevatedButton.icon(
      onPressed: () {
        CircularProgress.show(context);
        _pickFile(context).then(
          (result) {
            CircularProgress.pop(context);
            if (result != null) {
              List<PlatformFile> files = result.files;
              for (PlatformFile file in files) {
                debugPrint("File: ${file.name}");
                if (file.extension == "txt" && file.bytes != null) {
                  String text = String.fromCharCodes(file.bytes!);
                  texts.add(text);
                  uploadedTemplates++;
                } else if (file.extension == "docx" && file.bytes != null) {
                  String text = docxToText(file.bytes!);
                  texts.add(text);
                  uploadedTemplates++;
                } else {
                  debugPrint("File extension not supported: ${file.extension}");
                }
              }
              if (uploadedTemplates == 0) {
                ConfirmationMessage.show(context, "Errore",
                    "Nessun file caricato. Caricare un file .docx o .txt (o più di uno)");
              } else {
                ConfirmationMessage.show(context, "Caricamento completato",
                    "Caricati $uploadedTemplates modello/i");
                    debugPrint("Texts: $texts");
                    uploadedTemplates = 0;
                    texts = [];
              }
            }
          },
        );
      },
      label: const Text("Nuovo modello"),
      icon: const Icon(Icons.add),
    );
  }

  Future<FilePickerResult?> _pickFile(context) async {
    FilePickerResult? result;
    try {
      result = await FilePickerWeb.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ["docx", "txt"],
      );
    } catch (e) {
      debugPrint("Error: $e");
      ConfirmationMessage.show(
          context, "Errore", "Errore durante il caricamento del file: $e");
    }
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }
}
