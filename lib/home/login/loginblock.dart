import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:provider/provider.dart";
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
                    const FaIcon(FontAwesomeIcons.user, color: Colors.black),
                    Colors.grey[300] ?? Colors.grey,
                    Colors.black,
                    _handleGuestRegistration,
                    "Provalo come ospite",
                  ),
                  const SizedBox(height: 10),
                  loginButton(
                    context,
                    const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    Colors.green[300] ?? Colors.green,
                    Colors.white,
                    _handleGoogleLogin,
                    "Login con Google",
                  ),
                  const SizedBox(height: 10),
                  loginButton(
                      context,
                      const Icon(Icons.email, color: Colors.blue),
                      Colors.blue[200] ?? Colors.blue,
                      Colors.white,
                      _handleEmailLogin,
                      "Login con Email"),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _handleEmailRegistration,
                    child: const Text(
                      'Registra un account con email e password',
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Future<void> _handleGuestRegistration() async {

    await AuthService().anonLogin(context);
    Provider.of<DashboardProvider>(context, listen: false).setIsGuest(true);

  }

  Future<void> _handleEmailRegistration() async {
    String emailAddress = '';
    String password = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrazione con Email'),
          content: Column(
            children: [
              const Text('Inserisci email e password per registrarti.'),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    emailAddress = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Perform registration logic here
                await AuthService().emailRegistration(emailAddress, password);
                Navigator.of(context).pop();
              },
              child: const Text('Registrati'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancella'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleEmailLogin() async {
    String emailAddress = '';
    String password = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login con Email'),
          content: Column(
            children: [
              const Text('Inserisci email e password per fare login.'),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    emailAddress = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Perform login logic here
                await AuthService().emailLogin(emailAddress, password);
                Navigator.of(context).pop();
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancella'),
            ),
          ],
        );
      },
    );
  }

  ElevatedButton loginButton(BuildContext context, Widget icon, Color bgColor,
      Color fgColor, Future<void> Function() onPressed, String text) {
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
          _isLoggingIn = true;
        });

        try {
          await onPressed();
          debugPrint("LOGGED IN SUCCESSFULLY!");
        } catch (e) {
          debugPrint("Error logging in: $e");
        } finally {
          if (mounted) {
            setState(() {
              _isLoggingIn = false;
            });
          }
        }
      },
      label: Text(text),
    );
  }

  Future<void> _handleGoogleLogin() async {
    await AuthService().googleLogin();
  }
}
