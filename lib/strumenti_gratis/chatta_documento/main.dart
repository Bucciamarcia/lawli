import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lawli/shared/upload_file.dart';
import 'package:lawli/strumenti_gratis/chatta_documento/provider.dart';
import 'package:provider/provider.dart';

class ChatMainStandalone extends StatelessWidget {
  const ChatMainStandalone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              FileUploader(
                labelText: "Carica un documento per chattare",
                helperText: "Carica un documento per chattare",
                buttonText: "Carica",
                onFileSelected: (PlatformFile? file) {
                  Provider.of<DocumentChatterProvider>(context, listen: false)
                      .updateFile(file);
                },
              ),
              if (Provider.of<DocumentChatterProvider>(context, listen: true)
                      .file !=
                  null)
                Text(Provider.of<DocumentChatterProvider>(context, listen: true)
                    .file!
                    .name),
            ],
          ),
        ),
      ),
    );
  }
}
