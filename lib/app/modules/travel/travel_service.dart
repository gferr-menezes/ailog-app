import 'models/geolocation_model.dart';
import 'models/travel_model.dart';
import 'repositories/geolocation_repository.dart';
import 'repositories/travel_repository.dart';

class TravelService {
  final TravelRepository _travelRepository;
  final GeolocationRepository _geolocationRepository;

  TravelService({
    required TravelRepository travelRepository,
    required GeolocationRepository geolocationRepository,
  })  : _travelRepository = travelRepository,
        _geolocationRepository = geolocationRepository;

  Future<List<TravelModel>> checkTravel(String plate) async {
    var travels = await _travelRepository.checkTravel(plate);
    return travels;
  }

  Future<void> initTravel(String plate) async {
    await _travelRepository.initTravel(plate);
  }

  Future<void> saveTravelInDB(TravelModel travel) async {
    await _travelRepository.saveTravelInDB(travel);
  }

  Future<TravelModel?> getTravelInDB({String? plate, int? id}) async {
    return await _travelRepository.getTravelInDB(plate: plate, id: id);
  }

  Future<List<TravelModel>?> getTravels({String? plate, int? id}) async {
    List<TravelModel>? travels;
    travels = await _travelRepository.getTravels(plate: plate, id: id);
    return travels;
  }

  Future<void> updateTravel(TravelModel travel) async {
    await _travelRepository.updateTravel(travel);
  }

  Future<void> sendLocation({required double latitude, required double longitude, required int id}) async {
    TravelModel? travel = await getTravelInDB(id: id);

    GeolocationModel geolocation = GeolocationModel(
      latitude: latitude,
      longitude: longitude,
      collectionDate: DateTime.now(),
      statusSend: StatusSend.pending.name.toLowerCase(),
      travelId: travel!.travelIdAPI,
    );

    try {
      if (travel.status == TravelStatus.finished.name.toLowerCase()) {
        return;
      }

      await _geolocationRepository.sendPosition(geolocation, travel.plate);
      geolocation.statusSend = StatusSend.sended.name.toLowerCase();
      await _geolocationRepository.savePosition(geolocation);
    } catch (e) {
      if (travel.status == TravelStatus.finished.name.toLowerCase()) {
        return;
      }

      await _geolocationRepository.savePosition(geolocation);

      throw Exception(e);
    }
  }

  Future<void> sendLocationsPending() async {
    List<GeolocationModel>? geolocations =
        await _geolocationRepository.getGeolocations(statusSend: StatusSend.pending.name.toLowerCase());

    if (geolocations == null) {
      return;
    }

    for (var geolocation in geolocations) {
      TravelModel? travel = await getTravelInDB(id: geolocation.travelId);
      if (travel != null) {
        await _geolocationRepository.sendPosition(geolocation, travel.plate);
        geolocation.statusSend = StatusSend.sended.name.toLowerCase();
        await _geolocationRepository.update(geolocation);
      }
    }
  }

  Future<void> getTolls(TravelModel travel) async {
    final tolls = await _travelRepository.getTolls(travel);

    if (tolls.isNotEmpty) {
      for (var toll in tolls) {
        await _travelRepository.updateToll(toll);
      }
    }
  }
}
