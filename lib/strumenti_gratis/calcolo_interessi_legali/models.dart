import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
part "models.g.dart";

@JsonSerializable()
class TassoInteresseLegale {
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime inizio;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime fine;
  final double interesse;
  final String norma;

  TassoInteresseLegale({
    required this.inizio,
    required this.fine,
    this.interesse = 0,
    this.norma = '',
  });

  factory TassoInteresseLegale.fromJson(Map<String, dynamic> json) =>
      _$TassoInteresseLegaleFromJson(json);

  Map<String, dynamic> toJson() => _$TassoInteresseLegaleToJson(this);

  static DateTime _fromJson(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      return DateTime.parse(date);
    }
    throw ArgumentError('Invalid date format');
  }

  static dynamic _toJson(DateTime date) => Timestamp.fromDate(date);
}

class TassoInteresseLegaleOperations {

  /// Returns the legal interest rate that started in the given year.
  Future<TassoInteresseLegale> getTassoInteresseLegale(double anno) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      var ref = db
          .collection("settings")
          .doc("interessi legali")
          .collection("tassi interesse")
          .doc(anno.toString());
      var snapshot = await ref.get();
      return TassoInteresseLegale.fromJson(snapshot.data() ?? {});
    } on Exception catch (e) {
      debugPrint("Error while getting tasso interesse legale: $e");
      rethrow;
    }
  }

  /// Returns all the legal interest rates.
  Future<List<TassoInteresseLegale>> getTassiInteresseLegale() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      var ref = db
          .collection("settings")
          .doc("interessi legali")
          .collection("tassi interesse");
      var snapshot = await ref.get();
      var data = snapshot.docs.map((s) => s.data());
      var topics = data.map((d) => TassoInteresseLegale.fromJson(d));
      return topics.toList();
    } catch (e) {
      debugPrint("Error while getting tassi interesse legale");
      rethrow;
    }
  }

}