import 'package:flutter/material.dart';
import "package:lawli/strumenti_gratis/trascrizione_audio_video/main.dart";
import "../../shared/shared.dart";
import "../../services/services.dart";

class TrascrizioneAudioVideoScreen extends StatelessWidget {
  const TrascrizioneAudioVideoScreen({super.key});

  Scaffold body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: ResponsiveLayout.mainWindowPadding(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: TrascrizioneAudioVideoMain(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: const Text("Trascrizione audio / video"),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return DesktopVersion(body: body(context), appBar: appBar(context));
        } else {
          return MobileVersion(body: body(context), appBar: appBar(context));
        }
      },
    );
  }
}