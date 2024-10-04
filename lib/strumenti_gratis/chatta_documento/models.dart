import 'package:flutter/material.dart';

class ChatMessage {
  String text;
  bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});

  Widget build() {
    return Row(
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Card(
              elevation: 5,
              color: isUserMessage ? Colors.blue : Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                      color: isUserMessage ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
