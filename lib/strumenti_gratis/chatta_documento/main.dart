import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lawli/shared/upload_file.dart';
import "models.dart";
import 'package:lawli/strumenti_gratis/chatta_documento/provider.dart';
import 'package:provider/provider.dart';

class ChatMainStandalone extends StatelessWidget {
  const ChatMainStandalone({super.key});

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> chatMessages =
        Provider.of<DocumentChatterProvider>(context, listen: true).messaggi;
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            FileUploader(
              labelText: "Carica un documento per chattare",
              helperText: "",
              buttonText: "Carica",
              onFileSelected: (PlatformFile? file) {
                Provider.of<DocumentChatterProvider>(context, listen: false)
                    .updateFile(file);
              },
            ),
            // if (chatMessages.isNotEmpty) const ChatScreen(),
            const ChatScreen(),
            const SizedBox(
              height: 20,
            ),
            const MessageSender()
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> chatMessages =
        Provider.of<DocumentChatterProvider>(context, listen: true).messaggi;
    // List<ChatMessage> chatMessages = [
    //  ChatMessage(text: "User message", isUserMessage: true),
    //  ChatMessage(text: "Bot message", isUserMessage: false),
    // ];
    return Container(
      constraints: const BoxConstraints(maxHeight: 500),
      child: SizedBox.expand(
        child: Card(
          elevation: 10,
          color: const Color.fromRGBO(220, 230, 255, 1),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children:
                    chatMessages.map((message) => message.build()).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageSender extends StatefulWidget {
  const MessageSender({super.key});

  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      Provider.of<DocumentChatterProvider>(context, listen: false)
          .addChatMessage(
              ChatMessage(text: _controller.text, isUserMessage: true));
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Chatta con il documento"),
            onSubmitted: (_) => _sendMessage(),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: _sendMessage, child: const Text("Invia"))
      ],
    );
  }
}
