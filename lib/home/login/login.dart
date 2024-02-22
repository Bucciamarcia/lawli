import 'package:flutter/material.dart';
import "../../shared/shared.dart";
import 'loginblock.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Variables
    const padding = Padding(padding: EdgeInsets.all(20));
    final logoImage = Image.asset(
      logoPath,
      width: MediaQuery.of(context).size.width * 0.3,
    );
    // End variables

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[logoImage, padding, const LoginBlock()])),
    );
  }
}
