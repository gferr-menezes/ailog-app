import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../commom/rest_client.dart';
import '../../../database/database_sqlite.dart';
import '../models/geolocation_model.dart';
import './geolocation_repository.dart';

class GeolocationRepositoryImpl implements GeolocationRepository {
  final RestClient _restClient;

  GeolocationRepositoryImpl({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<void> sendPosition(GeolocationModel geolocation, String plate) async {
    try {
      String date = geolocation.collectionDate.toString();
      DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      String dateFormated = dateFormat.format(DateTime.parse(date));

      final db = await DatabaseSQLite().openConnection();
      var travelData = await db.query('travel', where: 'travel_id = ?', whereArgs: [geolocation.travelId]);
      var travel = travelData.first;

      var dataSend = jsonEncode({
        'idViagem': travel['travel_id'],
        'placa': plate,
        'pontos': [
          {
            'dataHoraPosicao': dateFormated,
            'latLng': {
              'latitude': geolocation.latitude,
              'longitude': geolocation.longitude,
            }
          }
        ]
      });

      final response = await _restClient.post('/enviarPontos', dataSend);

      var result = response.body;
      if (result == null || result['status'] != 'SUCESSO') {
        throw Exception(result == null ? 'error_communication_backend' : result['status']);
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<GeolocationModel> savePosition(GeolocationModel geolocation) async {
    try {
      final db = await DatabaseSQLite().openConnection();
      var result = await db.insert('geolocation', {
        'latitude': geolocation.latitude,
        'longitude': geolocation.longitude,
        'collection_date': geolocation.collectionDate.toString(),
        'status_send': geolocation.statusSend,
        'travel_id': geolocation.travelId,
      });

      return GeolocationModel(
        id: result,
        latitude: geolocation.latitude,
        longitude: geolocation.longitude,
        collectionDate: geolocation.collectionDate,
        statusSend: geolocation.statusSend,
        travelId: geolocation.travelId,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<GeolocationModel>>? getGeolocations({String? plate, int? id, String? statusSend}) async {
    final db = await DatabaseSQLite().openConnection();

    var where = '';
    var whereArgs = [];

    if (plate != null) {
      where = 'plate = ?';
      whereArgs = [plate.toLowerCase()];
    }

    if (id != null) {
      where = 'id = ?';
      whereArgs = [id];
    }

    if (statusSend != null) {
      where = 'status_send = ?';
      whereArgs = [statusSend.toLowerCase()];
    }

    var results = await db.query('geolocation', where: where, whereArgs: whereArgs);

    List<GeolocationModel>? geolocations = [];

    for (var result in results) {
      geolocations.add(GeolocationModel(
        id: result['id'] as int,
        latitude: double.parse(result['latitude'].toString()),
        longitude: double.parse(result['longitude'].toString()),
        collectionDate: DateTime.parse(result['collection_date'] as String),
        statusSend: result['status_send'] as String,
        travelId: result['travel_id'] as int,
      ));
    }

    return geolocations;
  }

  @override
  Future<void> update(GeolocationModel geolocation) async {
    final db = await DatabaseSQLite().openConnection();

    await db.update(
      'geolocation',
      {
        'status_send': geolocation.statusSend,
      },
      where: 'id = ?',
      whereArgs: [geolocation.id],
    );
  }
}
