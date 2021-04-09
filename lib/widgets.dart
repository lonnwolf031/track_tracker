import 'package:flutter/material.dart';
typedef CallbackSetting = void Function(String, int);

class SettingsButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final String setting;
  final CallbackSetting callback;
  SettingsButton(this.color, this.text, this.value, this.setting, this.callback);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(this.text, style: TextStyle(color: Colors.white)),
      onPressed: () => this.callback(this.setting, this.value),
      color: this.color,
    );
  }
}