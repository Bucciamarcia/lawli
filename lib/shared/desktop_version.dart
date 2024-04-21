import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';
import 'package:lawli/services/provider.dart';
import 'package:lawli/shared/shared.dart';
import 'package:provider/provider.dart';

class DesktopVersion extends StatelessWidget {
  final Widget body;
  final AppBar appBar;
  const DesktopVersion({super.key, required this.body, required this.appBar});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setAccountId(context));

    return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            const SizedBox(
              width: 300,
              child: ResponsiveDrawer(),
            ),
            Expanded(
              child: Center(
                child: body,
              ),
            ),
          ],
        ));
  }

  void setAccountId(context) async {
    if (Provider.of<DashboardProvider>(context, listen: false).accountName ==
        "") {
      Provider.of<DashboardProvider>(context, listen: false)
          .setAccountName(await AccountDb().getAccountName());
    }
  }
}
