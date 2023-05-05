import 'package:ailog_app_carga_mobile/app/modules/travel/pages/map_page.dart';
import 'package:ailog_app_carga_mobile/app/modules/travel/travel_binds.dart';
import 'package:get/get.dart';

import '../modules/home/home_bindings.dart';
import '../modules/home/home_page.dart';

class HomeRoutes {
  HomeRoutes._();

  static final routes = <GetPage>[
    GetPage(
      name: '/',
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: '/travel/map',
      page: () => const MapPage(),
      binding: TravelBinds(),
    ),
  ];
}
