import 'dart:typed_data';

/* Extracts text from a given text. Supports PDF, DOCX, and TXT files.
Extension must include the dot, eg. ".pdf", ".docx", ".txt". */
class TextExtractor {
  /// Extracts text from a given text. Supports PDF, DOCX, and TXT files.
  String extractText(Uint8List bytes, String extension) {
    switch (extension) {
      case ".pdf":
        return _pdfToText(bytes);
      case ".docx":
        return _docxToText(bytes);
      case ".txt":
        return String.fromCharCodes(bytes);
      default:
        throw Exception("Unsupported file extension: $extension");
    }
  }

  String _pdfToText(Uint8List bytes) {
    return "moi!";
  }

  String _docxToText(Uint8List bytes) {
    return "moi!";
  }
}