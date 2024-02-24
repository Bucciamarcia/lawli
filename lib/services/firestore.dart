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

  Future<Object?> getUserData(String user) async {
    try {
      final DocumentSnapshot userDoc = await _db.collection('users').doc(user).get();
      if (userDoc.data() == null) {
        log("User data null");
      } else {
        log("User data existing");
      }
      return userDoc.data();
    } catch (e) {
      log('Error getting user data: $e');
      return null;
    }
  }
}

class AccountDb {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = AuthService().userId();

  Future<String> getAccountName() async {
    try {
      final DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
      return userDoc.get('account');
    } catch (e) {
      log('Error getting account name: $e');
      return "Error";
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
          "account": false,
        },
      );
      debugPrint("Added anon $id user to db");
    } catch (e) {
      debugPrint("Error adding anon user to db: $e");
    }
  }
}
