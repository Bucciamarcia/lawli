import 'package:flutter/material.dart';
import 'package:lawli/services/models.dart';

class TemplateEditorMain extends StatefulWidget {
  final Template template;
  const TemplateEditorMain({super.key, required this.template});

  @override
  State<TemplateEditorMain> createState() => _TemplateEditorMainState();
}

class _TemplateEditorMainState extends State<TemplateEditorMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 1500,
            width: double.infinity,
            color: Colors.grey[200], // Just for visualization, you can remove it
            child: Center(child: Text('Scrollable Content Here')),
          ),
          // Add more content here if needed
        ],
      ),
    );
  }
}