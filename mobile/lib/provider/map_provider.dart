import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapProvider extends ChangeNotifier {
  

  String? _adress = "";
  double? _lat = 0;
  double? _long = 0;

  String? get adress => _adress;

  double? get lat => double.parse(_lat.toString());

  double? get long => double.parse(_long.toString());

  void setAdress(String? adress) {
    _adress = adress;
  }

  void setLat(double? lat) {
    _lat = lat;

  }

  void setLong(double? long) {
    _long = long;

  }

  void reset() {
    _adress = "";
    _lat = 0;
    _long = 0;

  }

}