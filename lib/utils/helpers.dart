import 'dart:math';
import 'package:isoweek/isoweek.dart';
import 'package:quiver/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/shared_components/create_task_bottomsheet.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';

//////////////////////////////
/// PARSE DATE & TIME  ///
/////////////////////////////

/// Utils docs
/// https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
/// https://www.flutterbeads.com/format-datetime-in-flutter/
///

String rangeDateFormater(DateTime firstDate, DateTime lastDate) {
  // 12 jun. al 18 jun.
  return "${DateFormat('MMMd').format(firstDate)} ${'to'.tr} ${DateFormat('MMMd').format(lastDate)}";
}

String monthNameFormater(DateTime date) {
  // junio
  return DateFormat('MMMM').format(date);
}

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

void openAnyTask(String id) {
  Rx<TaskModel> task = Globals.tasksGlobal.firstWhere((element) => element.value.id == id);
  Get.put(ViewTaskController(task: task));
  createTaskBottomSheet(
    context: Get.context!,
    child: ViewTask(tasks: Globals.tasksGlobal),
  );
  Globals.closedAppPayload = null;
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
///    UI HELPERS     ///
/////////////////////////////

Color randomPrimaryColorsGeneratorHelper() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

Color computeLuminanceHelper(Color color) {
  return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
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

String weekToHumanRead(Week value) {
  Week week = Week.current();

  // semanas
  if (value == week.next) {
    return 'next week'.tr;
  }

  if (value == week) {
    return 'this week'.tr;
  }

  if (value == week.previous) {
    return 'last week'.tr;
  }

  // meses
  if (value.days.first.month == value.days.last.month) {
    return monthNameFormater(value.days.first);
  }

  if (value.days.first.month != value.days.last.month) {
    var endMonth = monthNameFormater(value.days.first);
    var initMonth = monthNameFormater(value.days.last);
    return '$endMonth - $initMonth';
  }

  return '';
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

Icon setStatusIcon(TaskModel task, bool isToday) {
  if (!isToday) {
    switch (task.status) {
      case 'Pending':
        return const Icon(
          Icons.circle_outlined,
          color: statusTaskDone,
        );
      case 'In progress':
        return const Icon(
          Icons.circle_rounded,
          color: statusTaskInProgress,
        );
      case 'Done':
        return const Icon(
          Icons.circle_rounded,
          color: statusTaskDone,
        );
      default:
        return const Icon(
          Icons.circle_outlined,
          color: statusTaskDone,
        );
    }
  } else {
    switch (task.status) {
      case 'Pending':
        return Icon(
          Icons.circle_outlined,
          color: whiteBg.withOpacity(0.5),
        );
      case 'In progress':
        return const Icon(
          Icons.circle_rounded,
          color: statusTaskInProgress,
        );
      case 'Done':
        return Icon(
          Icons.circle_rounded,
          color: whiteBg.withOpacity(0.5),
        );
      default:
        return const Icon(
          Icons.circle_outlined,
          color: statusTaskDone,
        );
    }
  }
}

TextStyle setStatusTextStyle(TaskModel task, bool isToday) {
  if (!isToday) {
    switch (task.status) {
      case 'Pending':
        return kBodyLarge;
      case 'In progress':
        return kBodyLarge;
      case 'Done':
        return kBodyLarge.copyWith(decoration: TextDecoration.lineThrough, color: disabledGrey);
      default:
        return kBodyLarge;
    }
  } else {
    switch (task.status) {
      case 'Pending':
        return kBodyLarge.copyWith(color: whiteBg);
      case 'In progress':
        return kBodyLarge.copyWith(color: whiteBg);
      case 'Done':
        return kBodyLarge.copyWith(decoration: TextDecoration.lineThrough, color: whiteBg.withOpacity(0.5));
      default:
        return kBodyLarge;
    }
  }
}
