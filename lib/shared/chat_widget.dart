import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class ChatView extends StatefulWidget {
  final String? filePath;
  final String? threadId;
  const ChatView({
    super.key,
    this.filePath,
    this.threadId,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  String? textforBackend;
  Documento? documentoSelected;
  String? _currentThreadId;
  String? assistantName;
  String? assistantId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _clearChatHistory() {
    _currentThreadId = null;
    setState(() {
      _messages.clear();
    });
  }

  void _sendMessage(pratica) async {
    if (_inputController.text.isNotEmpty) {
      // String documentoFilenameNoExt = documentoSelected!.filename.split(".")[0];
      // String accountName = Provider.of<DashboardProvider>(context, listen: false).accountName;
      textforBackend = _inputController.text;
      setState(() {
        _messages
            .add(ChatMessage(text: _inputController.text, isUserMessage: true));
        _inputController.clear();
      });
      int tokens = 1000; //await DocumentManipulation().countDocumentoTokens(
      // "accounts/$accountName/pratiche/${pratica.id.toString()}/documenti/$documentoFilenameNoExt.txt");
      if (tokens > 1) {
        // Structure ready to bypass thread and assistants.
        setState(
          () {
            // Create a thread if needed
            if (_currentThreadId == null) {
              _createThread().then((threadId) {
                _currentThreadId = threadId;
                // Now proceed to send the message with the threadId
                _sendBackendMessage(textforBackend!, threadId, pratica);
              });
            } else {
              _sendBackendMessage(textforBackend!, _currentThreadId!, pratica);
            }

            FocusScope.of(context).requestFocus(_inputFocusNode);
          },
        );
      } else {
        setState(
          () {
            // Placeholder if want to bypass threads and assistants.
          },
        );
      }
    }
  }

  Future<String> _createThread() async {
    var createThreadResponse =
        await FirebaseFunctions.instance.httpsCallable("create_thread").call();
    return createThreadResponse.data as String;
  }

  void _sendBackendMessage(
    String message,
    String threadId,
    Pratica pratica,
  ) async {
    _addBotMessage("Cercando l'assistente...");
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    Documento? documento = documentoSelected;

    if (documento?.assistantId == null) {
      _removeLastMessage();
      _addBotMessage("Assistente non trovato. Creazione assistente...");
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      var response = await FirebaseFunctions.instance
          .httpsCallable("create_assistant")
          .call(
        {
          "assistantName": assistantName,
        },
      );
      String assistantId = response.data as String;
      DocumentoDb().updateDocument(pratica.id, assistantName!, {
        "assistantId": assistantId,
      });
      documento?.assistantId = assistantId;
    } else {
      _removeLastMessage();
      _addBotMessage("Assistente trovato. Invio messaggio...");
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
    _removeLastMessage();
    _addBotMessage("Sto pensando...");
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    var responseInterrogateChatbot = await FirebaseFunctions.instance
        .httpsCallable("interrogate_chatbot")
        .call(
      {
        "assistantName": assistantName,
        "assistantId": documento?.assistantId,
        "message": message,
        "threadId": threadId,
      },
    );
    List chatbotResponses = responseInterrogateChatbot.data as List;
    _removeLastMessage();
    for (String response in chatbotResponses) {
      _addBotMessage(response);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUserMessage: false));
    });
  }

  // Removes the last message from the chat window
  void _removeLastMessage() {
    if (_messages.isNotEmpty) {
      setState(() {
        _messages.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Pratica pratica =
        Provider.of<DashboardProvider>(context, listen: false).pratica;
    return FutureBuilder(
      future: RetrieveObjectFromDb().doDocumentsExist(pratica.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Align(
              alignment: Alignment.topCenter,
              child: Text("Errore nel caricamento dei documenti"));
        } else if (snapshot.data == null || snapshot.data == false) {
          return const Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Nessun documento trovato: carica un documento per attivare il chatbot.",
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return Column(
            children: <Widget>[
              dropDownDocumentSelector(pratica),
              const ChatbotHeader(),
              messagesList(),
              messageInputField(pratica),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  FutureBuilder<List<Documento>> dropDownDocumentSelector(Pratica pratica) {
    return FutureBuilder(
        future: RetrieveObjectFromDb().getDocumenti(pratica.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Errore nel caricamento dei documenti");
          } else if (snapshot.data == null) {
            return const Text("Nessun documento trovato");
          } else if (snapshot.hasData && snapshot.data != null) {
            debugPrint("DEBUG: Pratica: ${pratica.titolo}");
            debugPrint("DEBUG: Documento: ${snapshot.data!.first.filename}");
            List<String> docNames = [];
            for (Documento doc in snapshot.data!) {
              docNames.add(doc.filename);
            }
            debugPrint("DEBUG: Documenti: $docNames");
            return DropdownButton<String>(
              hint: const Text("Seleziona un documento"),
              value: assistantName,
              isExpanded: true,
              items: docNames.map((String name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  assistantName = newValue;
                  documentoSelected = snapshot.data!.firstWhere(
                    (object) => object.filename == newValue,
                  );
                });
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Container messageInputField(pratica) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              focusNode: _inputFocusNode,
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: 'Scrivi un messaggio...'),
              onSubmitted: (_) => _sendMessage(pratica),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            tooltip: "Invia",
            onPressed: () => _sendMessage(pratica),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trash),
            tooltip: "Cancella la chat",
            onPressed: _clearChatHistory,
          ),
        ],
      ),
    );
  }

  Expanded messagesList() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return _buildMessageRow(_messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageRow(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      alignment:
          message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isUserMessage ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(message.text),
      ),
    );
  }
}

class ChatbotHeader extends StatelessWidget {
  const ChatbotHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Chatta con l'assistente",
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}
