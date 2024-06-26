import 'package:flutter/material.dart';
import "../services/services.dart";

class ResponsiveDrawer extends StatefulWidget {
  const ResponsiveDrawer({super.key});

  @override
  State<ResponsiveDrawer> createState() => _ResponsiveDrawerState();
}

class _ResponsiveDrawerState extends State<ResponsiveDrawer> {
  // State variable to track if user is signed in
  bool isUserSignedIn = false;

  @override
  void initState() {
    super.initState();
    checkUserSignInStatus();
  }

  void checkUserSignInStatus() async {
    bool signedIn = AuthService().isSignedIn();
    setState(() {
      isUserSignedIn = signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
          ResponsiveLayout.isDesktop(context) ? Colors.grey[300] : null,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children: isUserSignedIn
            ? MenuElements(context: context).loggedInElements()
            : MenuElements(context: context).loggedOutElements(),
      ),
    );
  }
}

class MenuElements {
  final BuildContext context;
  List<Widget> listElements = [];

  MenuElements({required this.context});

  loggedInElements() {
    listElements = [
      SizedBox(
          height: ResponsiveLayout.isDesktop(context) ? 100 : null,
          child: const DrawerHeader(child: Text('Menù principale'))),
      ListTile(
        title: const Text('Assistiti'),
        onTap: () {
          Navigator.pushNamed(context, '/assistiti');
        },
      ),
      ListTile(
        title: const Text("Pratiche"),
        onTap: () {
          Navigator.pushNamed(context, '/pratiche');
        },
      ),
      ListTile(
        title: const Text("Ricerca sentenze"),
        onTap: () {
          Navigator.pushNamed(context, '/ricerca_sentenze');
        },
      ),
      ListTile(title: const Text("Logout"),
          onTap: () async {
            await AuthService().signOut();
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }),
    ];
    return listElements;
  }

  loggedOutElements() {
    listElements = [
      const ListTile(title: Text('Log in')),
    ];
    return listElements;
  }
}
