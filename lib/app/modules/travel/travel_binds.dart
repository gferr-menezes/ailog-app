import 'package:get/get.dart';

import 'repositories/travel_repository.dart';
import 'repositories/travel_repository_impl.dart';
import 'travel_controller.dart';
import 'travel_service.dart';

class TravelBinds implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelRepository>(() => TravelRepositoryImpl(restClient: Get.find()));

    Get.lazyPut<TravelService>(() => TravelService(travelRepository: Get.find()));

    Get.lazyPut(() => TravelController(travelService: Get.find()));
  }
}
