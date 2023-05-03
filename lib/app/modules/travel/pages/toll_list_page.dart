import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TollListPage extends StatelessWidget {
  final double percent;

  const TollListPage({Key? key, required this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: context.height * percent,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Ordem de passagem $index'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Text('Valor: R\$ 10,00'),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Text('Data passagem: 01/01/2021'),
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
                    const Text('Nome do pedágio aqui'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
