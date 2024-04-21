import 'package:flutter/material.dart';
import 'package:lawli/home/login/login.dart';
import 'package:lawli/home/recent/recent.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

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
            return FutureBuilder(
              future: AccountDb().getAccountName(), // Async operation here
              builder: (context, accountNameSnapshot) {
                if (accountNameSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (accountNameSnapshot.hasError) {
                  return const Text('Error getting name');
                } else {
                  return const RecentScreen(); 
                }
              },
            );
          } else {
            return const LoginScreen();
          }
        });
  }
}
