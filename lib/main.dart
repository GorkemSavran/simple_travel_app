import 'dart:async';
import 'dart:core';

import 'package:first_app/src/locations.dart' as locations;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:first_app/src/loader.dart';
import 'package:first_app/src/map_and_bottom.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  final Map<String, Marker> _markers = {};
  final Set<Polyline> _polylines = Set();
  final List<String> _photos = [];
  final List<double> _ratings = [];
  int darkRedPolyIdx = 0;
  bool flag = false;
  Completer<GoogleMapController> _googleMapController = Completer();

  @override
  void initState() { 
    super.initState();
    _onMapCreated();
  }

  Future<void> _goToIndex(int idx) async {
    final GoogleMapController controller = await _googleMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: _markers.values.elementAt(idx).position, zoom: 18.0)));
  }

  Future<void> _onMapCreated() async {
    final places = await locations.getPlacesFromText();
    setState(() {
      _markers.clear();
      for (final place in places) {
        final marker = Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.latLng.latitude, place.latLng.longitude),
          infoWindow: InfoWindow(title: place.name),
        );
        _markers[place.name] = marker;
        _photos.add(place.photo);
        _ratings.add(place.rating);
        
      }
    });
    for (int i = 0; i < places.length - 1; i++) {
      final directions = await locations.getPoints(
          LatLng(places[i].latLng.latitude, places[i].latLng.longitude),
          LatLng(
              places[i + 1].latLng.latitude, places[i + 1].latLng.longitude));

      setState(() {
        final Polyline polyline = Polyline(
            polylineId: PolylineId(i.toString()),
            points: directions.points,
            color: i == darkRedPolyIdx ? Colors.redAccent : Colors.red[100]);
        _polylines.add(polyline);
      });

    }
    setState(() {
     flag = true; 
    });
  }

  final ThemeData kIOSTheme = ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: Colors.grey[100],
      primaryColorBrightness: Brightness.light);

  final ThemeData kDefaultTheme = ThemeData(
      primarySwatch: Colors.blue, accentColor: Colors.orangeAccent[400]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyApp",
      theme: debugDefaultTargetPlatformOverride == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("İzmir Travel Destinations")),
        ),
        body: flag == true
            ? Column(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: MyMap(
                        firstPosition: _markers.values.first.position,
                        googleMapController: _googleMapController,
                        polylines: _polylines,
                        markers: _markers,
                      )),
                  Divider(
                    color: Colors.black,
                    height: 1.0,
                  ),
                  Expanded(
                    child: BottomScreen(
                      photos: _photos,
                      goToIndex: _goToIndex,
                      markerLength: _markers.length,
                      ratings: _ratings,
                    ),
                    flex: 1,
                  )
                ],
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    child: Loader(),
                    flex: 1,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 1.0,
                  ),
                  Expanded(
                    child: Loader(),
                    flex: 1,
                  )
                ],
              ),
      ),
    );
  }

}
