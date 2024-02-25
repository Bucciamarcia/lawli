import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "dart:async";
import "../services/auth.dart";
import "../services/models.dart";
import "dart:developer";

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = AuthService().userId();

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

  Future<void> addUserToDb(final String id, final bool anon) async {
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

  Future<DocumentReference<Map<String, dynamic>>> retrieveAccountObject() async {
    try {
      final userDocument = await _db.collection("users").doc(userId).get();
      final accountName = userDocument.get('account');
      return _db.collection("accounts").doc(accountName);
    } catch (e) {
      log("Error retrieving account name");
      rethrow;
    }
  }

}

class AccountDb extends FirestoreService {

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

class AssistitoDb extends FirestoreService {

  Future<void> deleteAssistito(final double assistitoId) async {
    try {
      final accountRef = await retrieveAccountObject();
      await accountRef.collection("assistiti").doc(assistitoId.toString()).delete();
      debugPrint("Deleted assistito $assistitoId");
      await decreaseCounter();
    } catch (e) {
      debugPrint("Error deleting assistito: $e");
    }
  }

  Future<void> decreaseCounter() async {
    try {
      final accountRef = await retrieveAccountObject();
      final statsRef = accountRef.collection("stats").doc("assistiti counter");
      final statsDoc = await statsRef.get();
      final activeAssistiti = statsDoc.get("active assistiti");
      await statsRef.update({
        "active assistiti": activeAssistiti - 1,
      });
      debugPrint("Decreased assistiti counter");
    } catch (e) {
      debugPrint("Error decreasing assistiti counter: $e");
    }
  }
}

class RetrieveObjectFromDb extends FirestoreService {

  Future<List<Assistito>> getAssistiti() async {
    String accountName = await AccountDb().getAccountName();

    var ref = _db.collection("accounts").doc(accountName).collection("assistiti");
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Assistito.fromJson(d));
    return topics.toList();
  }
  
}