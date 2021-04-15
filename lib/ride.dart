import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'wind.dart';

class Ride {
  late DateTime date;
  late Wind wind;

  Ride(DateTime date, Wind wind) {
    this.date = date;
    this.wind = wind;
  }
}