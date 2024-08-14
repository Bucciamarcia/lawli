import 'package:flutter/material.dart';
import 'package:lawli/shared/confirmation_message.dart';
import 'package:lawli/template/editor/exporter.dart';

class TemplateDocumentView extends StatefulWidget {
  final String templateText;

  TemplateDocumentView({super.key, required this.templateText});

  @override
  _TemplateDocumentViewState createState() => _TemplateDocumentViewState();
}

class _TemplateDocumentViewState extends State<TemplateDocumentView> {
  late List<InlineSpan> _textSpans;
  Map<String, String> _filledValues = {};
  Set<String> _allPlaceholders = {};
  bool _allFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    _parseTemplate();
  }

  /// Parses the template text and creates a list of InlineSpans
  void _parseTemplate() {
    RegExp exp = RegExp(r'\{\{([^}]+)\}\}');
    _textSpans = [];

    widget.templateText.splitMapJoin(
      exp,
      onMatch: (Match m) {
        String placeholder = m.group(1)!;
        _allPlaceholders.add(placeholder);
        _textSpans.add(
          WidgetSpan(
            child: InlineTextField(
              placeholder: placeholder,
              value: _filledValues[placeholder] ?? '',
              onChanged: (value) {
                setState(() {
                  _filledValues[placeholder] = value;
                  _checkAllFieldsFilled();
                });
              },
            ),
          ),
        );
        return '';
      },
      onNonMatch: (String text) {
        _textSpans.add(TextSpan(text: text));
        return '';
      },
    );

    _checkAllFieldsFilled();
  }

  /// Checks if all placeholders have been filled and updates [_allFieldsFilled]
  void _checkAllFieldsFilled() {
    _allFieldsFilled = _allPlaceholders.every((placeholder) =>
        _filledValues.containsKey(placeholder) &&
        _filledValues[placeholder]!.isNotEmpty);
  }

  /// Returns the template text with all placeholders filled
  String getFilledTemplate() {
    String filledText = widget.templateText;
    _filledValues.forEach((key, value) {
      filledText = filledText.replaceAll('{{$key}}', value);
    });
    return filledText;
  }

  /// Clears all input fields
  void clearAllFields() {
    setState(() {
      _filledValues.clear();
      _parseTemplate();
    });
  }

  /// Returns true if all placeholders have been filled
  bool areAllFieldsFilled() {
    return _allFieldsFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: _textSpans,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _checkAllFieldsFilled();
                if (areAllFieldsFilled()) {
                  Exporter(templateText: getFilledTemplate()).exportPdf();
                } else {
                  ConfirmationMessage.show(
                    context,
                    "Campi vuoti",
                    "Alcuni campi sono vuoti. Assicurati di aver compilato tutti i campi prima di esportare il documento.",
                  );
                }
              },
              label: const Text("Exporta in PDF"),
              icon: const Icon(Icons.picture_as_pdf),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                _checkAllFieldsFilled();
                if (areAllFieldsFilled()) {
                  try {
                  Exporter(templateText: getFilledTemplate()).exportDocx();
                  } catch (e) {
                    debugPrint("Error exporting to .docx: $e");
                  }
                } else {
                  ConfirmationMessage.show(
                    context,
                    "Campi vuoti",
                    "Alcuni campi sono vuoti. Assicurati di aver compilato tutti i campi prima di esportare il documento.",
                  );
                }
              },
              icon: const Icon(Icons.edit_document),
              label: const Text("Esporta in .docx"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: clearAllFields,
              label: const Text("Ricomincia"),
              icon: const Icon(Icons.clear),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
              label: const Text("Annulla"),
              icon: const Icon(Icons.arrow_back),
            )
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// A text field that is displayed inline with the text
class InlineTextField extends StatelessWidget {
  final String placeholder;
  final String value;
  final ValueChanged<String> onChanged;

  const InlineTextField({
    super.key,
    required this.placeholder,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150, // Adjust as needed
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          hintText: placeholder,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// TODO: Create a button to export the PDF
