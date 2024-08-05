import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';
import "package:path/path.dart" as p;

import 'services.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = FirebaseStorage.instance.ref();

}

class DocumentStorage extends StorageService {
  String? accountName;

  DocumentStorage({this.accountName});

  Future<void> uploadNewDocumentOriginal(
      String idPratica, String fileName, Uint8List file) async {
    final String accountName = await AccountDb().getAccountName();
    final String extension = p.extension(fileName);
    late String contentType;
    if (extension == ".txt") {
      contentType = "text/plain; charset=utf-8";
    } else if (extension == ".pdf") {
      contentType = "application/pdf";
    } else if (extension == ".docx") {
      contentType =
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    } else {
      throw Exception("File type not supported");
    }

    try {
      var docRef = storageRef.child(
          "accounts/$accountName/pratiche/$idPratica/documenti/originale_$fileName");
      await docRef.putData(file, SettableMetadata(contentType: contentType));
    } catch (e) {
      debugPrint("Error uploading file: $e");
      rethrow;
    }
  }

  Future<void> uploadNewDocumentText(
      String idPratica, String fileName, String text) async {
    final String accountName = await AccountDb().getAccountName();
    try {
      var docRef = storageRef.child(
          "accounts/$accountName/pratiche/$idPratica/documenti/$fileName");
      await docRef.putString(text, metadata: SettableMetadata(contentType: "text/plain; charset=utf-8"));
    } catch (e) {
      debugPrint("Error uploading file: $e");
      rethrow;
    }
  }

  Future<void> uploadJson(String path, String filenName, Map json) async {
    try {
      debugPrint("Uploading json");
      var docRef = storageRef.child(path).child(filenName);
      await docRef.putString(jsonEncode(json), metadata: SettableMetadata(contentType: "application/json"));
      debugPrint("Json uploaded");
    } catch (e) {
      debugPrint("Error uploading file: $e");
      rethrow;
    }
  }

/*   Uploads a generic document.
  [path] is the path to the document, e.g "accounts/lawli/pratiche/1/documenti/originale_filename.pdf"
  [file] is the file to upload in bytes */
  Future<void> uploadDocument(String path, Uint8List file) async {
    debugPrint("Uploading document");
    try {
      var docRef = storageRef.child(path);
      await docRef.putData(file);
    } catch (e) {
      debugPrint("Error uploading file: $e");
      rethrow;
    }
  }

  Future<Map?> getJson(String path, String fileName) async {
    try {
      final Uint8List? jsonString = await storageRef.child(path).child(fileName).getData();
      if (jsonString == null) {
        return null;
      } else {
        return jsonDecode(utf8.decode(jsonString));
      }
    } catch (e) {
      debugPrint("Error getting json: $e");
      rethrow;
    }
  }

  Future<void> deleteDocument(String path, String fileName) async {
    try {
      await storageRef.child(path).child(fileName).delete();
    } catch (e) {
      debugPrint("Error deleting file: $e");
      rethrow;
    }
  }

  Future<String> getTextDocument(String path) async {
    try {
      final Uint8List? u8list = await storageRef.child(path).getData();
      if (u8list != null) {
        return utf8.decode(u8list);
      } else {
        return "Riassunto non presente";
      }
    } on FirebaseException catch (e) {
      debugPrint("Failed fe with error '${e.code}': ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("Error else getting file: $e");
      rethrow;
    }
  }

  Future<Uint8List> getDocument(String path) async {
    try {
      final Uint8List? u8list = await storageRef.child(path).getData();
      if (u8list != null) {
        return u8list;
      } else {
        throw Exception("File not found");
      }
    } on FirebaseException catch (e) {
      debugPrint("Failed fe with error '${e.code}': ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("Error else getting file: $e");
      rethrow;
    }
  }

  String getOriginalDocumentUrl(String filename, double idPratica, String accountName) {
    final String url = "accounts/$accountName/pratiche/${idPratica.toString()}/documenti/originale_$filename";
    return url;
  }

  Future<String> getSummaryTextFromDocumento(String docFilename, double praticaId) async {
    accountName ??= await AccountDb().getAccountName();
    String filenameNoExtension = p.basenameWithoutExtension(docFilename);
    final String path = "accounts/$accountName/pratiche/${praticaId.toString()}/riassunti/$filenameNoExtension.txt";
    try {
      final Uint8List? u8list = await storageRef.child(path).getData();
      if (u8list != null) {
        return utf8.decode(u8list);
      } else {
        return "Riassunto non presente";
      }
    } catch (e) {
      debugPrint("Error getting file: $e");
      rethrow;
    }
  }
}
