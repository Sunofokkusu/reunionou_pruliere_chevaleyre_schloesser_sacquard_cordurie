import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:reunionou/helpers/mapHelper.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/provider/map_provider.dart';

class MapModal extends StatefulWidget {
  late double latitude;
  late double longitude;
  MapModal({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<MapModal> createState() => _MapModalState();
}

class _MapModalState extends State<MapModal> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          center: widget.latitude != 0.0 && widget.longitude != 0.0
              ? LatLng(double.parse(widget.latitude.toString()),
                  double.parse(widget.longitude.toString()))
              : LatLng(48.692054, 6.184417),
          zoom: 13.0,
          onMapCreated: (mapController) async {
            if (widget.latitude != 0.0 && widget.longitude != 0.0) {
              Provider.of<MapProvider>(context, listen: false).setLat(widget.latitude);
              Provider.of<MapProvider>(context, listen: false).setLong(widget.longitude);
              Provider.of<MapProvider>(context, listen: false).setAdress(await mapHelper.getAddressFromCoordinates(widget.latitude, widget.longitude));
            }else{
              Provider.of<MapProvider>(context, listen: false).setLat(48.692054);
              Provider.of<MapProvider>(context, listen: false).setLong(6.184417);
              Provider.of<MapProvider>(context, listen: false).setAdress("Place de la République, 54000 Nancy");
            }
          },
          onTap: (point) async => {
            Provider.of<MapProvider>(context, listen: false).setAdress(
                await mapHelper.getAddressFromCoordinates(
                    point.latitude, point.longitude)),
            setState(() {
              widget.latitude = point.latitude;
              widget.longitude = point.longitude;
              Provider.of<MapProvider>(context, listen: false)
                  .setLat(point.latitude);
              Provider.of<MapProvider>(context, listen: false)
                  .setLong(point.longitude);
            })
          },
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              widget.latitude != 0.0 && widget.longitude != 0.0
                  ? Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(double.parse(widget.latitude.toString()),
                          double.parse(widget.longitude.toString())),
                      builder: (ctx) => Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    )
                  : Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(48.692054, 6.184417),
                      builder: (ctx) => Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
