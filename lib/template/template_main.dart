import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

class TemplateHomeWidget extends StatelessWidget {
  const TemplateHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TemplateProvider(),
      child: Column(
        children: [
          const SizedBox(
            width: 400,
            height: 250,
            child: Placeholder(),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder(
                future: RetrieveObjectFromDb().getPratiche(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Errore");
                  } else {
                    return Text("Pratiche: ${snapshot.data}");
                  }
                },
              ),
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text("Nuovo modello"),
                icon: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}
