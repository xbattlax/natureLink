import 'package:flutter/material.dart';
import 'package:chasse_marche_app/widgets/BottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart' hide LatLong;
import 'package:mapbox_gl/mapbox_gl.dart';


final MapBoxPlaceSearchProvider mapBoxSearch = MapBoxPlaceSearchProvider(
  apiKey: 'pk.abc1234567890XYZ',
);

Future<List<MapBoxPlace>> search(String query,
    {int limit = 5, String? language}) async {
  return await mapBoxSearch.search(
    query,
    limit: limit,
    language: language,
  );
}


class Carte extends StatefulWidget {
  @override
  _CarteState createState() => _CarteState();
}

class _CarteState extends State<Carte> {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  bool loading = true;
  List<LatLng> polygonPoints = [];
  List<LatLng> polylinePoints = [];
  bool _addingPolygon = false;
  bool _addingPolyline = false;

  Future<void> _getPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Show a dialog to the user asking them to enable location permissions in the app settings.
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Location Permission'),
          content: Text('Please enable location permissions in the app settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Permission granted, so do nothing.
    }
  }

  void _addPolygonPoint(LatLng point) {
    setState(() {
      polygonPoints.add(point);
      print('Added point: $point');
    });
  }

  void _addPolylinePoint(LatLng point) {
    setState(() {
      polylinePoints.add(point);
      print('Added point: $point');
    });
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      if (_addingPolygon) {
        _addPolygonPoint(latlng);
      } else if (_addingPolyline) {
        _addPolylinePoint(latlng);
      }
    });
  }

  void _onSearch(String query) async {
    List<MapBoxPlace> places = await MapBoxPlaceSearchProvider()
        .search(query, limit: 5, language: 'en');
    if (places.isNotEmpty) {
      mapController.move(
        LatLng(places.first.geometry!.coordinates[1],
            places.first.geometry!.coordinates[0]),
        15.0,
      );
    }
  }
  @override
  void initState() {
    super.initState();
    _getPermission();
  }

  Future<LatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }
  LatLng? currentLocation;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: getCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            currentLocation = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a location',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _onSearch,
                ),
              ),
              body: FlutterMap(
                options: MapOptions(
                  center: currentLocation,
                  zoom: 13.0,
                  keepAlive: true,
                  onTap: (point, latlng) {
                    // Add a new point when the user taps on the map
                    setState(() {
                      _handleTap(latlng);
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLocation!,
                        builder: (ctx) => Icon(Icons.pin_drop),
                      ),
                    ],
                  ),
                  PolylineLayer(
                    polylineCulling: false,
                    polylines: [
                      Polyline(
                        points: polylinePoints,
                        color: Colors.black,
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                  PolygonLayer(
                    polygonCulling: false,
                    polygons: [
                      Polygon(
                        points: polygonPoints,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.lightGreen,
                    onPressed: () {
                      setState(() {
                        _addingPolygon = !_addingPolygon;
                      });
                    },
                    child: Icon(_addingPolygon ? Icons.check : Icons.add),
                  ),
                  SizedBox(height: 16),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      setState(() {
                        _addingPolyline = !_addingPolyline;
                      });
                    },
                    child: Icon(_addingPolyline ? Icons.check : Icons.add),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Failed to get current location'));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}