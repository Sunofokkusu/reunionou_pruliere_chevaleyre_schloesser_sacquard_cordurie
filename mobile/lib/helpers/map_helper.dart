import 'package:geocoding/geocoding.dart';

class mapHelper{

  // get the location with coordinates
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0];
        return "${place.street}, ${place.postalCode} ${place.locality}";
      } catch (e) {
        print(e);
        return "Error";
      }
    
  }
}