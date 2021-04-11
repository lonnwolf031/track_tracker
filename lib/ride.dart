import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ride.g.dart';

@JsonSerializable()

/*
  Add a thing to call to/from json only when asked
  make a map per class (ridedata) and function to add to map
  def add (time, lat, lon)

 */

class Ride extends StatefulWidget{
  DateTime date;
  Map ridedata;

  /// add constructor and build()

  Ride(this.date, this.ridedata);

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);
}

///Map userMap = jsonDecode(jsonString);
///var user = User.fromJson(userMap);
///
///String json = jsonEncode(user);