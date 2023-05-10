import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:todoapp/models/notification_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:timezone/timezone.dart' as tz;

abstract class NotificationsUseCases {
  Future<void> createNotificationScheduledUseCase({required NotificationModel notification});
  Future<void> deleteNotificationUseCase({required NotificationModel notification});
  Future<void> updateNotificationUseCase({required NotificationModel notification});
}


class NotificationsUseCasesImpl implements NotificationsUseCases {
  // plugin
  final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

  //// CREATE A SCHEDULED notification ////
  @override
  Future<void> createNotificationScheduledUseCase({required NotificationModel notification}) async {
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
      notification.id,
      notification.title, // titulo
      notification.body, //'task reminder'.tr, // body
      tz.TZDateTime.from(notification.time, tz.local),
      notificationDetails,
      payload: notification.payload, // payload
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  //// DELETE a notification ////
  @override
  Future<void> deleteNotificationUseCase({required NotificationModel notification}) async {
    await fln.cancel(notification.id);
  }

  //// UPDATE a notification ////
  @override
  Future<void> updateNotificationUseCase({required NotificationModel notification}) async {}
}
