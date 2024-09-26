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
  DashboardProvider? _dashboardProvider;

  @override
  void initState() {
    super.initState();

    // Defer the state modification to after the build process is completed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the provider without listening to avoid unnecessary rebuilds
      _dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);

      // Set isGuest to true
      _dashboardProvider!.setIsGuest(true);

      // Perform anonymous login
      _anonLogin();

      // Add a listener to respond to changes in the provider
      _dashboardProvider!.addListener(_providerListener);
    });
  }

  // Listener callback to respond to provider changes
  void _providerListener() {
    if (_dashboardProvider!.isGuest) {
      debugPrint("isGuest is true");
      Navigator.pushNamed(context, "/");
      _dashboardProvider!.removeListener(_providerListener);
    }
  }

  void _anonLogin() async {
    await AuthService().anonLogin();
    Navigator.pushNamed(context, "/");
  }

  @override
  void dispose() {
    // Remove the listener to prevent memory leaks
    _dashboardProvider?.removeListener(_providerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to isGuest changes to rebuild UI if necessary
    bool isGuest = Provider.of<DashboardProvider>(context).isGuest;

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            isGuest
                ? "Creazione account di prova in corso..."
                : "Un secondo...",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
