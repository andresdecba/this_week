import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';

Future<TimeOfDay?> myTimePicker(BuildContext context, DateTime taskDate) async {
  TimeOfDay? value = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
  );

  if (value == null) {
    return null;
  } else {
    var selectedDateTime = DateTime(
      taskDate.year,
      taskDate.month,
      taskDate.day,
      value.hour,
      value.minute,
    );

    // validar rule: si es anterior a ahora mostrar modal
    if (selectedDateTime.isBefore(DateTime.now())) {
      myCustomDialog(
        context: Get.context!,
        title: 'atention !'.tr,
        subtitle: 'You cant create a...'.tr,
        okTextButton: 'ok'.tr,
        iconPath: 'assets/info.svg',
        iconColor: bluePrimary,
        onPressOk: () => Get.back(),
      );
      return null;
    }
    return value;
  }
}
