import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:provider/provider.dart";
import "../../services/auth.dart";
import "../../services/services.dart";

class LoginBlock extends StatefulWidget {
  const LoginBlock({super.key});

  @override
  State<LoginBlock> createState() => _LoginBlockState();
}

class _LoginBlockState extends State<LoginBlock> {
  // Add a boolean state to track if the login process is ongoing
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _isLoggingIn
            ? const CircularProgressIndicator() // Show loading indicator if logging in
            : Column(
                children: [
                  const SizedBox(height: 10),
                  loginButton(
                    context,
                    const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    Colors.green[300] ?? Colors.green,
                    Colors.white,
                    () => AuthService().googleLogin(),
                    "Log in with Google",
                  )
                ],
              ),
      ],
    );
  }

  ElevatedButton loginButton(BuildContext context, Widget icon, Color bgColor,
      Color fgColor, Function authServiceCallback, String text) {
    return ElevatedButton.icon(
      icon: icon,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        minimumSize: Size(
          MediaQuery.of(context).size.width >= 600
              ? 400
              : MediaQuery.of(context).size.width * 0.9,
          50,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        setState(() {
          _isLoggingIn = true; // Start the login process
        });
        try {
          await authServiceCallback(); // Call the authService function here
          // Handle navigation or state changes after login if necessary
        } catch (e) {
          debugPrint("Error logging in: $e");
        } finally {
          Provider.of<DashboardProvider>(context, listen: false)
              .setAccountName(await AccountDb().getAccountName());
          setState(() {
            _isLoggingIn = false; // Reset login state
          });
        }
      },
      label: Text(text),
    );
  }
}
