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

  String getOriginalDocumentUrl(String filename, double idPratica, String accountName) {
    final String url = "accounts/$accountName/pratiche/${idPratica.toString()}/documenti/originale_$filename";
    return url;
  }
}
