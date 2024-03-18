import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatView extends StatefulWidget {
  final String lastMessage;
  final String? assistantId;
  final String? filePath;
  final String? threadId;
  const ChatView({super.key, required this.lastMessage, this.assistantId, this.filePath, this.threadId});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];

  void _clearChatHistory() {
    setState(() {
      _messages.clear(); 
    });
  }

  void _sendMessage() {
    if (_inputController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: _inputController.text, isUserMessage: true));
        _inputController.clear();

        // Placeholder for sending to backend and getting a response:
        _addBotMessage("Thinking..."); 

                FocusScope.of(context).requestFocus(_inputFocusNode); // Request focus

      });
    }
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUserMessage: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 1), borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.primaryContainer),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Chatta con l'assistente",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageRow(_messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    focusNode: _inputFocusNode,
                    controller: _inputController,
                    decoration: const InputDecoration(hintText: 'Scrivi un messaggio...'),
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
          ),
        ],
      );
  }

  Widget _buildMessageRow(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
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

class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}