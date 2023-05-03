// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../travel/pages/travel_page.dart';
import '../travel/travel_binds.dart';

class HomeController extends GetxController {
  static const NAVIGATOR_KEY = 1;

  final _tabIndex = 0.obs;

  int get tabIndex => _tabIndex.value;

  Route? onGenerateRouter(RouteSettings settings) {
    if (settings.name == '/travel') {
      return GetPageRoute(
        settings: settings,
        page: () => const TravelPage(),
        binding: TravelBinds(),
        transition: Transition.fadeIn,
      );
    }
    return null;
  }
}
