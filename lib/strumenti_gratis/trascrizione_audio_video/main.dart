import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lawli/shared/upload_file.dart';

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
    return IntrinsicWidth(
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
                            "Potrai poi chiedere all'intelligenza artificiale di creare un riassunto del testo.")
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
                    "webm"
                  ],
                  onFileSelected: (file) => _onFileSelected(context, file),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _onFileSelected(
      BuildContext context, PlatformFile? file) async {
    if (file == null || file.bytes == null) {
      return null;
    }

    try {
      Uint8List bytes = file.bytes!;
      String format = file.extension!;
      var response = await FirebaseFunctions.instance
          .httpsCallable("transcribe_audio_video")
          .call(
        {"bytes": bytes.toList(), "format": format},
      );
      String? bytesString = response.data;
      if (bytesString != null) {
        debugPrint(bytesString);
        return bytesString;
      } else {
        return "Qualcosa è andato storto! :(";
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return null;
  }
}
