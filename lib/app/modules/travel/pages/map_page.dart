import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../commom/widgets/loading.dart';
import '../../../widgets/app_custom_app_bar.dart';
import '../models/geolocation_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  //final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  bool loadingMap = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loadingMap = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
   * get params from Get.toNamed('/travel/map', arguments: geoLocationData);
   */
    GeolocationModel geoLocationData = Get.arguments;
    log('geoLocationData: $geoLocationData');

    return Scaffold(
      appBar: AppCustomAppBar(),
      body: loadingMap == true
          ? const Center(
              child: Loading(message: 'carregando mapa...'),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(geoLocationData.latitude, geoLocationData.longitude),
                zoom: 5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("source"),
                  position: LatLng(geoLocationData.latitude, geoLocationData.longitude),
                  infoWindow: InfoWindow(
                    title: 'Você passou por aqui',
                    snippet: 'Lat: ${geoLocationData.latitude} - Long: ${geoLocationData.longitude}',
                  ),
                ),
                const Marker(
                  markerId: MarkerId("destination"),
                  position: LatLng(-20.943752483078658, -47.81908327190443),
                  infoWindow: InfoWindow(
                    title: 'Ailog',
                    snippet: 'Lat: -20.943752483078658 - Long: -47.81908327190443',
                  ),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: [
                    LatLng(geoLocationData.latitude, geoLocationData.longitude),
                    const LatLng(-20.943752483078658, -47.81908327190443),
                  ],
                  color: const Color(0xFF7B61FF),
                  width: 6,
                ),
              },
              onMapCreated: (mapController) {
                mapController.showMarkerInfoWindow(const MarkerId("source"));

                //_controller.complete(mapController);
              },
            ),
    );
  }
}
