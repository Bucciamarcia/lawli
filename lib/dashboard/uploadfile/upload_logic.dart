import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:lawli/services/cloud_storage.dart';
import "package:path/path.dart" as p;

import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';

class DocumentUploader {
  double idPratica;
  String fileName;
  Uint8List file;
  DateTime? data;

  DocumentUploader({
    required this.idPratica,
    required this.fileName,
    required this.file,
    this.data,
  });

  /// Uploads a .docx file to the cloud storage
  Future<void> uploadDocx(BuildContext context) async {
    var filenameWithoutExtension = p.withoutExtension(fileName);
    final String docxText = docxToText(file);
    await DocumentStorage().uploadNewDocumentText(
        idPratica.toString(), "$filenameWithoutExtension.txt", docxText);

    if (!context.mounted) {
      debugPrint("Context not mounted");
      return;
    }
    Navigator.of(context).pop();
    showConfirmationDialog(context, "Documento caricato con successo.");
  }

  /// Uploads a .pdf file to the cloud storage
  Future<void> uploadPdf(BuildContext context) async {
    await FirebaseFunctions.instance
        .httpsCallable("get_text_from_pdf")
        .call(<String, dynamic>{
      "idPratica": idPratica,
      "fileName": fileName,
      "fileBytes": file,
      "accountName": await AccountDb().getAccountName(),
    });

    if (!context.mounted) {
      debugPrint("Context not mounted");
      return;
    }
    Navigator.of(context).pop();
    showConfirmationDialog(context,
        "Documento caricato con successo.\n\nNOTA: Elaborare un file PDF potrebbe richiedere da 1 a 10 minuti a seconda di lunghezza e complessità.");
  }

  /// Uploads a .txt file to the cloud storage
  Future<void> uploadTxt(BuildContext context) async {
    await DocumentStorage().uploadNewDocumentText(
        idPratica.toString(), fileName, String.fromCharCodes(file));

    if (!context.mounted) {
      debugPrint("Context not mounted");
      return;
    }
    Navigator.of(context).pop();
    showConfirmationDialog(context, "Documento caricato con successo.");
  }

  /// Upload a generic file to the cloud storage.
  /// Decides on the file type and calls the appropriate method.
  Future<void> uploadDocument(BuildContext context) async {
    // TODO: #11 Create function to extract date from document.
    data ??= DateTime.now();
    if (fileName.endsWith(".txt") ||
        fileName.endsWith(".pdf") ||
        fileName.endsWith(".docx")) {
      try {
        showCircularProgressIndicator(context);
        await PraticheDb().addNewDocument(fileName, data!, idPratica);
        final String fileExtension = p.extension(fileName);
        if (fileExtension == ".docx") {
          await uploadDocx(context);
        } else if (fileExtension == ".pdf") {
          await uploadPdf(context);
        } else if (fileExtension == ".txt") {
          await uploadTxt(context);
        } else {
          if (!context.mounted) return;
          Navigator.of(context).pop();
          showWrongFormatDialog(context);
        }
        await DocumentStorage()
            .uploadNewDocumentOriginal(idPratica.toString(), fileName, file);
      } catch (e) {
        if (!context.mounted) {
          debugPrint("Context not mounted");
          return;
        }
        Navigator.of(context).pop();
        debugPrint("ERROR: ${e.toString()}");
        showErrorDialog(context);
      }
    } else {
      showWrongFormatDialog(context);
    }
  }
}

Future<dynamic> showWrongFormatDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Errore"),
        content: const Text(
            "Formato file non valido. Carica un file .pdf, .docx o .txt. \n Nota che i file .doc non sono supportati."),
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
