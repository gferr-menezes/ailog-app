import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/commom/application_bind.dart';
import 'app/commom/geolocation.dart';
import 'app/database/database_sqlite.dart';
import 'app/routes/home_routes.dart';
import 'app/commom/app_ui.dart';

void main() {
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
  ));
  //runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    DatabaseSQLite().openConnection();
    /** 
     * Geolocation
     */
    Geolocation.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ApplicationBind(),
      debugShowCheckedModeBanner: false,
      theme: AppUI.theme,
      title: 'Ailog APP Carga',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      getPages: [
        ...HomeRoutes.routes,
      ],
    );
  }
}
