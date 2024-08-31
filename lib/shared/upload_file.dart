import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lawli/shared/circular_progress_indicator.dart';
import 'package:lawli/shared/confirmation_message.dart';

/// A widget that allows the user to upload a file. Uploads the file to the specified path with the filename.
class FileUploader extends StatefulWidget {
  /// Text inside the form field
  final String labelText;

  /// Text in italic below the form field
  final String helperText;

  /// Text of the button
  final String buttonText;

  /// Allowed file extensions. If null, all files are allowed
  /// 
  /// No leading dot. Example: `['pdf', 'docx']`
  final List<String>? allowedExtensions;

  /// Callback function to return the selected file
  final Function(PlatformFile?) onFileSelected;

  const FileUploader(
      {super.key,
      required this.labelText,
      required this.helperText,
      required this.buttonText,
      this.allowedExtensions,
      required this.onFileSelected});

  @override
  State<FileUploader> createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  TextEditingController controller = TextEditingController();
  List<PlatformFile> uploadedFile = [];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  controller: controller),
              const SizedBox(height: 5),
              Text(widget.helperText,
                  style: Theme.of(context).textTheme.labelSmall)
            ],
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: _pickFile,
          child: Text(
            widget.buttonText,
          ),
        ),
      ],
    );
  }

  // Logica per caricare un file
  void _pickFile() async {
    OverlayEntry? progressOverlay;
  FilePickerResult? result;
  progressOverlay = CircularProgress.show(context);
  try {
    if (kIsWeb) {
      result = await FilePickerWeb.platform.pickFiles(
        allowMultiple: false,
        type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: widget.allowedExtensions,
      );
    } else {
      result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: widget.allowedExtensions,
      );
    }
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        controller.text = result!.files.single.name;
        uploadedFile = result.files;
      });
      widget.onFileSelected(result.files.single);
    } else {
      setState(() {
        controller.text = '';
        uploadedFile = [];
      });
      widget.onFileSelected(null);
    }
  } catch (e) {
    debugPrint('Error picking file: $e');
    if (mounted) ConfirmationMessage.show(context, "Errore", "Errore durante il caricamento del file");
    setState(() {
      controller.text = '';
      uploadedFile = [];
    });
    widget.onFileSelected(null);
  } finally {
    progressOverlay?.remove();
    progressOverlay = null;
  }
}

}
