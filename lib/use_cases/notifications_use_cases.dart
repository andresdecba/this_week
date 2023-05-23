import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:todoapp/use_cases/notifications_crud.dart';

abstract class NotificationsUseCases {
  void deleteNotificationUseCase({required Rx<TaskModel> task});
  void deleteNotificationWithTaskUseCase({required TaskModel task});
  void deleteAllNotificationsUseCase();
  void createUpdateNotificationUseCase({required Rx<TaskModel> task, required BuildContext context});
}

class NotificationsUseCasesImpl implements NotificationsUseCases {
  // plugin
  final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

  @override
  void deleteNotificationUseCase({required Rx<TaskModel> task}) async {
    // validar rule: si tiene y si no está vencida
    if (task.value.notificationData != null && task.value.notificationData!.time.isAfter(DateTime.now())) {
      NotificationsCrud.deleteNotification(task: task, fln: fln);
    } else {
      return;
    }
  }

  @override
  Future<void> deleteAllNotificationsUseCase() {
    throw UnimplementedError();
  }

  @override
  void createUpdateNotificationUseCase({required Rx<TaskModel> task, required BuildContext context}) async {
    //
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );

    if (newTime == null) {
      return;
    } else {
      var notificationDateTime = DateTime(
        task.value.taskDate.year,
        task.value.taskDate.day,
        task.value.taskDate.month,
        newTime.hour,
        newTime.minute,
      );
      // validar rule
      if (notificationDateTime.isBefore(DateTime.now())) {
        // si es anterior a ahora mostrar modal
        // ignore: use_build_context_synchronously
        myCustomDialog(
          context: context,
          title: 'atention !'.tr,
          subtitle: 'You cant create a...'.tr,
          okTextButton: 'ok'.tr,
          iconPath: 'assets/info.svg',
          iconColor: bluePrimary,
          onPressOk: () => Navigator.of(context).pop(),
        );
      } else {
        // llamar a crear
        NotificationsCrud.createUpdateNotification(
          datetime: notificationDateTime,
          task: task,
          fln: fln,
        );
      }
    }
  }
  
  @override
  void deleteNotificationWithTaskUseCase({required TaskModel task}) {
    // validar rule: si tiene y si no está vencida
    if (task.notificationData != null && task.notificationData!.time.isAfter(DateTime.now())) {
      NotificationsCrud.deleteNotificationWithTask(task: task, fln: fln);
    } else {
      return;
    }
  }
}
