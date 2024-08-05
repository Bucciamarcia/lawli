import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
import "package:lawli/services/cloud_storage.dart";
part "models.g.dart";

@JsonSerializable()

/// Represents an account
class AccountInfo {
  /// Name of the account. E.g "lawli"
  final String id;

  /// The name displayed in documents etc, if present
  final String displayName;

  /// Legal address of the account
  final String address;

  /// Extension of the logo, WITH the dot. E.g ".png"
  final String logoExtension;

  AccountInfo({
    this.id = "",
    this.logoExtension = "",
    this.displayName = "",
    this.address = "",
  });

  /// Gets the logo of the account and adds it to the object
  Future<Uint8List> getLogo() async {
    Uint8List logo =
        await DocumentStorage().getDocument("accounts/$id/logo$logoExtension");
    return logo;
  }

  /// Uploads the logo of the account object to the cloud storage
  Future<void> uploadLogo(Uint8List logo) async {
    await DocumentStorage()
        .uploadDocument("accounts/$id/logo$logoExtension", logo);
    debugPrint("Logo uploaded");
  }

  factory AccountInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);
}
