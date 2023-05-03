import 'package:ailog_app_carga_mobile/app/modules/travel/models/toll_model.dart';
import 'package:ailog_app_carga_mobile/app/modules/travel/models/travel_addresses.dart';

enum TravelStatus {
  inProgress,
  finished,
}

class TravelModel {
  int? id;
  String plate;
  String status;
  DateTime? dateInitTravel;
  double? totalValue;
  String vpoImitName;
  String? statusTravelAPI;
  int travelIdAPI;
  List<TollModel>? tolls;
  List<TravelAddresses>? addresses;

  TravelModel({
    this.id,
    required this.plate,
    required this.status,
    this.dateInitTravel,
    this.totalValue,
    required this.vpoImitName,
    this.statusTravelAPI,
    required this.travelIdAPI,
    this.tolls,
    this.addresses,
  });

  factory TravelModel.fromJson(Map<String, dynamic> json) {
    return TravelModel(
      id: json['id'],
      plate: json['placa'],
      status: json['status'] ?? TravelStatus.inProgress.toString(),
      dateInitTravel: json['dateInitTravel'],
      totalValue: json['valorTotal'],
      vpoImitName: json['emissor'],
      statusTravelAPI: json['status'],
      travelIdAPI: json['idViagem'],
      tolls: json['pedagios'] != null ? (json['pedagios'] as List).map((e) => TollModel.fromJson(e)).toList() : null,
      addresses: json['enderecos'] != null
          ? (json['enderecos'] as List).map((e) => TravelAddresses.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placa': plate,
      'valorTotal': totalValue,
      'emissor': vpoImitName,
      'status': statusTravelAPI,
      'idViagem': travelIdAPI,
      'pedagios': tolls?.map((e) => e.toJson()).toList(),
      'enderecos': addresses?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'TravelModel(id: $id, plate: $plate, status: $status, dateInitTravel: $dateInitTravel, totalValue: $totalValue, vpoImitName: $vpoImitName, statusTravelAPI: $statusTravelAPI, travelIdAPI: $travelIdAPI, tolls: $tolls, addresses: $addresses)';
  }
}
