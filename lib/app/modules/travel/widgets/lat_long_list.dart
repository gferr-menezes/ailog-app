import 'package:ailog_app_carga_mobile/app/commom/widgets/loading.dart';
import 'package:ailog_app_carga_mobile/app/commom/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../geolocation_controller.dart';

class LatLongList extends StatelessWidget {
  final int idTravelSelected;

  const LatLongList({super.key, required this.idTravelSelected});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<GeolocationContoller>();
    Future.delayed(const Duration(milliseconds: 2), () {
      controller.loadingLatLong = true;
    });
    controller.getLatLongSavedInDb(idTravelSelected);

    var latLongList = controller.latLongList;

    return Obx(() {
      return latLongList.isEmpty
          ? const Center(
              child: NotFound(),
            )
          : SizedBox(
              child: controller.loadingLatLong
                  ? const Center(
                      child: Loading(),
                    )
                  : ListView.builder(
                      itemCount: latLongList.length,
                      itemBuilder: (context, index) {
                        final geoLocationData = latLongList[index];
                        return Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/travel/map', arguments: geoLocationData);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.location_on,
                                    size: 50,
                                    color: geoLocationData.statusSend == 'sended' ? Colors.green : Colors.grey,
                                  ),
                                  title: Text('Latitude: ${geoLocationData.latitude}'),
                                  subtitle: Text('Longitude: ${geoLocationData.longitude}'),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Coletado em:'),
                                      Text(
                                        DateFormat('dd/MM/yyyy HH:mm').format(geoLocationData.collectionDate),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            );
    });
  }
}
