import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/repository/local_notifications_repository/local_notification_repository.dart';
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
      task.value.date.year,
      task.value.date.month,
      task.value.date.day,
      newTime.hour,
      newTime.minute,
    );

    task.value.notificationData = await LocalNotificationsDataSource.createNotification(
      datetime: selectedDateTime,
      title: task.value.description,
      payload: task.value.id,
    );

    task.value.save();
    task.refresh();
    return true;
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
