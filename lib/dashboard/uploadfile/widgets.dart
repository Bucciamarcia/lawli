import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:file_picker/file_picker.dart";

class FormData extends StatefulWidget {
  final double idPratica;
  const FormData({super.key, required this.idPratica});

  @override
  State<FormData> createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  String _fileName = '';
  List<PlatformFile> _uploadedFile = [];

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
        _fileName = result!.files.single.name;
        _uploadedFile = result.files;
      });
    }
  }  
  final NuovoDocumentoFormState formState = NuovoDocumentoFormState();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: formState.dataController,
          decoration: const InputDecoration(labelText: "Data"),
        ),
        ElevatedButton(
          onPressed: _pickFile,
          child: const Text("Carica file"),
        ),
        Text(_fileName),
      ],
    );
  }
}

class NuovoDocumentoFormState {
  final TextEditingController dataController = TextEditingController();
  final TextEditingController uploadController = TextEditingController();

  void clearAll() {
    dataController.clear();
    uploadController.clear();
  }
}
