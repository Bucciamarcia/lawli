import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lawli/services/cloud_storage.dart';
import 'package:lawli/shared/circular_progress_indicator.dart';
import 'package:lawli/shared/confirmation_message.dart';
import 'package:lawli/shared/upload_file.dart';
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
  PlatformFile? selectedFile;

  @override
  void initState() {
    super.initState();
    displayName = widget.account.displayName;
    address = widget.account.address;
  }

  void _handleFileSelected(PlatformFile? file) async {
    if (file != null && file.bytes != null) {
      debugPrint('Selected file: ${file.name}');
      debugPrint('File size: ${file.size}');
      debugPrint("File extension: ${file.extension}");
      try {
        await _deleteOldLogo();
      } catch (e) {
        debugPrint("Error deleting old logo: $e");
        ConfirmationMessage.show(context, "Errore",
            "Errore durante l'eliminazione del logo esistente.");
        return;
      }
      try {
        await DocumentStorage().uploadDocument(
            "accounts/${widget.account.id}/logo.${file.extension}",
            file.bytes!);
        // After successful upload, update the state
        setState(() {
          selectedFile = file;
        });
      } catch (e) {
        debugPrint("Error uploading new logo: $e");
        ConfirmationMessage.show(
            context, "Errore", "Errore durante il caricamento del nuovo logo.");
      }
    } else {
      debugPrint('No file selected');
    }
  }

  Future<void> _deleteOldLogo() async {
    try {
      ListResult files =
          await DocumentStorage().searchAll("accounts/${widget.account.id}");
      List<String> filenames = files.items.map((e) => e.name).toList();
      String logoFilename = filenames.firstWhere(
          (element) => element.startsWith("logo"),
          orElse: () => "");
      if (logoFilename.isNotEmpty) {
        await DocumentStorage()
            .deleteDocument("accounts/${widget.account.id}/", logoFilename);
      }
    } catch (e) {
      debugPrint("Error deleting old logo: $e");
      rethrow;
    }
  }

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
        Row(
          children: [
            _logoImage(),
            const SizedBox(width: 25),
            Expanded(
              child: FileUploader(
                labelText: "Carica un logo",
                helperText:
                    "Il logo verrà visualizzato nei documenti. Formati supportati: png, jpg, jpeg",
                buttonText: "Carica logo",
                allowedExtensions: const ["png", "jpg", "jpeg"],
                onFileSelected: _handleFileSelected,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AccountEditBoxSingleLine(
              title: "Nome dello studio",
              description:
                  "Il nome dello studio. Verrà visualizzato nei documenti.",
              label: "Nome studio",
              initialValue: displayName,
              onChanged: updateDisplayName,
            ),
            AccountEditBoxMultiLine(
                title: "Indirizzo",
                description:
                    "Indirizzo legale dello studio, verrà visualizzato nei documenti.",
                label: "Indirizzo",
                initialValue: address,
                onChanged: updateAddress)
          ],
        ),
        ElevatedButton(
          child: const Text(
            "Salva modifiche",
          ),
          onPressed: () async {
            OverlayEntry? overlay = CircularProgress.show(context);
            try {
              await _updateAccount();
              ConfirmationMessage.show(context, "Modifiche salvate",
                  "Le modifiche sono state salvate correttamente.");
            } catch (e) {
              debugPrint("Error updating account: $e");
              ConfirmationMessage.show(context, "Errore",
                  "Errore durante il salvataggio delle modifiche.");
            } finally {
              overlay?.remove();
              overlay = null;
            }
          },
        )
      ],
    );
  }

  Future<void> _updateAccount() async {
    Map<String, dynamic> data = {
      "displayName": displayName,
      "address": address,
    };
    try {
      await widget.account.updateAccountInfo(data);
    } catch (e) {
      debugPrint("Error updating account: $e");
      rethrow;
    }
  }

  Widget _logoImage() {
    return SizedBox(
        width: 400,
        child: FutureBuilder<Image?>(
          future: getLogoImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Text("Errore nel caricamento del logo");
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Placeholder(); // Handle no logo scenario
            }
            return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black26,
                      width: 1,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: snapshot.data!);
          },
        ));
  }

  Future<Uint8List?> getLogoBytes() async {
    try {
      ListResult files =
          await DocumentStorage().searchAll("accounts/${widget.account.id}");
      List<String> filenames = files.items.map((e) => e.name).toList();
      String logoFilename = filenames.firstWhere(
          (element) => element.startsWith("logo"),
          orElse: () => "");
      if (logoFilename.isEmpty) {
        return null;
      } else {
        return await DocumentStorage()
            .getDocument("accounts/${widget.account.id}/$logoFilename");
      }
    } catch (e) {
      debugPrint("Error getting logo: $e");
      return Uint8List(0);
    }
  }

  Future<Image?> getLogoImage() async {
    Uint8List bytes;
    try {
      ListResult files =
          await DocumentStorage().searchAll("accounts/${widget.account.id}");
      List<String> filenames = files.items.map((e) => e.name).toList();
      String logoFilename = filenames.firstWhere(
        (element) => element.startsWith("logo"),
        orElse: () => "",
      );
      if (logoFilename.isEmpty) {
        return null; // No logo found
      }
      bytes = await DocumentStorage()
          .getDocument("accounts/${widget.account.id}/$logoFilename");
    } catch (e) {
      debugPrint("Error getting logo for account ${widget.account.id}: $e");
      return null; // Return null on error to handle gracefully
    }
    return Image.memory(
      bytes,
      height: 200,
      fit: BoxFit.fitHeight,
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
      required this.onChanged});

  @override
  State<AccountEditBoxSingleLine> createState() =>
      _AccountEditBoxSingleLineState();
}

class _AccountEditBoxSingleLineState extends State<AccountEditBoxSingleLine> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _controller,
                onChanged: widget.onChanged,
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
      required this.onChanged});

  @override
  State<AccountEditBoxMultiLine> createState() =>
      _AccountEditBoxMultiLineState();
}

class _AccountEditBoxMultiLineState extends State<AccountEditBoxMultiLine> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _controller,
                onChanged: widget.onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
