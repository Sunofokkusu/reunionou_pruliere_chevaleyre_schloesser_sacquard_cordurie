import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class mapHelper{

  // get the location with coordinates
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0];
        return "${place.street}, ${place.postalCode} ${place.locality}";
      } catch (e) {
        return "Error";
      }
  }

  static Future<Position?> getCurrentLocation() async {
    // ensure initialized
    try{
      await Geolocator.isLocationServiceEnabled();
    }catch(e){
      return null;
    }
    // get current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}