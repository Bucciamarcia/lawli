// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assistito _$AssistitoFromJson(Map<String, dynamic> json) => Assistito(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      businessName: json['businessName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      description: json['description'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      province: json['province'] as String? ?? '',
      cap: (json['cap'] as num?)?.toDouble() ?? 0,
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$AssistitoToJson(Assistito instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'businessName': instance.businessName,
      'email': instance.email,
      'description': instance.description,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'province': instance.province,
      'cap': instance.cap,
      'country': instance.country,
    };
