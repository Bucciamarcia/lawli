import "package:json_annotation/json_annotation.dart";
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

    factory Assistito.fromJson(Map<String, dynamic> json) => _$AssistitoFromJson(json);
    Map<String, dynamic> toJson() => _$AssistitoToJson(this);


}

@JsonSerializable()
class Pratica {
  final double id;
  final String assistitoId;
  final String titolo;
  final String descrizione;

  Pratica({
    this.id = 0,
    this.assistitoId = '',
    this.titolo = '',
    this.descrizione = '',
  });

  factory Pratica.fromJson(Map<String, dynamic> json) => _$PraticaFromJson(json);
}