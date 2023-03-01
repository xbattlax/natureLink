

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
class Carte extends StatefulWidget {

  @override
  State<Carte> createState() => _CarteState();
}

class _CarteState extends State<Carte> with OSMMixinObserver{
  MapController controller= MapController(
    initMapWithUserPosition: true,
    );
  var loading=true;


  @override
  void initState() {
    super.initState();
    controller.enableTracking();
    //await controller.currentPosition();
    controller.addObserver(this);
    print("initState() called");
  }

  @override
  Widget build(BuildContext context) {


    return OSMFlutter(
          controller:controller,
          trackMyPosition: false,
          initZoom: 12,
          minZoomLevel: 8,
          maxZoomLevel: 14,
          onMapIsReady: (isReady) {
            if (isReady) {
              print("map is ready");
            }
          },
          userLocationMarker: UserLocationMaker(
            personMarker: MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.red,
                size: 48,
              ),
            ),
            directionArrowMarker: MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          roadConfiguration: RoadConfiguration(
            startIcon: MarkerIcon(
              icon: Icon(
                Icons.person,
                size: 64,
                color: Colors.brown,
              ),
            ),
            roadColor: Colors.yellowAccent,
          ),
          markerOption: MarkerOption(
              defaultMarker: MarkerIcon(
                icon: Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 56,
                ),
              )
          ),
        );
  }
  @override
  Future<void> mapIsReady(bool isReady) async {
    print("mapIsReady() called");
    print("isReady: $isReady");
    if (isReady) {
      setState(() {
        loading = false;
      });
    }
    else {
      setState(() {
        loading = true;
      });
    }
  }




}