import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {

  final double latitude;
  final double longitude;

  const MapView({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(widget.latitude, widget.longitude),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(widget.latitude, widget.longitude),
                  builder: (ctx) =>
                  Container(
                    child: const Icon(Icons.location_on),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}