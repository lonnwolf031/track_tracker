import 'package:flutter/material.dart';
import 'listen.dart';
import 'getlocation.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'dart:async';
import './settings.dart';
import './widgets.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Track Tracker',
    home: MainRoute(),
  ));
}

class MainRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              child: Text('Open settings'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('List rides'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListRideRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Start new ride'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartRideRoute()),
                );
              },
            ),
          ],
        )
      ),
    );
  }
}

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Return to main menu'),
        ),
      ),
    );
  }
}

class ListRideRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List rides"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Return to main menu'),
        ),
      ),
    );
  }
}

class StartRideRoute1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start a new ride"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Return to main menu'),
        ),
      ),
    );
  }
}



class StartRideRoute extends StatefulWidget {
  @override
  _RideState createState() => new _RideState();
}

class _RideState extends State<StartRideRoute> {
  LocationData? currentLocation;
  late Location location;
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;

  @override
  void initState() {
    /// ask for weather
    super.initState();
    location = new Location();
    location.onLocationChanged.listen((event) {
      currentLocation = event;
      /// do calculations
    });
    setInitialLocation();
  }

  void setInitialLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentLocation =  await location.getLocation();

}

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;

    widgets = [];
    /*  new Image.network(
          "https://maps.googleapis.com/maps/api/staticmap?"+
              "center=${currentLocation.latitude},${currentLocation.longitude}"+
              "&zoom=18&size=640x400&key=AIzaSyBw_T2wCQGqWBEdF4UzMAuoQX_DCemYpQw")
    ];*/
    widgets.add(new Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Return to main menu'),
        )
    ));


    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Location plugin example app'),
            ),
            body: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            )));
  }
}

