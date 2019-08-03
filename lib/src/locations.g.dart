
part of 'locations.dart';


Place _$PlaceFromJson(Map<String, dynamic> json, String nameS) {
  return Place(
      placeId: json['candidates'][0]['place_id'],
      name: nameS,
      photo: json["candidates"][0]["photos"] != null ? json["candidates"][0]["photos"][0]["photo_reference"] : null,
      rating: (json["candidates"][0]["rating"] as num)?.toDouble(),
      latLng: LatLng(
          (json['candidates'][0]['geometry']['location']["lat"] as num)
              .toDouble(),
          (json['candidates'][0]['geometry']['location']["lng"] as num)
              .toDouble()));
}

Directions _$DirectionsFromJson(Map<String, dynamic> json) {
  List<LatLng> points = List();
  PolylinePoints polylinePoints = PolylinePoints();

  for (var step in json["routes"][0]["legs"][0]["steps"]) {
    final encoded = step["polyline"]["points"];
    List<PointLatLng> pointsLatLng = polylinePoints.decodePolyline(encoded);
    for (final pointLatLng in pointsLatLng) {
      final LatLng point = LatLng(pointLatLng.latitude, pointLatLng.longitude);
      points.add(point);
    }
  }
  return Directions(
      durationMinute:
          json["routes"][0]["legs"][0]['duration']['text'] as String,
      distance: json["routes"][0]["legs"][0]['distance']['text'] as String,
      points: points);
}

