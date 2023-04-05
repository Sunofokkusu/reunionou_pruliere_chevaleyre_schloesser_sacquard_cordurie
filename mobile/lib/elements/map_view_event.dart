import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:routing_client_dart/routing_client_dart.dart';
import 'package:reunionou/helpers/map_helper.dart';

class MapView extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapView({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<LatLng> roadPoints = [];
  bool _isLoading = true;
  LatLng _postion = LatLng(0, 0);
  double? duration;
  @override
  Widget build(BuildContext context) {
    void getRoad() async {
      Position? position = await mapHelper.getCurrentLocation();
      if (position == null) {
        setState(() {
          _isLoading = false;
        });
      }
      final manager = OSRMManager();
      final route = await manager.getRoad(waypoints: [
        LngLat(
          lng: widget.longitude,
          lat: widget.latitude,
        ),
        LngLat(
          lng: position!.longitude,
          lat: position.latitude,
        ),
      ]);
      // get temps de trajet
      setState(() {
        duration = route.duration;
        roadPoints = route.polyline!.map((e) => LatLng(e.lat, e.lng)).toList();
        _postion = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    }

    if (_isLoading) {
      getRoad();
    }

    return Column(
      children: [
        Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(widget.latitude, widget.longitude),
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c']),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: roadPoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                        markerCenterAnimation: const MarkerCenterAnimation(),
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(widget.latitude, widget.longitude),
                            builder: (ctx) => Container(
                              child: const Icon(Icons.location_on),
                            ),
                          ),
                          if (_postion.longitude != 0 && _postion.latitude != 0)
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _postion,
                              builder: (ctx) => Container(
                                child: const Icon(Icons.person_pin_circle),
                              ),
                            ),
                        ],
                        popupSnap: PopupSnap.markerTop,
                        popupController: PopupController(),
                        popupBuilder: (BuildContext _, Marker marker) =>
                            const Card(
                              child: Text('Point de rendez-vous'),
                            ))),
                if (_postion.longitude != 0 && _postion.latitude != 0)
                  PopupMarkerLayerWidget(
                      options: PopupMarkerLayerOptions(
                          markerCenterAnimation: const MarkerCenterAnimation(),
                          markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _postion,
                              builder: (ctx) => Container(
                                child: const Icon(Icons.person_pin_circle),
                              ),
                            ),
                          ],
                          popupSnap: PopupSnap.markerTop,
                          popupController: PopupController(),
                          popupBuilder: (BuildContext _, Marker marker) =>
                              const Card(
                                child: Text('Votre position'),
                              ))),
              ],
            )),
        if (duration != null)
          Text(
            "Temps de trajet estimé: ${(duration! / 60).round()} minutes",
          ),
      ],
    );
  }
}
