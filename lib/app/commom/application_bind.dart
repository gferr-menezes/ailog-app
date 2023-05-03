import 'package:ailog_app_carga_mobile/app/commom/rest_client.dart';
import 'package:get/get.dart';

class ApplicationBind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RestClient(), fenix: true);
  }
}
