import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';

//////////////////////////////
/// DATE & TIME HELPERS ///
/////////////////////////////

/// Utils docs
/// https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
/// https://www.flutterbeads.com/format-datetime-in-flutter/
///
String longDateFormaterWithoutYear(DateTime date) {
  // sábado, 26/01
  return "${DateFormat('EEEE').format(date)} ${DateFormat.Md().format(date)}";
}

String longDateFormater(DateTime date) {
  // sábado, 26/01/2023
  return "${DateFormat('EEEE').format(date)}, ${DateFormat.yMd().format(date)}";
}

String standardDateFormater(DateTime date) {
  // 26/01/23
  return DateFormat.yMd().format(date);
}

String weekdayOnlyFormater(DateTime date) {
  // miércoles
  return DateFormat.EEEE().format(date);
}

String dayAndMonthFormater(DateTime date) {
  // 26/01
  return DateFormat.Md().format(date);
}

String timeFormater(DateTime date) {
  // 22:01
  return "${DateFormat.Hm().format(date)} ${'hr'.tr}";
}

int createNotificationId() {
  // las notificaciones aceptan un id de hasta 9 numeros
  // String value = DateTime.now().millisecondsSinceEpoch.toString();
  // int startValue = value.length - 9;
  // int trimmedId = int.parse(value.substring(startValue, value.length));
  // return trimmedId;
  int value = Random().nextInt(999999999);
  return value;
}

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

//////////////////////////////
/// TASK THINGS HELPERS ///
/////////////////////////////

String setStatusLanguage(TaskModel task) {
  switch (task.status) {
    case 'Pending':
      return 'pending'.tr;
    case 'In progress':
      return 'in progress'.tr;
    case 'Done':
      return 'done'.tr;
    default:
      return 'pending'.tr;
  }
}

Color setStatusColor(TaskModel task) {
  switch (task.status) {
    case 'Pending':
      return statusTaskPending;
    case 'In progress':
      return statusTaskInProgress;
    case 'Done':
      return statusTaskDone;
    default:
      return statusTaskPending;
  }
}

TextStyle setStatusTextStyle(TaskModel task) {
  switch (task.status) {
    case 'Pending':
      return kBodyMedium;
    case 'In progress':
      return kBodyMedium;
    case 'Done':
      return kBodyMedium.copyWith(fontStyle: FontStyle.italic, decoration: TextDecoration.lineThrough, color: disabledGrey);
    default:
      return kBodyMedium;
  }
}
