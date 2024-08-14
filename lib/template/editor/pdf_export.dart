import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfExporter {
  final String templateText;
  final pdf = pw.Document();

  PdfExporter({required this.templateText});

  /// Entrypoint. Exports the filled template to a PDF file.
  Future<void> export() async {
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
  }
}
