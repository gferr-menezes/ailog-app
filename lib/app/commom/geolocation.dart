import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';

class Geolocation {
  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("Location services are disabled.");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("Location permissions are denied (actual value: $permission).");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      log(
        "Location permissions are permanently denied, we cannot request permissions (actual value: $permission).",
      );
      return false;
    }
    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      Geolocation._handleLocationPermission();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      log("Error: $e");
    }
    return null;
  }

  static Future<StreamSubscription<Position>?> callPositionStream() async {
    try {
      final LocationSettings locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Coletando dados de localização",
          notificationTitle: "Ailog App",
          enableWakeLock: true,
        ),
      );

      var position = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position? position) {},
      );
      return position;
    } catch (e) {
      log("Error: $e");
    }

    return null;
  }

  static requestPermission() async {
    Geolocation._handleLocationPermission();
  }
}
