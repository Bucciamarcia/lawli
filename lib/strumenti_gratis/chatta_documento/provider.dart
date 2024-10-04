import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'models.dart';

class DocumentChatterProvider extends ChangeNotifier {
  List<ChatMessage> messaggi = [];
  PlatformFile? file;

  void addChatMessage(ChatMessage message) {
    messaggi.add(message);
    notifyListeners();
  }

  void updateFile(PlatformFile? file) {
    this.file = file;
    notifyListeners();
  }
}
