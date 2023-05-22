import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:todoapp/models/notification_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/utils/helpers.dart';

abstract class NotificationsUseCases {
  Future<void> createNotificationScheduledUseCase({required NotificationModel notification, required TaskModel task});
  Future<void> deleteNotificationUseCase({required NotificationModel notification, required TaskModel task});
  Future<void> updateNotificationUseCase({required NotificationModel notification, required TaskModel task});
  Future<void> disableNotificationUseCase({required NotificationModel notification, required TaskModel task});
}

class NotificationsUseCasesImpl implements NotificationsUseCases {
  // plugin
  final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

  //// CREATE A SCHEDULED notification ////
  @override
  Future<void> createNotificationScheduledUseCase({required NotificationModel notification, required TaskModel task}) async {
    final _notification = NotificationModel(
      id: createNotificationId(),
      body: 'task reminder'.tr,
      title: notification.title,
      time: notification.time,
      payload: notification.payload,
    );

    // crear notificacion
    final notificationDetails = NotificationDetails(
      iOS: const DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        'my_channel_id',
        'my_channel_name',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'notificationPostponeACTION', //action id
            'postpone'.tr, //action title
            titleColor: bluePrimary,
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ],
      ),
    );

    // programar lanzamiento
    await fln.zonedSchedule(
      _notification.id!, // id
      _notification.title, // titulo
      _notification.body!, // body
      tz.TZDateTime.from(_notification.time, tz.local), // time
      notificationDetails,
      payload: _notification.payload, // payload
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );

    task.notificationData = _notification;
    print('hola $_notification');
  }

  //// DELETE a notification ////
  @override
  Future<void> deleteNotificationUseCase({required NotificationModel notification, required TaskModel task}) async {
    await fln.cancel(notification.id!);
  }

  //// UPDATE a notification ////
  @override
  Future<void> updateNotificationUseCase({required NotificationModel notification, required TaskModel task}) async {}

  //// DISABLE a notification ////
  @override
  Future<void> disableNotificationUseCase({required NotificationModel notification, required TaskModel task}) async {}
}
