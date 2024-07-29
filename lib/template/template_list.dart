import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';
import 'package:lawli/services/models.dart';
import 'package:lawli/shared/confirmation_message.dart';
import 'package:lawli/template/provider.dart';
import 'package:provider/provider.dart';

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
          return Column(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: const SearchBar(),
              ),
              const SizedBox(height: 20),
              Provider.of<TemplateProvider>(context).isSearchBoxEmpty
                  ? Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: snapshot.data!.map((template) {
                        return TemplateCard(template: template);
                      }).toList(),
                    )
                  : Text("Hewwo uwu"),
            ],
          );
        }
      },
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _handleSearchAction(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Cerca un modello',
        suffixIcon: IconButton(
          onPressed: () {
            _handleSearchAction(_controller.text);
          },
          icon: const Icon(Icons.search),
          tooltip: "Cerca template",
        ),
      ),
      onChanged: _onSearchChanged,
      onSubmitted: (value) {
        // You might still want to handle direct submissions, especially for 'enter' on keyboards
        _debounce?.cancel(); // Cancel any pending searches
        _handleSearchAction(value);
      },
    );
  }

  /// Action to perform when a search is triggered
  void _handleSearchAction(String query) {
    Provider.of<TemplateProvider>(context, listen: false).setResultsExist(false);
    if (query.isEmpty) {
      Provider.of<TemplateProvider>(context, listen: false)
          .setSearchBoxEmpty(true);
    } else {
      Provider.of<TemplateProvider>(context, listen: false)
          .setSearchBoxEmpty(false);
      FutureBuilder(
        future: _searchTemplate(query),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
                'Errore durante la ricerca dei modelli: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.data == null || snapshot.data == []) {
            return const Text("Nessun modello trovato");
          } else {
            Provider.of<TemplateProvider>(context, listen: false)
                .setResultsExist(true);
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

  Future<List<Template>?> _searchTemplate(String query) async {
    Provider.of<TemplateProvider>(context, listen: false).setSearching(true);
    try {
      var result = await FirebaseFunctions.instance
          .httpsCallable("search_similar_templates")
          .call(
        {"query": query, "account": await AccountDb().getAccountName()},
      );
      List<dynamic> data = result.data as List<dynamic>;
      List<Template> orderedTemplates = [];
      for (var o in data) {
        Map<String, dynamic> templateMap = o as Map<String, dynamic>;
        orderedTemplates.add(Template(
          briefDescription: templateMap["brief_description"] as String? ?? "",
          title: templateMap["title"] as String? ?? "",
          text: templateMap["text"] as String? ?? "",
        ));
      }
      debugPrint("Found ${orderedTemplates.length} templates");
      debugPrint("Titles: ${orderedTemplates.map((e) => e.title)}");
      return orderedTemplates;
    } catch (e) {
      ConfirmationMessage.show(
          context, "Errore", "Errore durante la ricerca dei modelli: $e");
      return null;
    } finally {
      Provider.of<TemplateProvider>(context, listen: false).setSearching(false);
    }
  }
}

class TemplateCard extends StatelessWidget {
  final Template template;

  const TemplateCard({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    child: const Text('Usa template'),
                  ),
                  IconButton(
                    tooltip: "Elimina template",
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
