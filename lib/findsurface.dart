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

class GeoService {
  GeoService({
    @required this.overpassApi,
    this.fileName = 'cities_de'
  }): assert(overpassApi != null);
  final OverpassApi overpassApi;
  final String fileName;
  ...
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
}
