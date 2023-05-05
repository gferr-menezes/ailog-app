import 'package:ailog_app_carga_mobile/app/modules/travel/models/geolocation_model.dart';
import 'package:ailog_app_carga_mobile/app/modules/travel/services/geolocation_service.dart';
import 'package:get/get.dart';

class GeolocationContoller extends GetxController {
  final GeolocationService _geolocationService;

  final _loadingLatLong = true.obs;
  final _latLongList = <GeolocationModel>[].obs;

  bool get loadingLatLong => _loadingLatLong.value;
  set loadingLatLong(bool value) => _loadingLatLong.value = value;
  RxList<GeolocationModel> get latLongList => _latLongList;

  GeolocationContoller({
    required GeolocationService geolocationService,
  }) : _geolocationService = geolocationService;

  Future<void> getLatLongSavedInDb(int travelId) async {
    try {
      var results = await _geolocationService.getLatLongSavedInDb(travelId: travelId);
      results?.sort((a, b) => b.id!.compareTo(a.id!));
      latLongList.value = results ?? [];
      hideLoading();
    } catch (e) {
      hideLoading();
    }
  }

  void hideLoading() {
    Future.delayed(const Duration(seconds: 2), () {
      loadingLatLong = false;
    });
  }
}
