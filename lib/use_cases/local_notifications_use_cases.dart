import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/repository/local_notifications_repository/local_notification_repository.dart';
// import 'package:todoapp/ui/commons/styles.dart';
// import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:todoapp/data_source/local_notifications_data_source/local_notifications_data_source.dart';

class LocalNotificationsUseCases {
  // instance
  final LocalNotificationRepository _localNotificationRepository = LocalNotificationRepositoryImpl();

  Future<bool> createNotification({
    required Rx<TaskModel> task,
    required TimeOfDay newTime,
  }) async {
    //
    // si ya tiene una notificacion borrarla (modo update)
    if (task.value.notificationData != null) {
      await _localNotificationRepository.deleteNotification(notificationId: task.value.notificationData!.id!);
    }

    // crear datetime
    var selectedDateTime = DateTime(
      task.value.taskDate.year,
      task.value.taskDate.month,
      task.value.taskDate.day,
      newTime.hour,
      newTime.minute,
    );

    task.value.notificationData = await LocalNotificationsDataSource.createNotification(
      datetime: selectedDateTime,
      title: task.value.description,
      payload: task.value.key.toString(),
    );

    task.value.save();
    task.refresh();
    return true;

    // validar rule: si es anterior a ahora mostrar modal
    // if (selectedDateTime.isBefore(DateTime.now())) {
    //   myCustomDialog(
    //     context: Get.context!,
    //     title: 'atention !'.tr,
    //     subtitle: 'You cant create a...'.tr,
    //     okTextButton: 'ok'.tr,
    //     iconPath: 'assets/info.svg',
    //     iconColor: bluePrimary,
    //     onPressOk: () => Get.back(),
    //   );
    //   return false;
    // } else {
    //   // crear notificacion
    //   task.value.notificationData = await LocalNotificationsDataSource.createNotification(
    //     datetime: selectedDateTime,
    //     title: task.value.description,
    //     payload: task.value.key.toString(),
    //   );
    //   task.value.save();
    //   task.refresh();
    // }

    // crear notificacion
  }

  Future<bool> deleteNotification({required Rx<TaskModel> task}) async {
    // si tiene notificación  y si no está vencida
    if (task.value.notificationData != null && task.value.notificationData!.time.isAfter(DateTime.now())) {
      await _localNotificationRepository.deleteNotification(notificationId: task.value.notificationData!.id!);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteAllNotifications() async {
    await _localNotificationRepository.deleteAllNotification();
    return true;
  }
}

// abstract class LocalNotificationsUseCases {
//   void deleteNotificationUseCase({required Rx<TaskModel> task});
//   void deleteNotificationWithTaskUseCase({required TaskModel task});

//   void deleteAllNotificationsUseCase();
//   Future<bool> createUpdateNotificationUseCase({required Rx<TaskModel> task, required TimeOfDay newTime});
// }


/*
class NotificationsUseCasesImpl {
  // plugin
  final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

  void deleteNotificationUseCase({required Rx<TaskModel> task}) async {
    // validar rule: si tiene y si no está vencida
    if (task.value.notificationData != null && task.value.notificationData!.time.isAfter(DateTime.now())) {
      LocalNotificationsDataSource.deleteNotification(notificationId: task.value.notificationData!.id!);
    } else {
      return;
    }
  }

  Future<void> deleteAllNotificationsUseCase() {
    throw UnimplementedError();
  }

  Future<bool> createUpdateNotificationUseCase({required Rx<TaskModel> task, required TimeOfDay newTime}) async {
    //
    // si ya tiene una notificacion borrarla (modo update)
    if (task.value.notificationData != null) {
      await LocalNotificationsDataSource.deleteNotification(notificationId: task.value.notificationData!.id!);
    }

    // crear datetime
    var selectedDateTime = DateTime(
      task.value.taskDate.year,
      task.value.taskDate.month,
      task.value.taskDate.day,
      newTime.hour,
      newTime.minute,
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
      return false;
    } else {
      // crear notificacion
      task.value.notificationData = await LocalNotificationsDataSource.createNotification(
        datetime: selectedDateTime,
        title: task.value.description,
        payload: task.value.key.toString(),
      );
      task.value.save();
      task.refresh();
    }
    return true;
  }

  // @override
  // void createUpdateNotificationUseCase({required Rx<TaskModel> task, required BuildContext context}) async {
  //   //
  //   // abrir time picker
  //   TimeOfDay? newTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
  //   );

  //   if (newTime == null) {
  //     return;
  //   } else {
  //     var selectedDateTime = DateTime(
  //       task.value.taskDate.year,
  //       task.value.taskDate.day,
  //       task.value.taskDate.month,
  //       newTime.hour,
  //       newTime.minute,
  //     );
  //     // validar rule
  //     if (selectedDateTime.isBefore(DateTime.now())) {
  //       // si es anterior a ahora mostrar modal
  //       // ignore: use_build_context_synchronously
  //       myCustomDialog(
  //         context: context,
  //         title: 'atention !'.tr,
  //         subtitle: 'You cant create a...'.tr,
  //         okTextButton: 'ok'.tr,
  //         iconPath: 'assets/info.svg',
  //         iconColor: bluePrimary,
  //         onPressOk: () => Navigator.of(context).pop(),
  //       );
  //     } else {
  //       // llamar a crear
  //       NotificationsCrud.createUpdateNotification(
  //         datetime: selectedDateTime,
  //         task: task,
  //         fln: fln,
  //       );
  //     }
  //   }
  // }

  // void deleteNotificationWithTaskUseCase({required TaskModel task}) {
  //   // validar rule: si tiene y si no está vencida
  //   if (task.notificationData != null && task.notificationData!.time.isAfter(DateTime.now())) {
  //     LocalNotificationsDataSource.deleteNotificationWithTask(task: task, fln: fln);
  //   } else {
  //     return;
  //   }
  // }
}


*/