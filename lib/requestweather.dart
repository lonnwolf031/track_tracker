import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'dart:async';

class WeatherData {
  ///WeatherData({@required this.locationData});
  WeatherData(locationData) {
    this.locationData = locationData;
  }

  late LocationData locationData;
  var currentTemperature;
  var currentCondition;
  var currentWindSpeed; // double, m/s
  var currentWindDir; // int, meteorological degrees
  final apiKey = "";

  Future<void> getCurrentWeather() async {
    var uri = Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric');
    Response response = await get(uri);

    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
        currentWindSpeed = currentWeather['wind']['speed'];
        currentWindDir = currentWeather['wind']['deg'];
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }

}
