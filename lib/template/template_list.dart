import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';
import 'package:lawli/services/models.dart';

class TemplateList extends StatelessWidget {
  const TemplateList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Template>>(
      stream: RetrieveObjectFromDb().streamTemplates(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Errore durante il caricamento dei modelli');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.data!.isEmpty) {
          return const Text('Nessun modello presente');
        } else {
          return Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: snapshot.data!.map((template) {
              return TemplateCard(template: template);
            }).toList(),
          );
        }
      },
    );
  }
}

class TemplateCard extends StatelessWidget {
  final Template template;

  const TemplateCard({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                template.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8.0),
              Text(
                template.briefDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: const Text('Usa template'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
