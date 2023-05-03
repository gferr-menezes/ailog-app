import 'package:ailog_app_carga_mobile/app/modules/travel/pages/list_travel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_form_field.dart';
import '../travel_controller.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  @override
  void initState() {
    super.initState();

    /**
     * check travel is started
     */
    controller.getTravels();
  }

  var controller = Get.find<TravelController>();
  final formKey = GlobalKey<FormState>();
  final plateEC = TextEditingController();

  int? selectedTravel;

  @override
  Widget build(BuildContext context) {
    plateEC.text = 'DOO-8946';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextFormField(
                        label: 'Informe a placa',
                        controller: plateEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('Informe a placa'),
                          Validatorless.min(7, 'Placa inválida'),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => AppButton(
                          label: controller.travelInProgress ? 'Viagem em andamento' : 'Iniciar viagem',
                          loading: controller.startingTravel.value,
                          onPressed: controller.travelInProgress
                              ? null
                              : controller.startingTravel.value
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        controller.startTravel(plateEC.text).then(
                                          (value) {
                                            if (controller.travelsForSelectedForStart.length > 1) {
                                              var travels = controller.travelsForSelectedForStart.toList();

                                              showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return Obx(
                                                        () => controller.loadingStartingTravel.isTrue
                                                            ? Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  CircularProgressIndicator(
                                                                    color: context.theme.primaryColor,
                                                                  ),
                                                                  const Padding(padding: EdgeInsets.only(top: 10)),
                                                                  const Text('por favor, aguarde...'),
                                                                ],
                                                              )
                                                            : Container(
                                                                padding: const EdgeInsets.all(5),
                                                                height: 400,
                                                                color: Colors.white,
                                                                child: Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      'Selecione uma viagem para iniciar',
                                                                      style: context.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: context.theme.primaryColorDark,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child: ListView.builder(
                                                                        itemCount: travels.length,
                                                                        itemBuilder: (context, index) {
                                                                          String cityOrigin =
                                                                              travels[index].addresses?[0].city ?? '';
                                                                          String cityDestiny = travels[index]
                                                                                  .addresses?[
                                                                                      travels[index].addresses!.length -
                                                                                          1]
                                                                                  .city ??
                                                                              '';

                                                                          return RadioListTile(
                                                                            value: travels[index].travelIdAPI,
                                                                            groupValue: selectedTravel,
                                                                            title: Text(
                                                                                'Origem: ${cityOrigin.toUpperCase()}'),
                                                                            subtitle: Text(
                                                                                'Destino: ${cityDestiny.toUpperCase()}'),
                                                                            onChanged: (val) {
                                                                              setState(() {
                                                                                selectedTravel = val;
                                                                              });
                                                                            },
                                                                            activeColor: Colors.green,
                                                                            selected: false,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    AppButton(
                                                                      label: 'Selecionar',
                                                                      onPressed: () {
                                                                        controller
                                                                            .startTravel(plateEC.text,
                                                                                idTravelSelected: selectedTravel)
                                                                            .then((value) => {Navigator.pop(context)});
                                                                      },
                                                                      width: context.width,
                                                                      height: 40,
                                                                    ),
                                                                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                                                                  ],
                                                                ),
                                                              ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                          width: context.width,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // const Padding(
              //   padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              //   child: TollListPage(percent: 0.62),
              // )
              SizedBox(
                height: context.height * 0.67,
                child: const ListTravel(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
