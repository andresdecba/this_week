import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';

//////////////////////////////
/// PARSE DATE & TIME  ///
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

String timeOfDayToString(TimeOfDay time) {
  return '${time.hour}:${time.minute}';
}

//////////////////////////////
/// NOTIFICATIONS  ///
/////////////////////////////

int createNotificationId() {
  int value = Random().nextInt(999999999);
  return value;
}

//////////////////////////////
/// TIME -  DATE HELPERS  ///
/////////////////////////////
extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

bool timeOfDayIsAfterNow(TimeOfDay time) {
  TimeOfDay current = TimeOfDay.now();
  if (time.hour < current.hour) return false;
  if (time.hour == current.hour) if (time.minute < current.minute) return false;
  return true;
}

bool timeOfDayIsBeforeNow(TimeOfDay time) {
  TimeOfDay current = TimeOfDay.now();
  if (time.hour > current.hour) return false;
  if (time.hour == current.hour) if (time.minute > current.minute) return false;
  return true;
}

//////////////////////////////
/// TASK THINGS HELPERS ///
/////////////////////////////

bool isTaskToday(DateTime taskDate) {
  var now = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
    0,
    0,
  );
  return taskDate.isAtSameMomentAs(now);
}

bool isTaskExpired(DateTime taskDate) {
  var now = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
    0,
    0,
  );
  return taskDate.isBefore(now);
}

// TODO: CREAR STRING FUNC
void taskDateHumanRead() {
  // si estuvo en otro mes que no es el mes pasado: 'nombre del mes'
  // si estuvo el mes que pasado: 'el mes pasado'
  // si estuvo dentro del mes pero no es la pasada: 'este mes'
  // si estuvo en la semana pasada: 'la semana pasada'
  // si estuvo para dentro de esta semana que no es ayer: 'dia de la semana'
  // si estuvo para ayer: 'ayer'

  // SI ES PARA HOY: 'HOY'

  // si está para mañana: 'mañana'
  // si está dentro de esta semana que no es mañana: 'dia de la semana'
  // si está en la semana que viene: 'la semana que viene'
  // si esta dentro del mes pero no es la semana que viene: 'este mes'
  // si esta el mes que viene: 'el mes que viene'
  // si esta en otro mes que no es el mes que viene: 'nombre del mes'
}

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
