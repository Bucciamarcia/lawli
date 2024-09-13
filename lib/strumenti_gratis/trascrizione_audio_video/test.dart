import 'package:flutter/material.dart';
import 'package:lawli/strumenti_gratis/trascrizione_audio_video/models.dart';
import 'package:lawli/strumenti_gratis/trascrizione_audio_video/result_box.dart';

Trascrizione trascrizione = Trascrizione(
  text: "Testo di prova",
  shortSummary: "Riassunto breve",
  longSummary: "Riassunto lungo",
);

TabViewWidget tabViewWidget = TabViewWidget(trascrizione: trascrizione);

class TestResultBox extends StatelessWidget {
  const TestResultBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(child: tabViewWidget));
  }
}
