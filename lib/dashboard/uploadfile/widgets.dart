import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:file_picker/file_picker.dart";
import "package:cloud_functions/cloud_functions.dart";

class FormData extends StatefulWidget {
  final double idPratica;
  const FormData({super.key, required this.idPratica});

  @override
  State<FormData> createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  final NuovoDocumentoFormState formState = NuovoDocumentoFormState();
  List<PlatformFile> _uploadedFile = [];
  late DateTime data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selettoreData(context),
        const SizedBox(height: 30),
        selettoreFile(context),
        const SizedBox(height: 30),
        bottoni(context),
      ],
    );
  }

  Row selettoreData(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Data",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                enabled: false,
                controller: formState.dateController,
              ),
              const SizedBox(height: 5),
              Text(
                  "La data è importante per il corretto funzionamento dell'AI.",
                  style: Theme.of(context).textTheme.labelSmall)
            ],
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () {
            showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now())
                .then(
              (value) {
                formState.dateController.text =
                    value.toString().substring(0, 10);

                if (value != null) {
                  data = value;
                }
              },
            );
          },
          child: const Text(
            "Seleziona data",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Row selettoreFile(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Nome file",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                controller: formState.filenameController,
              ),
              const SizedBox(height: 5),
              Text("Seleziona un file da caricare.",
                  style: Theme.of(context).textTheme.labelSmall)
            ],
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: _pickFile,
          child: const Text(
            "Carica file",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


  Row bottoni(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.grey[600]),
              ),
          onPressed: () {
            formState.clearAll();
            _uploadedFile.clear();
          },
          child: const Text(
            "Cancella",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
              backgroundColor: MaterialStateProperty.all(Colors.green[700])),
          onPressed: () {
            if (_uploadedFile.isNotEmpty) {
              FutureBuilder(
                future: functionUploadDocument(),
                builder:(context, snapshot) {
                  if (snapshot.connectionState ==ConnectionState.waiting) {
                    return const AlertDialog(
                      title: Text("Caricamento in corso"),
                      content: LinearProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Errore: ${snapshot.error}");
                  } else {
                    return const Text("Documento caricato con successo!");
                  }
                },
              );
            }
          },
          child: const Text(
            "Carica documento",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> functionUploadDocument() async {FirebaseFunctions.instance.httpsCallable("upload_document").call({
                  "idPratica": widget.idPratica,
                  "data": data.toString().substring(0, 10),
                  "filename": formState.filenameController.text,
                  "file": _uploadedFile.single.bytes,
                });}

  // Logica per caricare un file
  void _pickFile() async {
    FilePickerResult? result;
    if (kIsWeb) {
      result = await FilePickerWeb.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["pdf", "docx", "txt"],
      );
    } else {
      result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["pdf", "docx", "txt"],
      );
    }
    if (result != null) {
      setState(() {
        formState.filenameController.text = result!.files.single.name;
        _uploadedFile = result.files;
      });
    }
  }
}

class NuovoDocumentoFormState {
  TextEditingController dateController = TextEditingController();
  TextEditingController filenameController = TextEditingController();

  void clearAll() {
    dateController.clear();
    filenameController.clear();
  }
}
