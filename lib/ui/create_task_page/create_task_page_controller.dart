import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/snackbar.dart';
import 'package:todoapp/use_cases/local_notifications_use_cases.dart';
import 'package:todoapp/use_cases/tasks_use_cases.dart';
import 'package:todoapp/utils/helpers.dart';
//import 'package:todoapp/utils/helpers.dart';

enum Schedules {
  DISABLED,
  MORNING,
  NOON,
  AFTERNOON,
  NIGHT,
  PERSONALIZED,
}

extension SchedulesToString on Schedules {
  String get toStringValue {
    switch (this) {
      case Schedules.DISABLED:
        return 'disabled'.tr;
      case Schedules.MORNING:
        return 'morning 9 a.m.'.tr;
      case Schedules.NOON:
        return 'noon 12 p.m.'.tr;
      case Schedules.AFTERNOON:
        return 'afternoon 5:00 p.m.'.tr;
      case Schedules.NIGHT:
        return 'night 9:00 p.m.'.tr;
      case Schedules.PERSONALIZED:
        return 'personalized'.tr;
    }
  }
}

extension SchedulesToTimeOfDay on Schedules {
  TimeOfDay get toTimeOfDay {
    switch (this) {
      case Schedules.DISABLED:
        return const TimeOfDay(hour: 0, minute: 0);
      case Schedules.MORNING:
        return const TimeOfDay(hour: 9, minute: 0);
      case Schedules.NOON:
        return const TimeOfDay(hour: 12, minute: 0);
      case Schedules.AFTERNOON:
        return const TimeOfDay(hour: 17, minute: 0);
      case Schedules.NIGHT:
        return const TimeOfDay(hour: 21, minute: 0);
      case Schedules.PERSONALIZED:
        return const TimeOfDay(hour: 0, minute: 0);
    }
  }
}

class CreateTaskPageController extends GetxController {
  final DateTime selectedDate;

  CreateTaskPageController({
    // required this.tasksUseCases,
    // required this.localNotificationsUseCases,
    required this.selectedDate,
  });

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    focusNode = FocusNode();
    textController.addListener(() {
      counter.value = textController.text.length;
    });
    notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
    tasksUseCases = TaskUseCasesImpl();
    localNotificationsUseCases = LocalNotificationsUseCases();
    createChipsList();
  }

  @override
  void onClose() {
    super.onClose();
    textController.dispose();
    focusNode.dispose();
  }

  // TASK DATE //
  //late DateTime selectedDate;
  late TasksUseCases tasksUseCases;
  late LocalNotificationsUseCases localNotificationsUseCases;

  // RUTINA //
  RxBool isRoutine = false.obs;

  // TEXTFORMFIELD //
  late TextEditingController textController;
  late FocusNode focusNode;
  RxInt counter = 0.obs;

  // SELECT NOTIFICATION //
  RxInt currentIndex = 1.obs;
  late DateTime? notificationDateTime;

  List<String> listOfChips = [];

  void createChipsList() {
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      0,
      0,
      0,
      0,
      0,
    );

    // si la tarea es para hoy, restringir los horarios
    if (selectedDate.isAtSameMomentAs(today)) {

      for (var e in Schedules.values) {
        if (e.toStringValue == Schedules.DISABLED.toStringValue || e.toStringValue == Schedules.PERSONALIZED.toStringValue) {
          listOfChips.add(e.toStringValue);
        }
        if (timeOfDayIsAfterNow(e.toTimeOfDay)) {
          listOfChips.add(e.toStringValue);
        }
      }
    }

    // si la tarea es otro dia, mostrar todos los horarios
    if (!selectedDate.isAtSameMomentAs(today)) {
      listOfChips = [
        Schedules.DISABLED.toStringValue,
        Schedules.MORNING.toStringValue,
        Schedules.NOON.toStringValue,
        Schedules.AFTERNOON.toStringValue,
        Schedules.NIGHT.toStringValue,
        Schedules.PERSONALIZED.toStringValue,
      ];
    }
  }

  void selectedNotificationDateTime(BuildContext context, index) async {
    switch (listOfChips.indexOf(listOfChips[index])) {
      case 0:
        notificationDateTime = null;
        break;
      case 1:
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
        break;
      case 2:
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12, 0);
        break;
      case 3:
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 17, 0);
        break;
      case 4:
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 21, 0);
        break;
      case 5:
        {
          TimeOfDay? newTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
          );
          if (newTime == null) {
            break;
          } else {
            notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, newTime.hour, newTime.minute);
            break;
          }
        }
    }
  }

  // CLOSE BOTTOMSHEET X //
  // TODO: ver alguna forma mejor de no tener que llamar este metodo por todos lados para resetear las propiedades
  // TODO: hacer algo mejor para pasar el selectedDate a este controller
  void closeAndRestoreValues() {
    textController.clear();
    isRoutine.value = false;
    notificationDateTime = null;
    currentIndex.value = 1;
    listOfChips = [];
    Get.back();
  }

  // SAVE-CREATE TASK //
  void saveTask() async {
    if (Globals.formStateKey.currentState!.validate()) {
      await tasksUseCases.createTaskUseCase(
        description: textController.value.text,
        date: selectedDate,
        isRoutine: isRoutine.value,
        notificationDateTime: notificationDateTime,
      );
      showSnackBar(
        titleText: 'new task created'.tr,
        messageText: textController.value.text,
      );
      Get.find<InitialPageController>().tasksMap.refresh();
      Get.find<InitialPageController>().buildInfo();
      closeAndRestoreValues();
    }
  }
}
