import '../models/geolocation_model.dart';

abstract class GeolocationRepository {
  Future<void> sendPosition(GeolocationModel geolocation, String plate);
  Future<GeolocationModel> savePosition(GeolocationModel geolocation);
  Future<List<GeolocationModel>>? getGeolocations({String? plate, int? id, String? statusSend, int? travelId});
  Future<void> update(GeolocationModel geolocation);
}
