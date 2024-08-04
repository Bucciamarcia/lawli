import 'package:flutter/material.dart';
import "package:lawli/account/main.dart";
import "../../shared/shared.dart";
import "../../services/services.dart";
import "models.dart";

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: ResponsiveLayout.mainWindowPadding(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Text(
                    "Account",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                FutureBuilder(
                  future: RetrieveObjectFromDb().getAccount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.data == null) {
                      return const Text("No account found");
                    } else {
                      final AccountInfo account = snapshot.data!;
                      return AccountMainView(account: account);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Assistiti"),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return DesktopVersion(body: body(context), appBar: appBar(context));
        } else {
          return MobileVersion(body: body(context), appBar: appBar(context));
        }
      },
    );
  }
}
