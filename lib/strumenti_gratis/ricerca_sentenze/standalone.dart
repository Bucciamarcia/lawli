import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/services.dart';
import 'motore_ricerca_sentenze.dart';

class RicercaSentenzeStandalone extends StatefulWidget {
  const RicercaSentenzeStandalone({super.key});

  @override
  State<RicercaSentenzeStandalone> createState() =>
      RicercaSentenzeStandaloneState();
}

class RicercaSentenzeStandaloneState extends State<RicercaSentenzeStandalone> {
  @override
  initState() {
    super.initState();
    var dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    if (dashboardProvider.isGuest == false) {
      try {
        AuthService().anonLogin();
        Provider.of<DashboardProvider>(context, listen: true).setIsGuest(true);
      } catch (e) {
        debugPrint("Couldn't login");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("ERROR!");
          } else if (snapshot.hasData) {
            return const StandaloneBuilder();
          } else {
            return const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class StandaloneBuilder extends StatelessWidget {
  const StandaloneBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: AccountDb().getAccountName(), // Async operation here
        builder: (context, accountNameSnapshot) {
          if (accountNameSnapshot.connectionState == ConnectionState.waiting) {
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
            return Container(
              alignment: Alignment.topCenter,
              padding: ResponsiveLayout.mainWindowPadding(context),
              child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child:
                        SingleChildScrollView(child: MotoreRicercaSentenze()),
                  )),
            );
          }
        },
      ),
    );
  }
}
