import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "dart:developer";
import "../services/firestore.dart";

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();

      final anonUser = FirebaseAuth.instance.currentUser;
      debugPrint("Signed in anonymously. UserID: ${anonUser!.uid}");
      await CreateUserData().addToDb(anonUser.uid, true);
    } on FirebaseAuthException catch (e) {
      debugPrint("Error signing in anonymously: $e");
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
      await CreateUserData().addToDb(loggedUser.uid, false);
    } on FirebaseAuthException catch (e) {
      log(e as String);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  String userId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}
