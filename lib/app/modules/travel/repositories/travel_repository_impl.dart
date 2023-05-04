import 'dart:developer';
import 'package:ailog_app_carga_mobile/app/modules/travel/models/toll_model.dart';
import 'package:ailog_app_carga_mobile/app/modules/travel/models/travel_addresses.dart';
import 'package:intl/intl.dart';

import '../../../commom/rest_client.dart';
import '../../../database/database_sqlite.dart';
import '../models/travel_model.dart';
import './travel_repository.dart';

class TravelRepositoryImpl implements TravelRepository {
  final RestClient _restClient;

  TravelRepositoryImpl({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<List<TravelModel>> checkTravel(String plate) async {
    try {
      final response = await _restClient.post('/viagem/find', {
        'placa': plate,
      });

      if (response.hasError) {
        log('Erro ao iniciar viagem: ${response.statusText}', stackTrace: StackTrace.current);
        throw RestClientException('Erro ao iniciar viagem', code: response.statusCode);
      } else {
        final status = response.body['status'];
        if (status != 'SUCESSO') {
          log('Erro ao iniciar viagem: ${response.body['message']}', stackTrace: StackTrace.current);
          throw Exception('Erro ao iniciar viagem');
        }

        final data = response.body;
        final travelsData = data['viagens'] as List;

        final List<TravelModel> travels = [];
        List<TravelAddresses> addresses = [];

        late DateTime dateInitTravel;

        for (var travelData in travelsData) {
          if (travelData['dataHoraPrevisaoInicio'] != null) {
            var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
            dateInitTravel = inputFormat.parse(travelData['dataHoraPrevisaoInicio']);
          } else {
            dateInitTravel = DateTime.now();
          }

          final List tolls = [];
          final tollsData = travelData['pedagios'] as List;
          final addressesData = travelData['enderecos'] as List;
          addresses = [];
          for (var address in addressesData) {
            var cityData = address['cidade'];

            addresses.add(
              TravelAddresses(
                city: cityData['cidade']?.toString().toLowerCase() ?? '',
                state: cityData['uf']?.toString().toLowerCase() ?? '',
              ),
            );
          }

          for (var tollData in tollsData) {
            DateTime? date;

            if (tollData['dataHoraPassagem'] != null) {
              var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
              date = inputFormat.parse(tollData['dataHoraPassagem']);
            }

            tolls.add({
              'travelId': travelData['idViagem'],
              'ordemPassagem': tollData['ordemPassagem'],
              'codigoPedagio': tollData['codigoPedagio'],
              'nomePedagio': tollData['nomePedagio'],
              'concessionaria': tollData['concessionaria'],
              'rodovia': tollData['rodovia'],
              'valor': tollData['valor'] as double,
              'dataHoraPassagem': date,
            });
          }

          var travel = TravelModel.fromJson({
            'placa': plate,
            'status': TravelStatus.inProgress.name,
            'dateInitTravel': dateInitTravel,
            'valorTotal': travelData['valorTotal'],
            'emissor': travelData['emissor'],
            'idViagem': travelData['idViagem'],
            'pedagios': tolls,
          });

          travel.addresses = addresses;
          travels.add(travel);
        }

        return travels;
      }
    } catch (e) {
      log('Erro ao iniciar viagem: $e', stackTrace: StackTrace.current);
      throw Exception('Erro ao iniciar viagem');
    }
  }

  @override
  Future<void> initTravel(String plate) async {
    try {
      await _restClient.post('/viagem/iniciar', {
        'placa': plate,
      });
      log('Viagem iniciada com sucesso');
    } catch (e) {
      log('Erro ao iniciar viagem: $e', stackTrace: StackTrace.current);
      throw Exception('Erro ao iniciar viagem');
    }
  }

  @override
  Future<TravelModel> saveTravelInDB(TravelModel travel) async {
    try {
      final db = await DatabaseSQLite().openConnection();

      final travelId = await db.insert('travel', {
        'plate': travel.plate.toLowerCase(),
        'status': travel.status.toLowerCase(),
        'date_init_travel': travel.dateInitTravel?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'status_travel': travel.statusTravelAPI?.toLowerCase(),
        'emissor': travel.vpoImitName.toLowerCase(),
        'valor_total': travel.totalValue,
        'travel_id': travel.travelIdAPI,
      });

      if (travelId == 0) {
        throw Exception('Erro ao salvar viagem');
      }

      List<TollModel>? tolls = [];
      tolls = travel.tolls;
      if (tolls == null) {
        throw Exception('Erro ao salvar pedágios');
      }

      for (var tool in tolls) {
        await db.insert('tolls', {
          'travel_id': travelId,
          'pass_order': tool.passingOrder,
          'tolls_code': tool.tollCode,
          'tolls_name': tool.tollName?.toLowerCase(),
          'concessionaire': tool.concessionaire?.toLowerCase(),
          'highway': tool.highway?.toLowerCase(),
          'value': tool.value,
          'date_time_pasage': tool.passingDateTime?.toIso8601String(),
        });
      }

      return travel;
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
      throw Exception('Erro ao salvar viagem');
    }
  }

  @override
  Future<TravelModel?> getTravelInDB({String? plate, int? id}) async {
    try {
      final db = await DatabaseSQLite().openConnection();

      if (plate == null && id == null) {
        throw Exception('Erro ao buscar viagem');
      }

      dynamic travelData;

      if (plate != null) {
        travelData = await db.query('travel', where: 'plate = ?', whereArgs: [plate.toLowerCase()]);
      }

      if (id != null) {
        travelData = await db.query('travel', where: 'id = ?', whereArgs: [id]);
      }

      if (travelData.isEmpty) {
        return null;
      }

      final travel = TravelModel(
        plate: travelData[0]['plate'],
        status: travelData[0]['status'],
        dateInitTravel: DateTime.parse(travelData[0]['date_init_travel']),
        statusTravelAPI: travelData[0]['status_travel'],
        vpoImitName: travelData[0]['emissor'],
        totalValue: travelData[0]['valor_total'],
        travelIdAPI: travelData[0]['travel_id'],
      );

      var tollsData = await db.query('tolls', where: 'travel_id = ?', whereArgs: [travelData[0]['id']]);

      if (tollsData.isNotEmpty) {
        List<TollModel> tolls = [];

        for (var toll in tollsData) {
          tolls.add(
            TollModel(
              id: toll['id'] as int,
              travelId: toll['travel_id'] as int,
              concessionaire: toll['concessionaire'] == null ? null : toll['concessionaire'] as String,
              passingOrder: toll['pass_order'] as int,
              tollCode: toll['tolls_code'].toString(),
              highway: toll['highway'] == null ? null : toll['highway'] as String,
              passingDateTime:
                  toll['date_time_pasage'] == null ? null : DateTime.parse(toll['date_time_pasage'] as String),
              tollName: toll['tolls_name'] == null ? null : toll['tolls_name'] as String,
              value: toll['value'] as double,
            ),
          );
        }

        travel.tolls = tolls;
      }

      return travel;
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
      throw Exception('Erro ao buscar viagem');
    }
  }

  @override
  Future<List<TravelModel>?> getTravels({String? plate, int? id}) async {
    try {
      final db = await DatabaseSQLite().openConnection();
      List travelsData = [];

      if (plate != null) {
        travelsData = await db.query('travel', where: 'plate = ?', whereArgs: [plate.toLowerCase()]);
      }

      if (id != null) {
        travelsData = await db.query('travel', where: 'id = ?', whereArgs: [id]);
      }

      if (plate == null && id == null) {
        travelsData = await db.query('travel');
      }

      if (travelsData.isEmpty) {
        return null;
      }

      List<TravelModel> travels = [];

      for (var travelData in travelsData) {
        List<TollModel> tolls = [];

        var tollsData = await db.query('tolls', where: 'travel_id = ?', whereArgs: [travelData['id']]);

        for (var toll in tollsData) {
          tolls.add(
            TollModel(
              id: toll['id'] as int,
              travelId: toll['travel_id'] as int,
              concessionaire: toll['concessionaire'] == null ? null : toll['concessionaire'] as String,
              passingOrder: toll['pass_order'] as int,
              tollCode: toll['tolls_code'].toString(),
              highway: toll['highway'] == null ? null : toll['highway'] as String,
              passingDateTime:
                  toll['date_time_pasage'] == null ? null : DateTime.parse(toll['date_time_pasage'] as String),
              tollName: toll['tolls_name'] == null ? null : toll['tolls_name'] as String,
              value: toll['value'] as double,
            ),
          );
        }

        var travel = TravelModel(
          id: travelData['id'],
          plate: travelData['plate'],
          status: travelData['status'],
          dateInitTravel: DateTime.parse(travelData['date_init_travel']),
          statusTravelAPI: travelData['status_travel'],
          vpoImitName: travelData['emissor'],
          totalValue: travelData['valor_total'],
          travelIdAPI: travelData['travel_id'],
          tolls: tolls,
        );

        travels.add(travel);
      }

      return travels;
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
      throw Exception('Erro ao buscar viagem');
    }
  }

  @override
  Future<void> updateTravel(TravelModel travel) async {
    try {
      final db = await DatabaseSQLite().openConnection();
      await db.update(
        'travel',
        {
          'status': travel.status.toLowerCase(),
          'status_travel': travel.statusTravelAPI?.toLowerCase(),
          'valor_total': travel.totalValue,
        },
        where: 'id = ?',
        whereArgs: [travel.id],
      );
    } catch (e) {
      throw Exception('Erro ao atualizar viagem');
    }
  }

  @override
  Future<List<TollModel>> getTolls(TravelModel travel) async {
    try {
      var result = await _restClient.get('/viagem/getPedagios/${travel.travelIdAPI}');

      var resultData = result.body;
      final pedagios = resultData['pedagios'];
      List<TollModel> tolls = [];

      for (var toll in pedagios) {
        String? date;
        if (toll['dataHoraPassagem'] != null) {
          List checkDate = toll['dataHoraPassagem'].split('/');
          if (checkDate.length > 1) {
            var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
            var date1 = inputFormat.parse(toll['dataHoraPassagem']);
            var outputFormat = DateFormat('yyyy-MM-dd HH:mm');
            var date2 = outputFormat.format(date1); // 2019-08-18
            date = date2;
          } else {
            date = toll['dataHoraPassagem'];
          }
        }

        tolls.add(
          TollModel(
            passingOrder: toll['ordemPassagem'],
            tollCode: toll['codigoPedagio'],
            concessionaire: toll['concessionaria'],
            highway: toll['rodovia'],
            passingDateTime: date == null ? null : DateTime.parse(date),
            tollName: toll['nomePedagio'],
            value: toll['valor'],
            travelId: travel.id!,
          ),
        );
      }

      return tolls;
    } catch (e) {
      throw Exception('Erro ao buscar pedágios');
    }
  }

  @override
  Future<void> updateToll(TollModel toll) async {
    final db = await DatabaseSQLite().openConnection();

    /**
     * update per travel id and pass order
     */
    await db.update(
      'tolls',
      {
        'concessionaire': toll.concessionaire?.toLowerCase(),
        'pass_order': toll.passingOrder,
        'tolls_code': toll.tollCode,
        'highway': toll.highway?.toLowerCase(),
        'date_time_pasage': toll.passingDateTime?.toIso8601String(),
        'tolls_name': toll.tollName?.toLowerCase(),
        'value': toll.value,
      },
      where: 'travel_id = ? and pass_order = ?',
      whereArgs: [toll.travelId, toll.passingOrder],
    );
  }
}
