import 'dart:convert';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:file_picker/file_picker.dart";
import 'package:lawli/dashboard/uploadfile/upload_logic.dart';
import 'package:lawli/js/js_interop.dart';
import 'package:lawli/services/provider.dart';
import 'dart:js_util';
import "package:lawli/shared/shared.dart";
import 'package:provider/provider.dart';

class FormData extends StatefulWidget {
  final double idPratica;
  const FormData({super.key, required this.idPratica});

  @override
  State<FormData> createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  final NuovoDocumentoFormState formState = NuovoDocumentoFormState();
  List<PlatformFile> _uploadedFile = [];
  DateTime? data;

  // Struttura della pagina
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selettoreData(context),
        const SizedBox(height: 30),
        selettoreFile(context),
        const SizedBox(height: 30),
        bottoni(context),
        selettoreCartellaPratica(context)
      ],
    );
  }

  // Vari elementi della pagina
  Row selettoreCartellaPratica(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text("Carica una cartella",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    Text(
                        "Tutti i file saranno caricati nella pratica: ${Provider.of<DashboardProvider>(context).pratica.titolo}.",
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Text(
                        "Nota: non verranno caricati i file nelle sotto-cartelle."),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CaricaCartellaButton(widget: widget, data: data),
            ],
          ),
        ),
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
                  labelText: "Data di creazione del documento",
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
              Text("Inserisci la data in cui il documento è stato creato.",
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
              Text(
                  "Seleziona un file da caricare. Formati supportati. pdf, docx, txt.",
                  style: Theme.of(context).textTheme.labelSmall)
            ],
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: _pickFile,
          child: const Text(
            "Carica file",
          ),
        ),
      ],
    );
  }

  Row bottoni(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        bottoneCancella(context),
        const SizedBox(width: 20),
        bottoneCarica(context),
      ],
    );
  }

  ElevatedButton bottoneCarica(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.green[700])),
      onPressed: () async {
        if (_uploadedFile.isNotEmpty &&
            (formState.filenameController.text.endsWith(".txt") ||
                formState.filenameController.text.endsWith(".docx") ||
                formState.filenameController.text.endsWith(".pdf"))) {
          DocumentUploader uploader = DocumentUploader(
              idPratica: widget.idPratica,
              fileName: formState.filenameController.text,
              file: _uploadedFile.first.bytes!,
              data: data);
          uploader.uploadDocument(context);
        } else if (_uploadedFile.isEmpty ||
            formState.filenameController.text.isEmpty ||
            formState.dateController.text.isEmpty) {
          showFillFieldsDialog(context);
        } else {
          showWrongFormatDialog(context);
        }
      },
      child: const Text(
        "Carica documento",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Future<dynamic> showWrongFormatDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Errore"),
          content: const Text(
              "Formato file non valido. Carica un file .pdf, .docx o .txt."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showFillFieldsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Errore"),
          content:
              const Text("Seleziona un file da caricare e una data valida."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showErrorDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Errore"),
          content: const Text("Errore durante il caricamento del documento."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showConfirmationDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Successo"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showCircularProgressIndicator(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  ElevatedButton bottoneCancella(BuildContext context) {
    return ElevatedButton(
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
    );
  }

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

class CaricaCartellaButton extends StatelessWidget {
  const CaricaCartellaButton({
    super.key,
    required this.widget,
    required this.data,
  });

  final FormData widget;
  final DateTime? data;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          try {
            await selectFolderAndUpload(
              allowInterop(
                (List<dynamic> files) async {
                  if (files.isNotEmpty) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: ((context) {
                        return const AlertDialog(
                          title: Text("Caricamento in corso..."),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text(
                                  "Caricamento della cartella in corso, attendere prego."),
                              SizedBox(height: 10),
                              Text(
                                  "NOTA: A seconda della dimensione della cartella, il caricamento potrebbe richiedere del tempo.")
                            ],
                          ),
                        );
                      }),
                    );
                  }
                  for (var file in files) {
                    var jsFile = jsify(file);
                    UploadFile uploadFile = UploadFile(
                        b64Content: getProperty(jsFile, 'content'),
                        filename: getProperty(jsFile, 'name'));
                    uploadFile.content = uploadFile.getBytes();
                    DocumentUploader uploader = DocumentUploader(
                        file: uploadFile.content!,
                        fileName: uploadFile.filename,
                        idPratica: widget.idPratica,
                        data: data,
                        showPopup: false);
                    if (uploadFile.filename.endsWith(".txt") ||
                        uploadFile.filename.endsWith(".docx") ||
                        uploadFile.filename.endsWith(".pdf")) {
                      debugPrint(
                          "File ${uploadFile.filename} supportato: caricamento in corso...");
                      await uploader
                          .uploadDocument(context); // Await the upload
                    } else {
                      debugPrint("File ${uploadFile.filename} non supportato");
                    }
                  }
                  CircularProgress.pop(context);
                  ConfirmationMessage.show(
                      context, "Successo", "Cartella caricata con successo.");
                },
              ),
            );
          } catch (e) {
            debugPrint("Errore durante il caricamento: $e");
            CircularProgress.pop(context);
            ConfirmationMessage.show(context, "Errore",
                "Si è verificato un errore durante il caricamento.");
          }
        },
        style: Theme.of(context).elevatedButtonTheme.style!,
        child: const Text('Carica cartella'));
  }
}

void selectAndUpload() {}

class NuovoDocumentoFormState {
  TextEditingController dateController = TextEditingController();
  TextEditingController filenameController = TextEditingController();
  TextEditingController directoryController = TextEditingController();

  void clearAll() {
    dateController.clear();
    filenameController.clear();
  }
}

class UploadFile {
  final String filename;
  final String b64Content;
  Uint8List? content;

  UploadFile({required this.filename, required this.b64Content, this.content});

  Uint8List getBytes() {
    return base64Decode(b64Content.split(',').last);
  }
}
