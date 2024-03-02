import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadNewDocument (String idPratica, String fileName, Uint8List file) async {

    final String accountName = await AccountDb().getAccountName();

    try {
      var docRef = storageRef.child("accounts/$accountName/pratiche/$idPratica/documenti/$fileName");
      await docRef.putData(file);
    } catch (e) {
      debugPrint("Error uploading file: $e");
    }
  }

}