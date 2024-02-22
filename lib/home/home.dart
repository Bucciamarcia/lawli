import 'package:flutter/material.dart';
import 'package:lawli/home/login/login.dart';
import 'package:lawli/home/recent/recent.dart';

import '../services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text("ERROR!");
          } else if (snapshot.hasData) {
            return const RecentScreen();
          } else {
            return const LoginScreen();
          }
        });
  }
}
