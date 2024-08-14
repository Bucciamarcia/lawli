import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_saver/file_saver.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Exporter {
  final String templateText;
  final pdf = pw.Document();

  Exporter({required this.templateText});

  /// Entrypoint. Exports the filled template to a PDF file.
  Future<void> exportPdf() async {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(templateText),
          );
        },
      ),
    );
    Uint8List savedFile = await pdf.save();
    await _saveFile("template.pdf", savedFile);
  }

  Future<void> exportDocx() async {
    var result = await FirebaseFunctions.instance
        .httpsCallable(
      "string_to_docx",
    )
        .call(
      {"text": templateText},
    );
    String docxstring = result.data;
    Uint8List docxBytes = base64Decode(docxstring);
    await _saveFile("template.docx", docxBytes);
  }

  /// Saves the PDF file to the device
  Future<void> _saveFile(String name, Uint8List data) async {
    await FileSaver.instance.saveFile(name: name, bytes: data);
  }
}
