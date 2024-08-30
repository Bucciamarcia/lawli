// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TassoInteresseLegale _$TassoInteresseLegaleFromJson(
        Map<String, dynamic> json) =>
    TassoInteresseLegale(
      inizio: TassoInteresseLegale._fromJson(json['inizio']),
      fine: TassoInteresseLegale._fromJson(json['fine']),
      interesse: (json['interesse'] as num?)?.toDouble() ?? 0,
      norma: json['norma'] as String? ?? '',
    );

Map<String, dynamic> _$TassoInteresseLegaleToJson(
        TassoInteresseLegale instance) =>
    <String, dynamic>{
      'inizio': TassoInteresseLegale._toJson(instance.inizio),
      'fine': TassoInteresseLegale._toJson(instance.fine),
      'interesse': instance.interesse,
      'norma': instance.norma,
    };
