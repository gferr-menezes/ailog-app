import '../models/travel_model.dart';

abstract class TravelRepository {
  Future<List<TravelModel>> checkTravel(String plate);
  Future<void> initTravel(String plate);
  Future<TravelModel> saveTravelInDB(TravelModel travel);
  Future<TravelModel?> getTravelInDB({String? plate, int? id});
  Future<List<TravelModel>?> getTravels({String? plate, int? id});
  Future<void> updateTravel(TravelModel travel);
}
