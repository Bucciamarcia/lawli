import "package:flutter/material.dart";
import "package:lawli/services/services.dart";

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextField(
      {super.key, required this.controller, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
    );
  }
}

class CustomDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const CustomDropdownField(
      {super.key, required this.controller, required this.labelText});

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  dynamic _selectedValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: AssistitoDb().getAssistiti(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DropdownMenuItem<dynamic>> items =
              snapshot.data!.map<DropdownMenuItem<dynamic>>((item) {
            return DropdownMenuItem<dynamic>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList();
          return DropdownButton(
            value: _selectedValue,
            items: items,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
                widget.controller.text = value.toString();
              });
            },
            hint: Text(widget.labelText),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
