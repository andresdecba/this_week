import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
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
  DateTime selectedDate;

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
    //notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
    tasksUseCases = TaskUseCasesImpl();
    localNotificationsUseCases = LocalNotificationsUseCases();
    selectedDateObs.value = selectedDate;
    createChipsList();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   selectedDateObs.value = selectedDate;
  // }

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
  /// atencion ! si se quiere iniciar desde un horario preestablecido, hacer el fix para q
  /// lo asigne al inicio por que si le cambio el currentIndex ahora tira un bug
  RxInt currentIndex = 0.obs;
  DateTime? notificationDateTime;

  List<String> listOfChips = [];
  List<Schedules> listOfSchedules = [];

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
    // siii ya séee, medio trucho pero no tenia más ganas de pensar :/
    listOfChips.add(Schedules.DISABLED.toStringValue);
    listOfSchedules.add(Schedules.DISABLED);

    if (selectedDate.isAtSameMomentAs(today)) {
      for (var e in Schedules.values) {
        if (timeOfDayIsAfterNow(e.toTimeOfDay)) {
          listOfChips.add(e.toStringValue);
          listOfSchedules.add(e);
        }
      }
    }
    // si la tarea es otro dia, mostrar todos los horarios
    if (!selectedDate.isAtSameMomentAs(today)) {
      listOfChips.addAll([
        Schedules.MORNING.toStringValue,
        Schedules.NOON.toStringValue,
        Schedules.AFTERNOON.toStringValue,
        Schedules.NIGHT.toStringValue,
      ]);
      listOfSchedules.addAll([
        Schedules.MORNING,
        Schedules.NOON,
        Schedules.AFTERNOON,
        Schedules.NIGHT,
      ]);
    }
    listOfChips.add(Schedules.PERSONALIZED.toStringValue);
    listOfSchedules.add(Schedules.PERSONALIZED);
  }

  void selectedNotificationDateTime(BuildContext context, index) async {
    switch (listOfSchedules[index]) {
      case Schedules.DISABLED:
        notificationDateTime = null;
        break;
      case Schedules.MORNING:
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
        break;
      case Schedules.NOON:
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12, 0);
        break;
      case Schedules.AFTERNOON:
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 17, 0);
        break;
      case Schedules.NIGHT:
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 21, 0);
        break;
      case Schedules.PERSONALIZED:
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

  // UPDATE DATE //

  Rx<DateTime> selectedDateObs = DateTime.now().obs;
  Future<void> updateDate(BuildContext context) async {
    // pick a date
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // dia seleccionado del calendario (no puede ser anterior al fisrtDate)
      firstDate: DateTime.now(), // primer dia habilitado del calendario (igual o anterior al initialDate)
      lastDate: DateTime(2050),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        selectedDate = value;
        selectedDateObs.value = value;
      }
    });
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

      Get.back();
      showSnackBar(
        titleText: 'new task created'.tr,
        messageText: textController.value.text,
      );
    }
  }
}
