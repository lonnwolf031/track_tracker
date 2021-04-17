import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ridedata.g.dart';

@JsonSerializable()

/*
  Add a thing to call to/from json only when asked
  make a map per class (ridedata) and function to add to map
  def add (time, lat, lon)

 */

class Ridedata{
  final DateTime date;
  @JsonKey(includeIfNull: false)
  Map? ridedata;
  /// add constructor and build()
  Ridedata(this.date, this.ridedata);
  factory Ridedata.fromJson(Map<String, dynamic> json) => _$RidedataFromJson(json);
  Map<String, dynamic> toJson() => _$RidedataToJson(this);
}

///Map userMap = jsonDecode(jsonString);
///var user = User.fromJson(userMap);
///
///String json = jsonEncode(user);