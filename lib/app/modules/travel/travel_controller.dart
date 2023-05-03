import 'package:ailog_app_carga_mobile/app/modules/travel/models/travel_model.dart';
import 'package:ailog_app_carga_mobile/app/modules/travel/travel_service.dart';
import 'package:get/get.dart';

import '../../commom/loader_mixin.dart';
import '../../commom/message_mixin.dart';

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
  final loadingTravels = false.obs;
  final _travelInProgress = false.obs;
  List<TravelModel> travelsForSelectedForStart = <TravelModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
    messageListener(message);
  }

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

  Future<List<TravelModel>?> getTravels({String? plate, int? id}) async {
    try {
      loadingTravels.value = true;
      var travelsData = await _travelService.getTravels();
      hideLoading();
      if (travelsData != null) {
        for (var travel in travelsData) {
          if (travel.status == TravelStatus.inProgress.name.toString().toLowerCase()) {
            _travelInProgress.value = true;
            travels.add(travel);
          }
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
      loading.value = true;
      await _travelService.updateTravel(travel);
      loading.toggle();
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
      loading.toggle();
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

  bool get travelInProgress => _travelInProgress.value;

  set travelInProgress(bool value) => _travelInProgress.value = value;

  void hideLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      loadingTravels.value = false;
      startingTravel.value = false;
    });
  }
}
