// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assistito _$AssistitoFromJson(Map<String, dynamic> json) => Assistito(
      id: (json['id'] as num?)?.toDouble() ?? 0,
      nome: json['nome'] as String? ?? '',
      cognome: json['cognome'] as String? ?? '',
      ragioneSociale: json['ragioneSociale'] as String? ?? '',
      email: json['email'] as String? ?? '',
      descrizione: json['descrizione'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      indirizzo: json['indirizzo'] as String? ?? '',
      citta: json['citta'] as String? ?? '',
      provincia: json['provincia'] as String? ?? '',
      cap: (json['cap'] as num?)?.toDouble() ?? 0,
      nazione: json['nazione'] as String? ?? '',
    );

Map<String, dynamic> _$AssistitoToJson(Assistito instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'cognome': instance.cognome,
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
