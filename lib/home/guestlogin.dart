import 'package:flutter/material.dart';
import 'package:lawli/services/auth.dart';
import 'package:lawli/services/provider.dart';
import 'package:provider/provider.dart';

class GuestLogin extends StatefulWidget {
  const GuestLogin({super.key});

  @override
  State<GuestLogin> createState() => _GuestLoginState();
}

class _GuestLoginState extends State<GuestLogin> {
  @override
  @override
  void initState() {
    super.initState();

    // Defer the state modification to after the build process is completed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).setIsGuest(true);
      _anonLogin();
    });
  }

  void _anonLogin() async {
    await AuthService().anonLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(child: Text("Creazione in corso..")),
    );
  }
}
