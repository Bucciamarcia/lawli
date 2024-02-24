import "package:json_annotation/json_annotation.dart";
part "models.g.dart";

@JsonSerializable()
class Assistito {
  final double id;
  final String firstName;
  final String lastName;
  final String businessName;
  final String email;
  final String description;
  final String phone;
  final String address;
  final String city;
  final String province;
  final double cap;
  final String country;

  // Assign empty string to all the fields
  Assistito({
    this.id = 0,
    this.firstName = '',
    this.lastName = '',
    this.businessName = '',
    this.email = '',
    this.description = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.province = '',
    this.cap = 0,
    this.country = '',
  });

    factory Assistito.fromJson(Map<String, dynamic> json) => _$AssistitoFromJson(json);
    Map<String, dynamic> toJson() => _$AssistitoToJson(this);


}