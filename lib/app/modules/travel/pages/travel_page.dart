import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

import '../../../commom/geolocation.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_form_field.dart';
import '../travel_controller.dart';
import '../widgets/list_travel.dart';
import '../widgets/toll_list_page.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    /**
     * check connection
     */
    (Connectivity().checkConnectivity()).then((value) {
      if (value.name != 'none') {
        controller.appIsOnline = true;
      } else {
        controller.appIsOnline = false;
      }
    });

    /**
     * listener connection
     */
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result.name != 'none') {
        controller.appIsOnline = true;
      } else {
        controller.appIsOnline = false;
      }
    });

    /**
     * check travel is started
     */
    controller.getTravels();
    WidgetsBinding.instance.addObserver(this);
    controller.sendLocation();

    /**
     * init send position
     */
    Timer.periodic(const Duration(minutes: 3), (timer) {
      controller.sendLocation();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _positionStreamSubscription?.cancel();
    } else if (state == AppLifecycleState.paused) {
      _positionStreamSubscription = await Geolocation.callPositionStream();
    }
  }

  late StreamSubscription<ConnectivityResult> subscription;
  var controller = Get.find<TravelController>();
  final formKey = GlobalKey<FormState>();
  final plateEC = TextEditingController();
  StreamSubscription<Position>? _positionStreamSubscription;

  int? selectedTravel;

  @override
  Widget build(BuildContext context) {
    // plateEC.text = 'DOO-8946';

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
                                                                          var travel = travels[index];
                                                                          var dateInitTravel = travel.dateInitTravel;
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
                                                                            title: Column(
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(dateInitTravel!)}',
                                                                                ),
                                                                                const Padding(
                                                                                  padding: EdgeInsets.only(top: 5),
                                                                                ),
                                                                                Text(
                                                                                  'Origem: ${cityOrigin.toUpperCase()}',
                                                                                ),
                                                                              ],
                                                                            ),
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
              const SizedBox(
                height: 300,
                child: ListTravel(),
              ),
              Obx(
                () => controller.travels.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        height: context.height * 0.67,
                        child: const TollListPage(percent: 0.33),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
