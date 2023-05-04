import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../travel_controller.dart';

class TollListPage extends StatelessWidget {
  final double percent;
  const TollListPage({Key? key, required this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TravelController>();

    var travelData = controller.travels;
    final tolls = travelData.first.tolls ?? [];

    return Obx(
      () => travelData.isEmpty
          ? const SizedBox()
          : SizedBox(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: context.height * percent,
                  child: ListView.builder(
                    itemCount: tolls.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        child: SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Ordem de passagem: ${tolls[index].passingOrder}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                    tolls[index].value != null
                                        ? Text('Valor: R\$ ${tolls[index].value}')
                                        : const Text('Valor: R\$ 0,00'),
                                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                    Text(
                                      'Data passagem:  ${tolls[index].passingDateTime != null ? DateFormat('dd/MM/yyyy HH:mm').format(tolls[index].passingDateTime as DateTime) : ' - '}',
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.info),
                                ),
                                dense: true,
                              ),
                              const Divider(),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                              Text(tolls[index].tollName.toString().toUpperCase()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
