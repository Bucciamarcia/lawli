import 'package:flutter/material.dart';
import 'package:lawli/services/auth.dart';

class GuestLogin extends StatefulWidget {
  const GuestLogin({super.key});

  @override
  State<GuestLogin> createState() => _GuestLoginState();
}

class _GuestLoginState extends State<GuestLogin> {
  @override
  void initState() async {
    super.initState();
    await AuthService().anonLogin();
  }
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: Text("Creazione in corso..")
      ),
    );
  }
}