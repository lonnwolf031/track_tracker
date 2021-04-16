/*
Overpass query:
==========
// query part for: “road”
  way["highway"="primary"]["surface"="asphalt"]({{bbox}});
  ==========================================

[out:json][timeout:25];
(
  // query part for: “surface=*”  highway=*
  way["surface"](around:10,51.28845, 4.502601);
);
// print results
out body;
>;
out skel qt;



 */

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

import 'package:flutter/material.dart';
import 'overpassapi.dart';
import 'package:latlong/latlong.dart';
import 'overpass.dart';

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final OverpassApi _overpassApi = new OverpassApi();
  GeoService _geoService;

  List<SearchType> _searchTypes = [];
  List<Location> _locations = [];

  Location _currentLocation;
  List<Location> _entities = [];
  SearchType _currentType;
  bool _answered = false;

  @override
  void initState() {
    _geoService = new GeoService(overpassApi: _overpassApi);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _initialize();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text("Guess what! 🤔", style: TextStyle(color: Colors.black))),
      ),
      body: Center(
          child: Stack(
            children: [
              _getMap(),
              _getTopContainer()
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _proceed,
        child: Icon(Icons.check),
      ),
    );
  }

  void _initialize() async {
    _searchTypes = await SearchTypeService().getSearchTypes();
    _locations = await _geoService.getLocations();

    _getNewLocation();
    _getNewSearchType();
  }

  void _proceed() async {
    if (_answered == true) {
      _showNewQuestion();
      return;
    }

    _answerQuestion();
  }

  void _showNewQuestion() {
    setState(() {
      _getNewLocation();
      _getNewSearchType();
      _entities = [];
      _answered = false;
    });
  }

  Future _answerQuestion() async {
    _indicateLoading();

    _entities = await GeoService(overpassApi: _overpassApi).getEntitiesInArea(
        center: _currentLocation,
        type: _currentType
    );

    Navigator.of(context).pop();

    setState(() {
      _answered = true;
    });
  }

  void _getNewSearchType() {
    _currentType = _searchTypes[Random().nextInt(_searchTypes.length)];
  }

  void _indicateLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(8.0)
                )
            ),
            content: Container(
                child: Text('Fetching geo data ...', textAlign: TextAlign.center,)
            ),
          );
        }
    );
  }

  void _getNewLocation() {
    if (_locations.isEmpty) {
      return;
    }

    setState(() {
      _currentLocation = _locations[Random().nextInt(_locations.length)];
    });

    _mapController.move(
        new LatLng(_currentLocation.latitude, _currentLocation.longitude),
        11
    );
  }

  FlutterMap _getMap() {
    return FlutterMap(
      mapController: _mapController,
      options: new MapOptions(
        interactive: false,
        center: _currentLocation != null ? new LatLng(_currentLocation.latitude, _currentLocation.longitude) : null,
        zoom: 11,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
        ),
        new MarkerLayerOptions(
          markers: _getMarkers(),
        ),
        new MarkerLayerOptions(
          markers: _getAreaMarkers(),
        ),
      ],
    );
  }

  List<Marker> _getMarkers() {
    List<Marker> markers = [];

    for (Location location in _entities) {
      markers.add(
          new Marker(
            width: 6,
            height: 6,
            point: new LatLng(location.latitude, location.longitude),
            builder: (ctx) =>
            new Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
              ),
            ),
          )
      );
    }

    return markers;
  }

  List<Marker> _getAreaMarkers() {
    if (_currentLocation == null) {
      return [];
    }

    return [new Marker(
      width: 230.0,
      height: 230.0,
      point: new LatLng(_currentLocation.latitude, _currentLocation.longitude),
      builder: (ctx) =>
      new Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.1),
            border: Border.all(color: Colors.blueAccent)
        ),
      ),
    )];
  }

  Container _getTopContainer() {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
          padding: EdgeInsets.all(32),
          height: 160,
          alignment: Alignment.center,
          width: double.infinity,
          color: Colors.white.withOpacity(0.8),
          child: Text(
            _getText(),
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          )
      ),
    );
  }

  String _getText() {
    if (_currentLocation == null) {
      return '';
    }

    if (_currentType == null) {
      return '';
    }

    if (_answered == false) {
      return "How many ${_currentType.plural} are there 5 km around ${_currentLocation.name}?";
    }

    return "${_entities.length.toString()} ${_currentType.plural}\naround ${_currentLocation.name}";
  }
}

class GeoService {
  GeoService({
    @required this.overpassApi,
    this.fileName = 'cities_de'
  }): assert(overpassApi != null);

  final OverpassApi overpassApi;
  final String fileName;

  List<Location> _cachedList;

  Future<List<Location>> getLocations() async {
    if (_cachedList == null) {
      Map<dynamic, dynamic> json = await _getJsonFromFile(fileName);
      _cachedList = _jsonToLocations(json);
    }

    return _cachedList;
  }

  ///  searchtypes:   Map<String, String> tags;
  Future<List<Location>> getEntitiesInArea({
    Location center, SearchType type, double radiusInMetres = 5000
  }) async {
    List<ResponseLocation> fetchResult = await this.overpassApi.fetchLocationsAroundCenter(
        QueryLocation(
            longitude: center.longitude,
            latitude: center.latitude
        ),
        type.tags,
        radiusInMetres
    );

    List<Location> result = [];

    fetchResult.forEach((element) {
      result.add(
          Location(
              longitude: element.longitude,
              latitude: element.latitude,
              name: element.name
          )
      );
    });

    return result;
  }

  Future<Map<dynamic, dynamic>> _getJsonFromFile(String fileName) async {
    String jsonString = await rootBundle.loadString('assets/locations/$fileName.json');

    return jsonDecode(jsonString);
  }

  List<Location> _jsonToLocations(Map<dynamic, dynamic> json) {
    List<Location> locations = [];

    // TODO: Or validate here? Or both?

    for (var element in json["elements"]) {
      locations.add(
          Location.fromJson(element)
      );
    }

    return locations;
  }
}

class Location {
  final double longitude;
  final double latitude;
  final String name;

  Location({
    this.longitude,
    this.latitude,
    this.name,
  });

  Location.fromJson(Map<dynamic, dynamic> json) :
        longitude = json['lon'],
        latitude = json['lat'],
        name = json['tags']['name'];
}

class SearchTypeService {
  List<SearchType> _cachedList;

  Future<List<SearchType>> getSearchTypes() async {
    if (_cachedList == null) {
      List<dynamic> json = await _getJsonFromFile('search_types');
      _cachedList = _jsonToSearchTypes(json);
    }

    return _cachedList;
  }

  Future<List<dynamic>> _getJsonFromFile(String fileName) async {
    String jsonString = await rootBundle.loadString('assets/$fileName.json');

    return jsonDecode(jsonString)['elements'];
  }

  List<SearchType> _jsonToSearchTypes(List<dynamic> json) {
    List<SearchType> searchTypes = [];

    for (var element in json) {
      searchTypes.add(
          SearchType.fromJson(element)
      );
    }

    return searchTypes;
  }
}


class SearchType {
  String singular;
  String plural;
  Map<String, String> tags;

  SearchType({
    this.singular,
    this.plural,
    this.tags
  });

  SearchType.fromJson(Map<dynamic, dynamic> json) {
    this.singular = json['name']['singular'];
    this.plural = json['name']['plural'];

    Map<String, String> tags = new Map();

    json['tags'].forEach((key, value) {
      tags[key] = value;
    });

    this.tags = tags;
  }
}