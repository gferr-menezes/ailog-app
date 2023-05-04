import 'package:ailog_app_carga_mobile/app/modules/travel/repositories/geolocation_repository.dart';
import 'package:ailog_app_carga_mobile/app/modules/travel/repositories/geolocation_repository_impl.dart';
import 'package:get/get.dart';

import 'repositories/travel_repository.dart';
import 'repositories/travel_repository_impl.dart';
import 'travel_controller.dart';
import 'travel_service.dart';

class TravelBinds implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelRepository>(() => TravelRepositoryImpl(restClient: Get.find()));
    Get.lazyPut<GeolocationRepository>(() => GeolocationRepositoryImpl(restClient: Get.find()));

    Get.lazyPut<TravelService>(
      () => TravelService(
        travelRepository: Get.find(),
        geolocationRepository: Get.find(),
      ),
    );

    Get.lazyPut(() => TravelController(travelService: Get.find()));
  }
}
