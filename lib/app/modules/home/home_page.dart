import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_custom_app_bar.dart';
import './home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomAppBar(),
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: controller.tabIndex,
            onTap: (value) {
              controller.tabIndex = value;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Lat-Long',
              ),
            ],
          );
        },
      ),
      body: Navigator(
        initialRoute: '/travel',
        key: Get.nestedKey(HomeController.NAVIGATOR_KEY),
        onGenerateRoute: controller.onGenerateRouter,
      ),
    );
  }
}
