import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "dart:async";
import "../services/auth.dart";
import "dart:developer";

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = AuthService().userId();

  Future<void> addUser() async {
    try {
      await _db.collection('users').doc(userId).set({
        'full_name': 'Full Name',
        'company': 'Company Name',
        'age': 42,
        'email': ''
      });
    } catch (e) {
      log('Error writing document: $e');
    }
  }
}

class CreateMemory {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = AuthService().userId();
  final List<double> embeddings;
  final String memoryText;

  CreateMemory({required this.embeddings, required this.memoryText});

  Future<double> addPermanent() async {
    try {
      _db.collection("users").doc(userId).collection("memories").add({
        "embeddings": embeddings,
        "memoryText": memoryText,
        "timestamp": DateTime.now(),
        "isTemporary": false,
      });
      return 200;
    } catch (e) {
      debugPrint("Error adding memory: $e");
      return 500;
    }
  }

  Future<double> addTemporary(DateTime expirationDate) async {
    try {
      _db.collection("users").doc(userId).collection("memories").add({
        "embeddings": embeddings,
        "memoryText": memoryText,
        "timestamp": DateTime.now(),
        "isTemporary": true,
        "expirationDate": expirationDate,
      });
      return 200;
    } catch (e) {
      debugPrint("Error adding memory: $e");
      return 500;
    }
  }
}

class CreateUserData {
  Future<void> addToDb(final String id, final bool anon) async {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .set(
        {
          "isAnonymous": anon,
        },
      );
      debugPrint("Added anon $id user to db");
    } catch (e) {
      debugPrint("Error adding anon user to db: $e");
    }
  }
}
