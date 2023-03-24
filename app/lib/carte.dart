import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart' hide LatLng;
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';




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
                title: MapBoxPlaceSearchWidget(
                    popOnSelect: true,
                    apiKey: 'pk.eyJ1IjoieGJhdHRsYXgiLCJhIjoiY2xmYmpyd2NxMXc0eDNycGMyemNxOXMzOCJ9.NO3mg8yWSpf0HBgcf3coeA',
                    height: 10,
                    onSelected: (place) {
                      mapController.move(
                        LatLng(place.geometry.coordinates[1], place.geometry.coordinates[0]),
                        15.0,
                      );
                    },
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
                        strokeWidth: 4,
                      ),
                    ],
                  ),
                  PolygonLayer(
                    polygonCulling: false,
                    polygons: [
                      Polygon(
                        borderStrokeWidth:4,
                        points: polygonPoints,
                        color: Colors.red,
                        isFilled: true,
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