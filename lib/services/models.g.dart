// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assistito _$AssistitoFromJson(Map<String, dynamic> json) => Assistito(
      id: (json['id'] as num?)?.toDouble() ?? 0,
      nome: json['nome'] as String? ?? '',
      cognome: json['cognome'] as String? ?? '',
      nomeCompleto: json['nomeCompleto'] as String? ?? '',
      ragioneSociale: json['ragioneSociale'] as String? ?? '',
      email: json['email'] as String? ?? '',
      descrizione: json['descrizione'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      indirizzo: json['indirizzo'] as String? ?? '',
      citta: json['citta'] as String? ?? '',
      provincia: json['provincia'] as String? ?? '',
      cap: json['cap'] as String? ?? '',
      nazione: json['nazione'] as String? ?? '',
    );

Map<String, dynamic> _$AssistitoToJson(Assistito instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'cognome': instance.cognome,
      'nomeCompleto': instance.nomeCompleto,
      'ragioneSociale': instance.ragioneSociale,
      'email': instance.email,
      'descrizione': instance.descrizione,
      'telefono': instance.telefono,
      'indirizzo': instance.indirizzo,
      'citta': instance.citta,
      'provincia': instance.provincia,
      'cap': instance.cap,
      'nazione': instance.nazione,
    };

Pratica _$PraticaFromJson(Map<String, dynamic> json) => Pratica(
      id: (json['id'] as num?)?.toDouble() ?? 0,
      assistitoId: (json['assistitoId'] as num?)?.toDouble() ?? 0,
      titolo: json['titolo'] as String? ?? '',
      descrizione: json['descrizione'] as String? ?? '',
    );

Map<String, dynamic> _$PraticaToJson(Pratica instance) => <String, dynamic>{
      'id': instance.id,
      'assistitoId': instance.assistitoId,
      'titolo': instance.titolo,
      'descrizione': instance.descrizione,
    };

Documento _$DocumentoFromJson(Map<String, dynamic> json) => Documento(
      filename: json['filename'] as String? ?? '',
      data: Documento._fromJsonTimestamp(json['data'] as Timestamp),
      brief_description: json['brief_description'] as String? ?? '',
    );

Map<String, dynamic> _$DocumentoToJson(Documento instance) => <String, dynamic>{
      'filename': instance.filename,
      'data': Documento._toJsonTimestamp(instance.data),
      'brief_description': instance.brief_description,
    };
