import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lawli/shared/confirmation_message.dart';

Future<FilePickerResult?> pickFile(context,
    {required List<String> allowedExtensions,
    bool allowMultiple = true}) async {
  FilePickerResult? result;
  try {
    result = await FilePickerWeb.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
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
