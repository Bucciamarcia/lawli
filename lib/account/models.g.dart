// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) => AccountInfo(
      id: json['id'] as String? ?? "",
      logoExtension: json['logoExtension'] as String? ?? "",
      displayName: json['displayName'] as String? ?? "",
      address: json['address'] as String? ?? "",
    );

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'address': instance.address,
      'logoExtension': instance.logoExtension,
    };
