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
      final DocumentSnapshot userDoc =
          await _db.collection('users').doc(user).get();
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
      FirebaseFirestore.instance.collection("users").doc(id).set(
        {
          "account": false,
        },
      );
      debugPrint("Added anon $id user to db");
    } catch (e) {
      debugPrint("Error adding anon user to db: $e");
    }
  }

  Future<DocumentReference<Map<String, dynamic>>>
      retrieveAccountObject() async {
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
      final DocumentSnapshot userDoc =
          await _db.collection('users').doc(userId).get();
      return userDoc.get('account');
    } catch (e) {
      log('Error getting account name: $e');
      return "Error";
    }
  }
}

class PraticheDb extends FirestoreService {
  Future<void> addNewDocument(String filename, DateTime date, double idPratica) async {
    final String accountName = await AccountDb().getAccountName();

    final data = <String, dynamic>{
      "filename": filename,
      "data": date,
    };

    try {
      final DocumentReference docs = _db.collection("accounts").doc(accountName).collection("pratiche").doc(idPratica.toString()).collection("documenti").doc(filename);
      await docs.set(data);
    } catch (e) {
      debugPrint("Error adding new document: $e");
      rethrow;
    }

  }
}

class AssistitoDb extends FirestoreService {
  Future<List> getAssistiti() async {
    try {
      final accountRef = await retrieveAccountObject();
      DocumentSnapshot docSnapshot = await accountRef.get();
      List assistiti = docSnapshot.get("lista_assistiti");
      return assistiti;
    } catch (e) {
      debugPrint("Error getting assistiti: $e");
      return [];
    }
  }

  Future<double> getIdFromNomeCognome(String nomeCompleto) async {
    try {
      final accountRef = await retrieveAccountObject();
      final assistitiRef = accountRef.collection("assistiti");
      final querySnapshot = await assistitiRef
          .where("nomeCompleto", isEqualTo: nomeCompleto)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var result = querySnapshot
            .docs.first.id;
        return double.parse(result);
      } else {
        throw "No matching document found";
      }
    } catch (e) {
      debugPrint("Error getting assistito id: $e");
      return 0;
    }
  }

  Future<void> deleteAssistito(final double assistitoId) async {
    await removeFromListaAssistiti(assistitoId);
    try {
      final accountRef = await retrieveAccountObject();
      await accountRef
          .collection("assistiti")
          .doc(assistitoId.toString())
          .delete();
    } catch (e) {
      debugPrint("Error deleting assistito: $e");
      rethrow;
    }
    await decreaseCounterAssistiti();
  }

  Future<void> deletePratica(final double praticaId) async {
    try {
      final accountRef = await retrieveAccountObject();
      await accountRef
          .collection("pratiche")
          .doc(praticaId.toString())
          .delete();
    } catch (e) {
      debugPrint("Error deleting pratica: $e");
      rethrow;
    }
    await decreaseCounterPratiche();
  }

  Future<void> decreaseCounterAssistiti() async {
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
      rethrow;
    }
  }

  Future<void> decreaseCounterPratiche() async {
    try {
      final accountRef = await retrieveAccountObject();
      final statsRef = accountRef.collection("stats").doc("pratiche counter");
      final statsDoc = await statsRef.get();
      final activePratiche = statsDoc.get("active pratiche");
      await statsRef.update({
        "active pratiche": activePratiche - 1,
      });
      debugPrint("Decreased pratiche counter");
    } catch (e) {
      debugPrint("Error decreasing pratiche counter: $e");
      rethrow;
    }
  }

  Future<void> removeFromListaAssistiti(assistitoId) async {
    DocumentReference docRef = await retrieveAccountObject();
    List<Assistito> assistiti = await RetrieveObjectFromDb().getAssistiti();
    Assistito assistito =
        assistiti.firstWhere((element) => element.id == assistitoId);

    String firstname = assistito.nome;
    String lastname = assistito.cognome;
    String fullName = "$firstname $lastname";

    try {
      DocumentSnapshot docSnapshot = await docRef.get();
      List listToUpdate = docSnapshot.get("lista_assistiti");
      debugPrint("LISTA: $listToUpdate");
      listToUpdate.remove(fullName);
      await docRef.update({"lista_assistiti": listToUpdate});
      debugPrint("Removed assistito from lista_assistiti");
    } on Exception catch (e) {
      debugPrint("Error removing assistito from lista_assistiti: $e");
      rethrow;
    }
  }
}

class RetrieveObjectFromDb extends FirestoreService {
  Future<List<Assistito>> getAssistiti() async {
    String accountName = await AccountDb().getAccountName();

    var ref =
        _db.collection("accounts").doc(accountName).collection("assistiti");
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Assistito.fromJson(d));
    return topics.toList();
  }

  Future<Assistito> getAssistito(String assistitoId) async {
    String accountName = await AccountDb().getAccountName();
    debugPrint("STARTING GET ASSISTITO");
    var ref = _db.collection("accounts").doc(accountName).collection("assistiti").doc(assistitoId);
    debugPrint("REF: $ref");
    var snapshot = await ref.get();
    debugPrint("SNAPSHOT: $snapshot");
    return Assistito.fromJson(snapshot.data() ?? {});

  }

  Future<List<Pratica>> getPratiche() async {
    String accountName = await AccountDb().getAccountName();

    var ref =
        _db.collection("accounts").doc(accountName).collection("pratiche");
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Pratica.fromJson(d));
    return topics.toList();
  }

  Future<Pratica> getPratica(double praticaId) async {
    String accountName = await AccountDb().getAccountName();
    var ref = _db
        .collection("accounts")
        .doc(accountName)
        .collection("pratiche")
        .doc(praticaId.toString());
    var snapshot = await ref.get();
    return Pratica.fromJson(snapshot.data() ?? {});
  }

  Future<List<Documento>> getDocumenti(double praticaId) async {
    String accountName = await AccountDb().getAccountName();
    var ref = _db
        .collection("accounts")
        .doc(accountName)
        .collection("pratiche")
        .doc(praticaId.toString())
        .collection("documenti");
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Documento.fromJson(d));
    return topics.toList();
  }
}