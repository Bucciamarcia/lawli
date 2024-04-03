import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MotoreRicercaSentenze extends StatefulWidget {
  const MotoreRicercaSentenze({super.key});

  @override
  State<MotoreRicercaSentenze> createState() => _MotoreRicercaSentenzeState();
}

class _MotoreRicercaSentenzeState extends State<MotoreRicercaSentenze>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Parole chiave"),
            Tab(text: "Documento"),
            Tab(text: "Pratica"),
          ],
        ),
        SizedBox(
          height: 1200,
          child: TabBarView(
            controller: _tabController,
            children: const [
              RicercaParoleChiave(),
              Text("tab 2 content"),
              Text("tab 3 content"),
            ],
          ),
        ),
      ],
    );
  }
}


class RicercaParoleChiave extends StatefulWidget {
  const RicercaParoleChiave({super.key});

  @override
  State<RicercaParoleChiave> createState() => _RicercaParoleChiaveState();
}

class _RicercaParoleChiaveState extends State<RicercaParoleChiave> {
  final _textController = TextEditingController();
  String _resultText = ''; // Store the result string

  // Example placeholder async method
  Future<String> textSendButtonPressed(String text) async {
    // Replace this with your actual async logic
    return "Long result string based on input: $text"; 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null, // Allow multiple lines
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Inserisci il testo da cercare...',
                ),
                onChanged: (value) {
                  // Update the button state based on input
                  setState(() {}); 
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              style: ButtonStyle(iconSize: MaterialStateProperty.all(50)),
              tooltip: _textController.text.isNotEmpty
                  ? 'Invia il testo'
                  : 'Inserisci del testo per inviare',
              onPressed: _textController.text.isNotEmpty
                  ? () async {
                      // Only send if the input isn't empty
                      final result = await textSendButtonPressed(_textController.text);
                      setState(() {
                        _resultText = result;
                        _textController.clear(); // Clear input after sending
                      });
                    }
                  : null, // Disable the button if text is empty
            ),
          ],
        ),
        if (_resultText.isNotEmpty) // Only show result area if there's text
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Row(
              children: [
                Expanded(child: SelectableText(_resultText)), // Make text selectable
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _resultText));
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
