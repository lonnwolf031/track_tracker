import 'package:json_annotation/json_annotation.dart';
part 'ride.g.dart';

@JsonSerializable()

class Ride {
  DateTime date;
  Map ridedata;

  Ride(this.date, this.ridedata);

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);
}

///Map userMap = jsonDecode(jsonString);
///var user = User.fromJson(userMap);
///
///String json = jsonEncode(user);