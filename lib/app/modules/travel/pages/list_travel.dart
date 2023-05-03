import 'dart:developer';

import 'package:ailog_app_carga_mobile/app/modules/travel/models/travel_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../travel_controller.dart';

class ListTravel extends StatelessWidget {
  const ListTravel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TravelController>();

    return Obx(
      () => controller.loadingTravels.isTrue
          ? SizedBox(
              height: context.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: context.theme.primaryColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Carregando viagens...',
                      style: TextStyle(
                        color: context.theme.primaryColor,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : controller.travels.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/not_found.jpg',
                      width: 250,
                      height: 250,
                    ),
                    Text(
                      'Nenhuma viagem encontrada',
                      style: TextStyle(
                        color: context.theme.primaryColor,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    var travels = controller.travels;
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                              color: context.theme.primaryColorLight,
                            ),
                            width: context.width,
                            height: 50,
                            //  color: context.theme.primaryColor,
                            child: const Center(
                              child: Text('VIAGEM 1', style: TextStyle(fontSize: 18.0)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text('Placa:', style: TextStyle(fontSize: 17)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    travels[index].plate.toString().toUpperCase(),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text(
                                    'Data da viagem:',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(travels[index].dateInitTravel!),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text('Valor total:', style: TextStyle(fontSize: 17)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    'R\$ ${travels[index].totalValue?.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text('Pedágios:', style: TextStyle(fontSize: 17)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    '${travels[index].tolls?.length ?? 0} QTD',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text(
                                    'Status:',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    travels[index].status,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Icon(Icons.location_on),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Text(
                                    'Pedágios',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 80),
                                  child: Icon(Icons.check, color: Colors.green),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final travelSelected = controller.travels[index];
                                    travelSelected.status = TravelStatus.finished.name.toLowerCase();
                                    controller.updateTravel(travelSelected);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(7.0),
                                    child: Text(
                                      'Finalizar viagem',
                                      style: TextStyle(fontSize: 18.0, color: Colors.green),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: controller.travels.length,
                ),
    );
  }
}
