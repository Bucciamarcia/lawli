// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TassoInteresseLegale _$TassoInteresseLegaleFromJson(
        Map<String, dynamic> json) =>
    TassoInteresseLegale(
      inizio: DateTime.parse(json['inizio'] as String),
      fine: DateTime.parse(json['fine'] as String),
      interesse: (json['interesse'] as num?)?.toDouble() ?? 0,
      norma: json['norma'] as String? ?? '',
    );

Map<String, dynamic> _$TassoInteresseLegaleToJson(
        TassoInteresseLegale instance) =>
    <String, dynamic>{
      'inizio': instance.inizio.toIso8601String(),
      'fine': instance.fine.toIso8601String(),
      'interesse': instance.interesse,
      'norma': instance.norma,
    };
