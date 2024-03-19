import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class ChatView extends StatefulWidget {
  final String lastMessage;
  final String? assistantId;
  final Documento? documentoSelected;
  final String? filePath;
  final String? threadId;
  const ChatView(
      {super.key,
      required this.lastMessage,
      this.assistantId,
      this.filePath,
      this.threadId,
      this.documentoSelected});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  String? _currentThreadId;
  String? selectedDocName;

  void _clearChatHistory() {
    _currentThreadId = null;
    setState(() {
      _messages.clear();
    });
  }

  void _sendMessage() {
    if (_inputController.text.isNotEmpty) {
      setState(() {
        _messages
            .add(ChatMessage(text: _inputController.text, isUserMessage: true));
        _inputController.clear();

        // Placeholder for sending to backend:

        // Create a thread if needed
        if (_currentThreadId == null) {
          _createThread().then((threadId) {
            _currentThreadId = threadId;
            // Now proceed to send the message with the threadId
            _sendBackendMessage(_inputController.text, threadId); 
          });          
        } else {
          _sendBackendMessage(_inputController.text, _currentThreadId!);
        }

        FocusScope.of(context).requestFocus(_inputFocusNode);
      });
    }
  }

  Future<String> _createThread() async {
    // TODO: Implement backend call to create a new thread and return the thread id
    return Future.delayed(const Duration(seconds: 1), () => 'testThreadId');
  }

  // Placeholder - Replace with your backend call
  void _sendBackendMessage(String message, String threadId) {
    // TODO: Implement backend call to send message and get the response, then use _addBotMessage to update the UI      
    Future.delayed(const Duration(seconds: 1), () => _addBotMessage('Thinking...')); 
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUserMessage: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Pratica pratica =
        Provider.of<DashboardProvider>(context, listen: false).pratica;
    return Column(
      children: <Widget>[
        FutureBuilder(
            future: RetrieveObjectFromDb().getDocumenti(pratica.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Errore nel caricamento dei documenti");
              } else if (snapshot.data == null) {
                return const Text("Nessun documento trovato");
              } else if (snapshot.hasData && snapshot.data != null) {
                List<String> docNames = [];
                for (Documento doc in snapshot.data!) {
                  docNames.add(doc.filename);
                }
                selectedDocName = docNames.isNotEmpty ? docNames[0] : null;
                return DropdownButton<String>(
          value: selectedDocName,
          isExpanded: true,
          items: docNames.map((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child: Text(name),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedDocName = newValue;
            });
          },
        );
              } else {
                return const CircularProgressIndicator();
              }
            }),
        const ChatbotHeader(),
        messagesList(),
        messageInputField(),
      ],
    );
  }

  Container messageInputField() {
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
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            tooltip: "Invia",
            onPressed: _sendMessage,
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
