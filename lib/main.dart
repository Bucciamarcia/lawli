import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'routes.dart';
import 'services/provider.dart';
import "themes.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => DashboardProvider(),
      child: const LoginChecker(
        child: MyApp(),
      ),
    ),
  );
}

class LoginChecker extends StatefulWidget {
  final Widget child;

  const LoginChecker({super.key, required this.child});

  @override
  _LoginCheckerState createState() => _LoginCheckerState();
}

class _LoginCheckerState extends State<LoginChecker> {
  Future<void>? _anonLoginFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_anonLoginFuture == null) {
      _checkAnonLogin();
    }
  }

  void _checkAnonLogin() {
    final Uri uri = Uri.base;
    final String? anonLogin = uri.queryParameters['anonlogin'];
    final auth = FirebaseAuth.instance;
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);

    if (anonLogin == 'true' && !dashboardProvider.isGuest) {
      if (auth.currentUser == null || !auth.currentUser!.isAnonymous) {
        _anonLoginFuture = auth.signInAnonymously().then((value) {
          dashboardProvider.setIsGuest(true);
        });
        setState(() {}); // Trigger a rebuild to show the FutureBuilder
      } else {
        dashboardProvider.setIsGuest(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_anonLoginFuture != null) {
      return FutureBuilder(
        future: _anonLoginFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: Text('Error logging in')),
              ),
            );
          } else {
            return widget.child;
          }
        },
      );
    } else {
      return widget.child;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lawli",
      theme: LightTheme().themeData,
      routes: routes,
    );
  }
}
