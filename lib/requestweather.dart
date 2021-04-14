import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'locationhelper.dart';
import 'dart:async';

class WeatherData {
  WeatherData({@required this.locationData});

  LocationData locationData;
  double currentTemperature;
  int currentCondition;

  Future<void> getCurrentTemperature() async {
    var uri = Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric');
    Response response = await get(uri);

    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 600) {
      return WeatherDisplayData(
        weatherIcon: kCloudIcon,
        weatherImage: AssetImage('assets/cloud.png'),
      );
    } else {
      var now = new DateTime.now();

      if (now.hour >= 15) {
        return WeatherDisplayData(
          weatherImage: AssetImage('assets/night.png'),
          weatherIcon: kMoonIcon,
        );
      } else {
        return WeatherDisplayData(
          weatherIcon: kSunIcon,
          weatherImage: AssetImage('assets/sunny.png'),
        );
      }
    }
  }
}
