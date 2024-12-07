import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class Location{
  String? currentAddress;
  Position? currentPosition;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please Keep your location On.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission is denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
      msg: "Permission is denied forever. Please enable it in settings.");
    await Geolocator.openAppSettings();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      currentPosition = position;
      currentAddress = "${place.locality}, ${place.country}";

    } catch (e) {
      print(e.toString());
    }
  }

}
