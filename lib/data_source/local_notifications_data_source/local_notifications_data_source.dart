import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoapp/models/notification_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/utils/helpers.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

class LocalNotificationsDataSource {
  //// CREATE - UPDATE ////

  static Future<NotificationModel> createNotification({
    required DateTime datetime,
    required String title,
    required String payload,
    String? body,
  }) async {
    //
    // declarar
    final notification = NotificationModel(
      id: createNotificationId(),
      body: body ?? 'task reminder'.tr,
      title: title,
      time: datetime,
      payload: payload, // es el key de la task (task.value.key.toString(),)
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
    await _fln.zonedSchedule(
      notification.id!, // id
      notification.title, // titulo
      notification.body!, // body
      tz.TZDateTime.from(notification.time, tz.local), // time
      notificationDetails,
      payload: notification.payload, // payload
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );

    // retornar
    return notification;
  }

  //// DELETE ////
  static Future<void> deleteNotification({required int notificationId}) async {
    try {
      await _fln.cancel(notificationId);
    } catch (e) {
      print('Holaaa no se pudo delete');
    }
  }

  // se usa para establecer toda la app
  static Future<void> deleteAllNotifications() async {
    try {
      await _fln.cancelAll();
    } catch (e) {
      print('Holaaa no se pudo delete all');
    }
  }
}
