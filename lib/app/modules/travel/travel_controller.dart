import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../commom/geolocation.dart';
import '../../commom/loader_mixin.dart';
import '../../commom/message_mixin.dart';
import 'models/travel_model.dart';
import 'services/travel_service.dart';

class TravelController extends GetxController with LoaderMixin, MessageMixin {
  final TravelService _travelService;

  TravelController({
    required TravelService travelService,
  }) : _travelService = travelService;

  final loadingStartingTravel = false.obs;
  final startingTravel = false.obs;
  final loading = false.obs;
  final message = Rxn<MessageModel>();
  var travels = <TravelModel>[].obs;
  final loadingTravels = true.obs;
  final _travelInProgress = false.obs;
  final _appIsOnline = false.obs;
  List<TravelModel> travelsForSelectedForStart = <TravelModel>[].obs;
  final _idTravelSelected = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
    messageListener(message);
  }

  bool get travelInProgress => _travelInProgress.value;
  set travelInProgress(bool value) => _travelInProgress.value = value;

  bool get appIsOnline => _appIsOnline.value;
  set appIsOnline(bool value) => _appIsOnline.value = value;

  int get idTravelSelected => _idTravelSelected.value;

  Future<void> startTravel(String plate, {int? idTravelSelected}) async {
    try {
      startingTravel.value = true;
      if (idTravelSelected != null) {
        loadingStartingTravel.value = true;
        final travel = travelsForSelectedForStart.where((element) => element.travelIdAPI == idTravelSelected).first;
        await _travelService.saveTravelInDB(travel);
        await _travelService.initTravel(plate);
        travelsForSelectedForStart = [];
        message(
          MessageModel(
            message: 'Viagem iniciada com sucesso',
            title: 'Mensagem de sucesso',
            type: MessageType.success,
          ),
        );
        await getTravels();
        hideLoading();
        Future.delayed(const Duration(seconds: 2), () {
          loadingStartingTravel.value = false;
        });
        return;
      }

      List<TravelModel> travels = await _travelService.checkTravel(plate);

      if (travels.length == 1) {
        await _travelService.saveTravelInDB(travels[0]);
        await _travelService.initTravel(plate);
      } else {
        travelsForSelectedForStart = travels;
      }
      hideLoading();
    } catch (e) {
      hideLoading();
      message(
        MessageModel(
          message: 'Erro ao iniciar a viagem',
          title: 'Mensagem de erro',
          type: MessageType.error,
        ),
      );
      throw Exception('Erro ao iniciar viagem');
    }
  }

  Future<List<TravelModel>?> getTravels({String? plate, int? id, bool? showLoading = true}) async {
    try {
      Future.delayed(const Duration(milliseconds: 1), () {
        loadingTravels.value = showLoading!;
      });

      var travelsData = await _travelService.getTravels();
      travels.clear();

      hideLoading();
      if (travelsData != null) {
        for (var travel in travelsData) {
          if (travel.status == TravelStatus.inProgress.name.toString().toLowerCase()) {
            _travelInProgress.value = true;
            travels.add(travel);
          }
        }

        if (travelsData.isNotEmpty) {
          _idTravelSelected.value = travelsData.first.travelIdAPI;
        }

        return travelsData;
      }
      return null;
    } catch (e) {
      hideLoading();
      throw Exception('Erro ao buscar viagens');
    }
  }

  Future<void> updateTravel(TravelModel travel) async {
    try {
      //loading.value = true;
      await _travelService.updateTravel(travel);
      //loading.toggle();
      travels.clear();
      travelInProgress = false;
      message(
        MessageModel(
          message: 'Viagem finalizada com sucesso',
          title: 'Mensagem de sucesso',
          type: MessageType.success,
        ),
      );
    } catch (e) {
      //loading.toggle();
      message(
        MessageModel(
          message: 'Erro ao finalizar a viagem',
          title: 'Mensagem de erro',
          type: MessageType.error,
        ),
      );
      throw Exception('Erro ao atualizar viagem');
    }
  }

  Future<Position?> getLatLong() async {
    return await Geolocation.getCurrentPosition();
  }

  Future<void> sendLocation() async {
    Position? position = await getLatLong();
    int? travelId;

    /**
     * filter travels in progress
     */
    var travelData = travels.where((element) => element.status == TravelStatus.inProgress.name.toLowerCase()).toList();

    if (travelData.isNotEmpty) {
      travelId = travelData.first.travelIdAPI;
    }

    if (travelId == null || position == null) {
      await _travelService.sendLocationsPending();
      return;
    }

    await _travelService.sendLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      id: travelData.first.id!,
    );

    _travelService.getTolls(travelData.first).then((value) {
      travels.clear();
      getTravels(showLoading: false);
    });

    await _travelService.sendLocationsPending();
  }

  String getStatusTravel(String status) {
    if (status.toLowerCase() == TravelStatus.inProgress.name.toLowerCase()) {
      return 'Em andamento';
    } else if (status.toLowerCase() == TravelStatus.finished.name.toLowerCase()) {
      return 'Finalizada';
    } else {
      return 'Desconhecido';
    }
  }

  void hideLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      loadingTravels.value = false;
      startingTravel.value = false;
    });
  }
}
