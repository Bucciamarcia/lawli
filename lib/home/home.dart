import 'package:flutter/material.dart';
import 'package:lawli/home/login/login.dart';
import 'package:lawli/home/recent/recent.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.base;
    String? anonLogin = uri.queryParameters['anonlogin'];
    if (anonLogin == 'true' && Provider.of<DashboardProvider>(context, listen: true).isGuest == false) {
      return FutureBuilder(
        future: AuthService().anonLogin(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("ERROR!");
          } else {
            Provider.of<DashboardProvider>(context, listen: false)
                .setIsGuest(true);
            return const HomeScreenBuilder();
          }
        },
      );
    } else {
      return const HomeScreenBuilder();
    }
  }
}

class HomeScreenBuilder extends StatelessWidget {
  const HomeScreenBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("ERROR!");
          } else if (snapshot.hasData) {
            return FutureBuilder(
              future: AccountDb().getAccountName(), // Async operation here
              builder: (context, accountNameSnapshot) {
                if (accountNameSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
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
