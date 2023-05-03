import 'dart:developer';

import 'package:ailog_app_carga_mobile/app/modules/travel/models/travel_model.dart';

import 'repositories/travel_repository.dart';

class TravelService {
  final TravelRepository _travelRepository;

  TravelService({
    required TravelRepository travelRepository,
  }) : _travelRepository = travelRepository;

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
}
