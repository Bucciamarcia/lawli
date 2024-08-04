import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "dart:developer";
import "../services/firestore.dart";

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  User? getUser() {
    debugPrint("Getting user");
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      debugPrint("User not logged in in getUser");
      rethrow;
    }
  }

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);
      final loggedUser = FirebaseAuth.instance.currentUser;
      debugPrint("Logged in with Google. UserID: ${loggedUser!.uid}");
      final userData = await FirestoreService().getUserData(loggedUser.uid);
      if (userData == null) {
        await FirestoreService().addUserToDb(loggedUser.uid, false);
      }
    } on FirebaseAuthException catch (e) {
      log(e as String);
    }
  }

  Future<void> emailRegistration(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> emailLogin(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  String userId() {
    try {
      return FirebaseAuth.instance.currentUser!.uid;
    } catch (e) {
      debugPrint("User not logged in in userId");
      rethrow;
    }
  }

  bool isSignedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}
