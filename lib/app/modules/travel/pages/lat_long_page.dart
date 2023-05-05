import 'package:ailog_app_carga_mobile/app/modules/travel/travel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/lat_long_list.dart';

class LatLongPage extends StatefulWidget {
  const LatLongPage({Key? key}) : super(key: key);

  @override
  State<LatLongPage> createState() => _LatLongPageState();
}

class _LatLongPageState extends State<LatLongPage> {
  var travelController = Get.find<TravelController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int idTravelSelected = travelController.idTravelSelected;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LatLongList(idTravelSelected: idTravelSelected),
    );
  }
}
