import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatelessWidget {
  LatLng firstPosition;
  Set<Polyline> polylines;
  Completer<GoogleMapController> googleMapController = Completer();
  final Map<String, Marker> markers;

  MyMap(
      {this.googleMapController,
      this.polylines,
      this.firstPosition,
      this.markers});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        googleMapController.complete(controller);
      },
      initialCameraPosition: CameraPosition(target: firstPosition, zoom: 18.0),
      markers: markers.values.toSet(),
      polylines: polylines,
    );
  }
}

class BottomScreen extends StatefulWidget {
  final int markerLength;
  final Function goToIndex;
  final List<String> photos;
  final List<double> ratings;

  BottomScreen({this.markerLength, this.goToIndex, this.photos, this.ratings});

  @override
  State<StatefulWidget> createState() {
    return _BottomScreenState();
  }
}

class _BottomScreenState extends State<BottomScreen> {
  bool _isBackwardClickable;
  bool _isForwardClickable;
  int markerIdx = 0;

  @override
  void initState() {
    super.initState();
    _isBackwardClickable = markerIdx > 0;
    _isForwardClickable = markerIdx < widget.markerLength - 1;
  }

  Widget _starRating(double rating) {
    if (rating == null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.star_border,
            size: 30.0,
          ),
          Icon(
            Icons.star_border,
            size: 30.0,
          ),
          Icon(
            Icons.star_border,
            size: 30.0,
          ),
          Icon(
            Icons.star_border,
            size: 30.0,
          ),
          Icon(
            Icons.star_border,
            size: 30.0,
          ),
        ],
      );
    } else if (rating >= 4.5) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    } else if (rating >= 4.0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star_border),
        ],
      );
    } else if (rating >= 3.5) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star_half),
          Icon(Icons.star_border),
        ],
      );
    } else if (rating >= 3.0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
        ],
      );
    } else if (rating >= 2.5) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star_half),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
        ],
      );
    } else if (rating >= 2.0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
        ],
      );
    } else if (rating >= 1.5) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star),
          Icon(Icons.star_half),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
        ],
      );
    } else if (rating >= 1.0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
        ],
      );
    } else if (rating >= 0.5) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star_half),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(
            Icons.star_border,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        flex: 1,
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                onPressed: _isBackwardClickable
                    ? () {
                        setState(() {
                          markerIdx--;
                          _isBackwardClickable = markerIdx > 0;
                          _isForwardClickable =
                              markerIdx < widget.markerLength - 1;
                          print(markerIdx);
                        });
                        widget.goToIndex(markerIdx);
                      }
                    : () {},
                color: Colors.white,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: _isBackwardClickable ? Colors.black : Colors.grey,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: RaisedButton(
                onPressed: _isForwardClickable
                    ? () {
                        setState(() {
                          markerIdx++;
                          _isForwardClickable =
                              markerIdx < widget.markerLength - 1;
                          _isBackwardClickable = markerIdx > 0;
                        });
                        widget.goToIndex(markerIdx);
                      }
                    : () {},
                color: Colors.white,
                child: Icon(Icons.arrow_forward_ios,
                    color: _isForwardClickable ? Colors.black : Colors.grey),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
            alignment: Alignment.topCenter,
            color: Colors.blue,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: widget.photos[markerIdx] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://maps.googleapis.com/maps/api/place/photo?key=YOUR_API_KEY&photoreference=${widget.photos[markerIdx]}&maxwidth=80',
                          ),
                          radius: 40.0,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40.0,
                        ),
                ),
                Divider(
                  height: 10.0,
                ),
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: _starRating(widget.ratings[markerIdx])),
                )
              ],
            )),
        flex: 8,
      )
    ]);
  }
}