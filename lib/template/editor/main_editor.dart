import 'package:flutter/material.dart';

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
    
    widget.templateText.splitMapJoin(exp,
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
      _filledValues.containsKey(placeholder) && _filledValues[placeholder]!.isNotEmpty
    );
  }

  /// Returns the template text with all placeholders filled
  String getFilledTemplate() {
    String filledText = widget.templateText;
    _filledValues.forEach((key, value) {
      filledText = filledText.replaceAll('{$key}', value);
    });
    return filledText;
  }

  /// Returns true if all placeholders have been filled
  bool areAllFieldsFilled() {
    return _allFieldsFilled;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: _textSpans,
        ),
      ),
    );
  }
}

/// A text field that is displayed inline with the text
class InlineTextField extends StatelessWidget {
  final String placeholder;
  final String value;
  final ValueChanged<String> onChanged;

  const InlineTextField({super.key, 
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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