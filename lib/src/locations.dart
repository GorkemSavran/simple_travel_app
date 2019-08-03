import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

part 'locations.g.dart';


@JsonSerializable(nullable: true)
class Place {
  Place({this.placeId, this.name, this.latLng,this.photo,this.rating});

  factory Place.fromJson(Map<String, dynamic> json, String nameS) =>
      _$PlaceFromJson(json, nameS);

  final String placeId;
  final LatLng latLng;
  final String name;
  final String photo;
  final double rating;
}

@JsonSerializable()
class Directions {
  Directions({this.durationMinute, this.distance, this.points});

  factory Directions.fromJson(Map<String, dynamic> json) =>
      _$DirectionsFromJson(json);

  final String durationMinute;
  final String distance;
  final List<LatLng> points;
}
Future<List<Place>> getPlacesFromText() async {
  List<String> placeTxts = List<String>();
  List<Place> places = List<Place>();
  var filePath = "assets/res/places.txt";
  String file = await rootBundle.loadString(filePath);
  placeTxts = file.split("\n");
  for (var placeTxt in placeTxts) {
    final Place place = await getPlace(placeTxt);
    print(place.name);
    places.add(place);
  }
  return places;
}

Future<Place> getPlace(String placeTxt) async {
  String query =
      'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=YOUR_API_KEY&input=${placeTxt}&inputtype=textquery&fields=geometry,place_id,photos,rating';
  final response = await http.get(query);
  print(response.body);
  if (response.statusCode == 200) {
    return Place.fromJson(jsonDecode(response.body), placeTxt);
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(query));
  }
}

Future<Directions> getPoints(LatLng origin, LatLng destination) async {
  String query =
      'https://maps.googleapis.com/maps/api/directions/json?key=YOUR_API_KEY&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}';
  print(query);
  final response = await http.get(query);
  if (response.statusCode == 200) {
    return await Directions.fromJson(jsonDecode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(query));
  }
}

