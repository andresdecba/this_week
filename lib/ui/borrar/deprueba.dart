import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/routes/routes.dart';

class Deprueba extends GetView<Depruebacontroller> {
  const Deprueba({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.offAllNamed(Routes.INITIAL_PAGE),
      ),
      body: Obx(
        () => Center(
          child: Text(
            'DE PRUEBA ${controller.args} ',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class Depruebacontroller extends GetxController {
  RxString args = ''.obs;

  @override
  void onInit() {
    print('de prueba ${Get.arguments['taskId']!}');

    args.value = Get.arguments['taskId']!;
    super.onInit();
  }
}
