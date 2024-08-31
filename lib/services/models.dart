import "package:cloud_firestore/cloud_firestore.dart";
import "package:cloud_functions/cloud_functions.dart";
import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:lawli/services/firestore.dart";
import "package:lawli/template/provider.dart";
import "package:provider/provider.dart";
part "models.g.dart";

@JsonSerializable()
class Assistito {
  final double id;
  final String nome;
  final String cognome;
  final String nomeCompleto;
  final String ragioneSociale;
  final String email;
  final String descrizione;
  final String telefono;
  final String indirizzo;
  final String citta;
  final String provincia;
  final String cap;
  final String nazione;

  // Assign empty string to all the fields
  Assistito({
    this.id = 0,
    this.nome = '',
    this.cognome = '',
    this.nomeCompleto = '',
    this.ragioneSociale = '',
    this.email = '',
    this.descrizione = '',
    this.telefono = '',
    this.indirizzo = '',
    this.citta = '',
    this.provincia = '',
    this.cap = '',
    this.nazione = '',
  });

  factory Assistito.fromJson(Map<String, dynamic> json) =>
      _$AssistitoFromJson(json);
  Map<String, dynamic> toJson() => _$AssistitoToJson(this);
}

@JsonSerializable()
class Pratica {
  final double id;
  final double assistitoId;
  final String titolo;
  final String descrizione;

  Pratica({
    this.id = 0,
    this.assistitoId = 0,
    this.titolo = '',
    this.descrizione = '',
  });

  factory Pratica.fromJson(Map<String, dynamic> json) =>
      _$PraticaFromJson(json);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pratica &&
        other.id == id &&
        other.assistitoId == assistitoId &&
        other.titolo == titolo &&
        other.descrizione == descrizione;
  }
}

@JsonSerializable()
class Documento {
  final String filename;
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  final DateTime data;
  final String brief_description;
  String? assistantId;

  Documento({
    this.filename = '',
    required this.data,
    this.brief_description = '',
    this.assistantId,
  });

  factory Documento.fromJson(Map<String, dynamic> json) =>
      _$DocumentoFromJson(json);

  static DateTime _fromJsonTimestamp(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _toJsonTimestamp(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Documento &&
        other.filename == filename &&
        other.data == data &&
        other.brief_description == brief_description &&
        other.assistantId == assistantId;
  }

  @override
  int get hashCode =>
      Object.hash(filename, data, brief_description, assistantId);
}

@JsonSerializable()
class Template extends FirestoreService {
  final String title;
  String text;
  String briefDescription;

  Template({
    this.title = '',
    this.text = '',
    this.briefDescription = '',
  });

  Future<void> processNew(BuildContext context) async {
    try {
      await _formatText();
    } catch (e) {
      debugPrint("Error while formatting text: $e");
      rethrow;
    }

    try {
      await _getBriefDescription();
    } catch (e) {
      debugPrint("Error while getting brief description: $e");
      rethrow;
    }

    try {
      await _addTemplateToDb(context);
    } catch (e) {
      debugPrint("Error while adding template to db: $e");
      rethrow;
    }

    try {
      // Sistema di merda, ora carica 1 alla volta ed è lentissimo. Da fare in batch.
      await _uploadWeaviate();
    } catch (e) {
      debugPrint("Error while uploading to weaviate: $e");
      rethrow;
    }
  }

  /// Get the brief description of the template
  Future<void> _getBriefDescription() async {
    var result = await FirebaseFunctions.instance
        .httpsCallable("get_template_brief_description")
        .call({"title": title, "text": text});

    briefDescription = result.data;
  }

  Future<void> _formatText() async {
    var result = await FirebaseFunctions.instance
        .httpsCallable("get_template_formatted")
        .call({"title": title, "text": text});

    text = result.data;
  }

  Future<void> _addTemplateToDb(BuildContext context) async {
    String accountName = await AccountDb().getAccountName();
    Map<String, String> data = {
      "title": title,
      "briefDescription": briefDescription,
      "text": text,
    };
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference docs = db
          .collection("accounts")
          .doc(accountName)
          .collection("templates")
          .doc(title);
      await docs.set(data);
      Provider.of<TemplateProvider>(context, listen: false).selectedPratica =
          null;
      Provider.of<TemplateProvider>(context, listen: false)
          .setLikelyTemplates([]);
    } catch (e) {
      debugPrint("Error while adding template to db: $e");
      rethrow;
    }
  }

  Future<void> _uploadWeaviate() async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable("add_template_to_weaviate")
          .call({
        "title": title,
        "text": text,
        "briefDescription": briefDescription,
        "tenant": await AccountDb().getAccountName(),
      });
    } catch (e) {
      debugPrint("Error while uploading to weaviate: $e");
      rethrow;
    }
  }

  Future<void> deleteTemplate(Template template) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable("delete_template_from_weaviate")
          .call(
        {
          "title": template.title,
          "text": template.text,
          "client": await AccountDb().getAccountName(),
        },
      );
    } catch (e) {
      debugPrint("Error while deleting template from weaviate: $e");
      rethrow;
    }
  }

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateToJson(this);
}
