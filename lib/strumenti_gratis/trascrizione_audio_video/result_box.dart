import 'package:flutter/material.dart';
import 'package:lawli/strumenti_gratis/trascrizione_audio_video/models.dart';
import 'package:lawli/strumenti_gratis/trascrizione_audio_video/provider.dart';
import 'package:provider/provider.dart';

class TrascrizioneResultBoxWidget extends StatelessWidget {
  const TrascrizioneResultBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// Provider that listens to changes.
    Trascrizione trascrizione =
        Provider.of<TrascrizioneAudioVideoProvider>(context, listen: true)
            .trascrizione;
    if (trascrizione.text == null) {
      return const SizedBox();
    }
    if (trascrizione.text!.isEmpty) {
      return const SizedBox();
    }
    return TabViewWidget(trascrizione: trascrizione);
  }
}

class TabViewWidget extends StatelessWidget {
  final Trascrizione trascrizione;
  const TabViewWidget({super.key, required this.trascrizione});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "Testo"),
              Tab(text: "Riassunto breve"),
              Tab(text: "Riassunto lungo"),
            ],
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 1000),
            child: TabBarView(children: [
              SingleChildScrollView(child: getTesto(trascrizione)),
              SingleChildScrollView(child: getRiassuntoBreve(trascrizione)),
              SingleChildScrollView(child: getRiassuntoLungo(trascrizione)),
            ]),
          )
        ],
      ),
    );
  }

  Widget getTesto(Trascrizione trascrizione) {
    return Text(trascrizione.text!);
  }

  Widget getRiassuntoBreve(Trascrizione trascrizione) {
    if (trascrizione.shortSummary == null) {
      return const SizedBox(
          height: 100, width: 100, child: CircularProgressIndicator());
    } else {
      return Text(trascrizione.shortSummary!);
    }
  }

  Widget getRiassuntoLungo(Trascrizione trascrizione) {
    if (trascrizione.longSummary == null) {
      return const SizedBox(
          height: 100, width: 100, child: CircularProgressIndicator());
    } else {
      return Text(trascrizione.longSummary!);
    }
  }
}
