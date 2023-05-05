import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../travel/pages/lat_long_page.dart';
import '../travel/pages/travel_page.dart';
import '../travel/travel_binds.dart';

class HomeController extends GetxController {
  // ignore: constant_identifier_names
  static const NAVIGATOR_KEY = 1;

  final _tabIndex = 0.obs;

  int get tabIndex => _tabIndex.value;
  final _tabs = [
    '/travel',
    '/travel/lat-long',
  ];

  set tabIndex(int index) {
    _tabIndex(index);
    Get.toNamed(_tabs[index], id: NAVIGATOR_KEY);
  }

  Route? onGenerateRouter(RouteSettings settings) {
    if (settings.name == '/travel') {
      return GetPageRoute(
        settings: settings,
        page: () => const TravelPage(),
        binding: TravelBinds(),
        transition: Transition.fadeIn,
      );
    }

    if (settings.name == '/travel/lat-long') {
      return GetPageRoute(
        settings: settings,
        page: () => const LatLongPage(),
        binding: TravelBinds(),
        transition: Transition.fadeIn,
      );
    }
    return null;
  }
}
