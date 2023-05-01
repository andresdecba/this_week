import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/services/local_notifications_service.dart';
import 'package:todoapp/utils/helpers.dart';

class PostPosePageController extends GetxController {
  @override
  void onInit() {
    setInitialConfig();
    super.onInit();
  }

  //// manage HIVE //////
  final tasksBox = Boxes.getTasksBox();
  late Task task;
  // traer la tarea
  void setInitialConfig() {
    // argumentos desde la notificacion
    if (notificationPayload != null) {
      task = tasksBox.get(int.parse(notificationPayload!['taskId']!))!;
      return;
    }
    // argumentos desde la pagina de inicio al abrir una tarea existnte
    if (Get.arguments['taskId'] != null) {
      task = tasksBox.get(int.parse(Get.arguments['taskId']!))!;
      return;
    }
  }

  //// mange times postpose /////
  List<Duration> durations = [
    const Duration(minutes: 15),
    const Duration(hours: 1),
    const Duration(hours: 3),
    const Duration(days: 1),
    const Duration(days: 2),
  ];

  Rx<Duration> selectedDuration = const Duration(minutes: 15).obs;

  // posponer notificacion
  // TODO si pasa para el otro dia, que hacer ?

  void changeTaskDateAndNotificationDate(DateTime dt) {}

  postposeNotification(DateTime datetime) {
    task.notificationTime = datetime;
    task.save();
    _createNotificationREFACTORIZED(task: task);
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  Future<void> _createNotificationREFACTORIZED({required Task task}) async {
    await LocalNotificationService.createNotificationScheduled(
      time: task.notificationTime!,
      id: createNotificationId(),
      body: task.description,
      payload: task.key.toString(),
      fln: localNotifications,
    );
  }

  Future<void> datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: task.taskDate,
      //firstDate: DateTime.now().subtract(Duration(days: 4)),
      firstDate: task.taskDate,
      lastDate: DateTime(2101),
    );
    if (picked == null) {
      //on cancel action
      return;
    } else {
      // controller.taskDate.value = picked;
      // controller.saveNewDate();
    }
  }

  Future<void> timePicker(BuildContext context) async {
    FocusScope.of(context).unfocus(); // hide keyboard if open
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().add(const Duration(minutes: 5)).minute),
    );
    if (newTime == null) {
      return;
    } else {
      //controller.setNotificationTime = newTime;
    }
    // controller.enableDisableNotificationStyles();
    // controller.setNotificationValues();
  }
}
