import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart' hide LatLng;
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Models/user.dart';

class Poly {
  final List<Sommet> sommets;

  Poly({required this.sommets});

  List<LatLng> get latLngs => sommets.map((sommet) => sommet.latLng).toList();
}

class Sommet {
  final int id;
  final double lat;
  final double long;

  Sommet({required this.id, required this.lat, required this.long});

  LatLng get latLng => LatLng(lat, long);
}

class Carte extends StatefulWidget {
  @override
  _CarteState createState() => _CarteState();
}

Future<List<Poly>> getAllPolygons() async {
  final url = 'http://localhost:8000/public/polygons'; // Replace with your API URL
  final headers = {
    'Content-Type': 'application/json',
  };

  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  if (response.statusCode == 200) {
    List<dynamic> responseBody = json.decode(response.body);
    List<Poly> polygons = responseBody.map((polygonData) {
      List<Sommet> sommets = (polygonData['sommets'] as List<dynamic>)
          .map((sommetData) => Sommet(
        id: sommetData['id'],
        lat: double.parse(sommetData['lat']),
        long: double.parse(sommetData['long']),
      ))
          .toList();
      print(sommets);
      return Poly(sommets: sommets);
    }).toList();
    return polygons;
  } else {
    print('Failed to get polygons');
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    return [];
  }
}


Future<bool> savePolygon(List<LatLng> polygonPoints) async {
  final url = 'http://localhost:8000/api/polygon'; // Replace with your API URL

  // Read the JWT token from storage
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');

  // Include the JWT token in the headers
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', // Add the token to the headers
  };

  final sommets = polygonPoints.map((point) => {
    'lat': point.latitude,
    'long': point.longitude,
  }).toList();

  final body = json.encode({
    'sommets': sommets,
  });

  print('''
curl -X POST \\
     -H "Content-Type: application/json" \\
     -H "Authorization: Bearer $token" \\
     -d '$body' \\
     $url
  ''');

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Polygon saved successfully');
    return true;
  } else {
    print('Failed to save polygon');
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    return false;
  }
}



class _CarteState extends State<Carte> {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  bool loading = true;
  List<LatLng> polygonPoints = [];
  List<LatLng> polylinePoints = [];
  bool _addingPolygon = false;
  bool _addingPolyline = false;
  List<Poly> _polygons = [];
  bool isChasseur = false;

  Future<void> _fetchAndDrawPolygons() async {
    List<Poly> polygons = await getAllPolygons();
    setState(() {
      _polygons = polygons.map((polygon) {
        List<Sommet> sommets = polygon.sommets.map((sommet)=> Sommet(id: sommet.id, lat: sommet.lat, long: sommet.long)).toList();
        return Poly(sommets: sommets);
      }).toList();
    });
  }

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

  void _handleTap(LatLng latlng) async {
    if (_addingPolygon) {
      _addPolygonPoint(latlng);
    } else if (_addingPolyline) {
      setState(() {
        _addPolylinePoint(latlng);
      });
    }
  }
  Future<void> getRoles() async {
    final secureStorage = FlutterSecureStorage();
    secureStorage.read(key: 'roles').then((value) {
      if (value != null) {
        List<dynamic> roles = jsonDecode(value);
        if (roles.contains('ROLE_CHASSEUR')) {
          setState(() {
            isChasseur = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getPermission();
    _fetchAndDrawPolygons();
    getRoles();
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
                  //center: currentLocation,
                  center : LatLng(48.1012, 6.4003),
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
                    polygons: _polygons.map((Poly) {
                      return Polygon(
                        borderStrokeWidth: 4,
                        points: Poly.sommets.map((sommet) => LatLng(sommet.lat, sommet.long)).toList(),
                        color: Colors.red.withOpacity(0.5),
                        isFilled: true,
                      );
                    }).toList(),
                  ),
                ],
              ),
              // if user.roles == 'ROLE_CHASSEUR' then


              floatingActionButton:  isChasseur ?  Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.lightGreen,
                    onPressed: () {
                      setState(() {
                        _addingPolygon = !_addingPolygon;
                        if (!_addingPolygon) {
                          savePolygon(polygonPoints); // Save the polygon to the API
                          polygonPoints.clear(); // Clear the points after saving the polygon
                        }
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
              ) : Container(),
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