import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';
import "package:path/path.dart" as p;

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

  // Given a folder path, delete all the files in the folder and all the subfolders
  Future<void> deleteDocumentRecursive(String path) async {
    try {
      
    } catch (e) {
      debugPrint("Error deleting file: $e");
      rethrow;
    }
  }
}
