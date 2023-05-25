import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/snackbar.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';
import 'package:todoapp/use_cases/tasks_use_cases.dart';

enum Schedules {
  DISABLED,
  MORNING,
  NOON,
  AFTERNOON,
  NIGHT,
  PERSONALIZED,
}

extension SchedulesExtension on Schedules {
  String get toValue {
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
        return 'night 9:00 p.m.'.tr;
    }
  }
}

class CreateTaskPageController extends GetxController {

  final TasksUseCases tasksUseCases;
  final NotificationsUseCases notificationsUseCases;

  CreateTaskPageController({
    required this.tasksUseCases,
    required this.notificationsUseCases,
  });

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    focusNode = FocusNode();
    formStateKey = GlobalKey<FormState>();
    textController.addListener(() {
      counter.value = textController.text.length;
    });
  }

  @override
  void onClose() {
    super.onClose();
    textController.dispose();
    focusNode.dispose();
  }

  // RUTINA //
  RxBool isRoutine = false.obs;

  // TEXTFORMFIELD //
  late GlobalKey<FormState> formStateKey;
  late TextEditingController textController;
  late FocusNode focusNode;
  RxInt counter = 0.obs;

  // SELECT NOTIFICATION //
  RxInt currentIndex = 1.obs;
  DateTime? notificationDateTime;
  late DateTime selectedDate;
  List<String> listOfChipNames = [
    Schedules.DISABLED.toValue,
    Schedules.MORNING.toValue,
    Schedules.NOON.toValue,
    Schedules.AFTERNOON.toValue,
    Schedules.NIGHT.toValue,
    Schedules.PERSONALIZED.toValue,
  ];

  void selectedNotificationDateTime(BuildContext context, index) async {
    switch (listOfChipNames[index]) {
      case 'Desactivado':
        notificationDateTime = null;
        break;
      case 'Mañana 09 hs.':
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
        break;
      case 'Mediodia 12 hs.':
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12, 0);
        break;
      case 'Tarde 17 hs.':
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 17, 0);
        break;
      case 'Noche 21 hs.':
        notificationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 21, 0);
        break;
      case 'Personalizado':
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

  // VALIDATE FORM //
  //  void validateForm(BuildContext context) {

  //   var isFormValid = formStateKey.currentState!.validate();
  //   // if (isFormValid) {
  //   //   _task.value.notificationTime != null ? validateNotification(context) : confirmAndNavigate();
  //   // }
  // }

  // CLOSE BOTTOMSHEET X //
  void closeAndRestoreValues() {
    textController.clear();
    isRoutine.value = false;
    notificationDateTime = null;
    currentIndex.value = 1;
    Get.back();
  }

  // SAVE-CREATE TASK //
  void saveTask() async {
    if (formStateKey.currentState!.validate()) {
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
      closeAndRestoreValues();
      Get.find<InitialPageController>().tasksMap.refresh();
      Get.find<InitialPageController>().buildInfo();
      Get.back();
    }
  }
}
