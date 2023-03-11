import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utils docs
/// https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
/// https://www.flutterbeads.com/format-datetime-in-flutter/

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
  return DateFormat.Hm().format(date);
}

int createNotificationId() {
  // las notificaciones aceptan un id de hasta 9 numeros
  String number = DateTime.now().millisecondsSinceEpoch.toString();
  int startValue = number.length - 9;
  int trimmedId = int.parse(number.substring(startValue, number.length));
  return trimmedId;
}

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}