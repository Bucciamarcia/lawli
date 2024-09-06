import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lawli/shared/circular_progress_indicator.dart';
import 'package:lawli/shared/confirmation_message.dart';
import 'package:lawli/shared/upload_file.dart';
import 'package:lawli/strumenti_gratis/trascrizione_audio_video/models.dart';
import 'package:lawli/strumenti_gratis/trascrizione_audio_video/provider.dart';
import 'package:lawli/strumenti_gratis/trascrizione_audio_video/result_box.dart';
import 'package:provider/provider.dart';

class TrascrizioneAudioVideoMain extends StatefulWidget {
  const TrascrizioneAudioVideoMain({super.key});

  @override
  State<TrascrizioneAudioVideoMain> createState() =>
      _TrascrizioneAudioVideoMainState();
}

class _TrascrizioneAudioVideoMainState
    extends State<TrascrizioneAudioVideoMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicWidth(
          child: Center(
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                                "Carica un file audio o video per ottenere la trascrizione."),
                            Text(
                                "L'intellingeza artificiale creerà anche un riassunto breve e uno lungo del testo ottenuto."),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FileUploader(
                      labelText: "Carica un file",
                      helperText: "Carica un file audio o video.",
                      buttonText: "Carica",
                      allowedExtensions: const [
                        "mp4",
                        "avi",
                        "mov",
                        "wmv",
                        "flv",
                        "mkv",
                        "webm",
                        "mp3",
                        "wav",
                        "flac",
                        "ogg",
                        "m4a",
                      ],
                      onFileSelected: (file) =>
                          _handleFileSelection(context, file),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        const TrascrizioneResultBoxWidget(),
      ],
    );
  }

  Future<void> _handleFileSelection(
      BuildContext context, PlatformFile? file) async {
    if (file == null || file.bytes == null) {
      _showErrorMessage(context, "Nessun file selezionato o file vuoto.");
      return;
    }

    OverlayEntry? overlay = CircularProgress.show(context);
    try {
      String? transcription = await _uploadAndTranscribe(file);
      overlay?.remove();
      overlay = null;
      if (transcription != null) {
        Provider.of<TrascrizioneAudioVideoProvider>(context, listen: false)
            .setTrascrizione(transcription);
        _generateShortSummary(context, transcription);
        _generateLongSummary(context, transcription);
      } else {
        _showErrorMessage(context,
            "Nessun testo ottenuto. Sicuro che il file contenga del parlato?");
      }
    } catch (e) {
      _showErrorMessage(context, "Errore durante la trascrizione: $e");
    } finally {
      overlay?.remove();
      overlay = null;
    }
  }

  void _generateShortSummary(BuildContext context, String text) async {
    try {
      String shortSummary = await Trascrizione(text: text).getShortSummary();
      Provider.of<TrascrizioneAudioVideoProvider>(context, listen: false)
          .setShortSummary(shortSummary);
    } catch (e) {
      _showErrorMessage(
          context, "Errore durante la generazione del riassunto breve: $e");
    }
  }

  void _generateLongSummary(BuildContext context, String text) async {
    try {
      String longSummary = await Trascrizione(text: text).getLongSummary();
      Provider.of<TrascrizioneAudioVideoProvider>(context, listen: false)
          .setLongSummary(longSummary);
    } catch (e) {
      _showErrorMessage(
          context, "Errore durante la generazione del riassunto lungo: $e");
    }
  }

  Future<String?> _uploadAndTranscribe(PlatformFile file) async {
    Uint8List bytes = file.bytes!;
    String format = file.extension!;
    var response = await FirebaseFunctions.instance
        .httpsCallable("transcribe_audio_video")
        .call({"bytes": bytes.toList(), "format": format});
    return response.data as String?;
  }

  void _showErrorMessage(BuildContext context, String message) {
    ConfirmationMessage.show(context, "Errore", message);
  }
}
