import 'package:flutter/material.dart';

class PdfExporter {
  final String templateText;

  PdfExporter({required this.templateText});

  /// Exports the filled template to a PDF file
  Future<void> export() async {
    debugPrint(templateText);
  }
}
