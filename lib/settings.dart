import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {

  saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', "value");
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('key') as String;
    return stringValue;
  }
  /// use:;   String value = await getValue() ?? "";

}