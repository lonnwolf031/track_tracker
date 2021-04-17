import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'wind.dart';
import 'latlng.dart'
import 'dart:convert';

class Ride {
  late DateTime date;
  late Wind wind;
  Map ridedata = Map<DateTime, String>();

  Ride(DateTime date, Wind wind) {
    this.date = date;
    this.wind = wind;
    this.ridedata = ridedata;
  }

  Ride.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        wind = json['wind'],
        ridedata = json['ridedata'];

  Map<String, dynamic> toJson() => {
    'date': date,
    'wind': wind,
    'ridedata' : ridedata,
  };
}
/*
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };
}
Map<String, dynamic> userMap = jsonDecode(jsonString);
var user = User.fromJson(userMap);

print('Howdy, ${user.name}!');
print('We sent the verification link to ${user.email}.');
String json = jsonEncode(user);

*/
