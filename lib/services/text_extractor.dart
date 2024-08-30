import 'dart:typed_data';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/* Extracts text from a given text. Supports PDF, DOCX, and TXT files.
Extension must include the dot, eg. ".pdf", ".docx", ".txt". */
class TextExtractor {
  /// Extracts text from a given text. Supports PDF, DOCX, and TXT files.
  String extractText(Uint8List bytes, String extension) {
    switch (extension) {
      case ".pdf" || "pdf":
        return _pdfToText(bytes);
      case ".docx" || "docx":
        return _docxToText(bytes);
      case ".txt" || "txt":
        return String.fromCharCodes(bytes);
      default:
        throw Exception("Unsupported file extension: $extension");
    }
  }

  String _pdfToText(Uint8List bytes) {
  final PdfDocument doc = PdfDocument(inputBytes: bytes);
  String text = PdfTextExtractor(doc).extractText();
  doc.dispose();
  return text;
  }

  String _docxToText(Uint8List bytes) {
    return docxToText(bytes);
  }
}