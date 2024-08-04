import 'package:flutter/material.dart';
import 'models.dart';

class AccountMainView extends StatefulWidget {
  final AccountInfo account;
  const AccountMainView({super.key, required this.account});

  @override
  State<AccountMainView> createState() => _AccountMainViewState();
}

class _AccountMainViewState extends State<AccountMainView> {
  String displayName = '';
  String address = '';

  void updateDisplayName(String newValue) {
    setState(() {
      displayName = newValue;
    });
  }

  void updateAddress(String newValue) {
    setState(() {
      address = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountEditBoxSingleLine(
          title: "Nome account",
          description: "Nome dell'account. E.g. 'lawli'",
          label: "Nome",
          initialValue: widget.account.displayName,
          onChanged: updateDisplayName,
        ),
        AccountEditBoxMultiLine(
            title: "Indirizzo",
            description: "Indirizzo legale dello studio",
            label: "Indirizzo",
            initialValue: widget.account.address,
            onChanged: updateAddress)
      ],
    );
  }
}

class AccountEditBoxSingleLine extends StatefulWidget {
  final String title;
  final String description;
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const AccountEditBoxSingleLine(
      {super.key,
      required this.title,
      required this.description,
      required this.label,
      required this.initialValue,
      required this.onChanged})
      ;

  @override
  State<AccountEditBoxSingleLine> createState() =>
      _AccountEditBoxSingleLineState();
}

class _AccountEditBoxSingleLineState extends State<AccountEditBoxSingleLine> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: widget.initialValue);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: widget.label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountEditBoxMultiLine extends StatefulWidget {
  final String title;
  final String description;
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const AccountEditBoxMultiLine(
      {super.key,
      required this.title,
      required this.description,
      required this.label,
      required this.initialValue,
      required this.onChanged})
      ;

  @override
  State<AccountEditBoxMultiLine> createState() =>
      _AccountEditBoxMultiLineState();
}

class _AccountEditBoxMultiLineState extends State<AccountEditBoxMultiLine> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: widget.initialValue);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: widget.label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}