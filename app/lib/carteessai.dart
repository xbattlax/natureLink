import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';


class Carte extends StatefulWidget {

  @override
  _CarteState createState() => _CarteState();
}

class _CarteState extends State<Carte> {
  bool loading = true;
  List<LatLng> polygonPoints = [];
  List<LatLng> polylinePoints = [];

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
              body: FlutterMap(
                options: MapOptions(
                  center: currentLocation,
                  zoom: 13.0,
                  keepAlive: true,
                  onTap: (point, latlng) {
                    // Add a new point when the user taps on the map
                    setState(() {
                      _addPolygonPoint(latlng);
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    maxZoom: 19,
                  ),
                  CurrentLocationLayer(),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLocation!, // Use the current location
                        builder: (ctx) => Icon(Icons.pin_drop),
                      ),
                    ],
                  ),
                  PolylineLayer(
                    polylineCulling: false,
                    polylines: [
                      Polyline(
                        points: polylinePoints,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  PolygonLayer(
                    polygonCulling: false,
                    polygons: [
                      Polygon(
                        points: polygonPoints,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      LatLng currentLocation = await getCurrentLocation();
                      _addPolygonPoint(currentLocation);
                      print("Polygon Points: $polygonPoints"); // print the polygon points
                    },
                    child: FloatingActionButton(
                      backgroundColor: Colors.blue, // add a background color to the button
                      onPressed: () {}, // Empty onPressed to avoid warnings
                      child: Icon(Icons.add),
                    ),
                  ),
                  SizedBox(height: 16),
                  FloatingActionButton(
                    backgroundColor: Colors.blue, // add a background color to the button
                    onPressed: () async {
                      LatLng currentLocation = await getCurrentLocation();
                      _addPolylinePoint(currentLocation);
                      print("Polyline Points: $polylinePoints"); // print the polyline points
                    },
                    child: Icon(Icons.add),
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

