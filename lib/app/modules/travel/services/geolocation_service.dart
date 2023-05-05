import 'package:ailog_app_carga_mobile/app/modules/travel/models/geolocation_model.dart';
import 'package:ailog_app_carga_mobile/app/modules/travel/repositories/geolocation_repository.dart';

class GeolocationService {
  final GeolocationRepository _geolocationRepository;

  GeolocationService({
    required GeolocationRepository geolocationRepository,
  }) : _geolocationRepository = geolocationRepository;

  Future<List<GeolocationModel>>? getLatLongSavedInDb({required int travelId}) async {
    var results = await _geolocationRepository.getGeolocations(travelId: travelId);
    return results ?? [];
  }
}
