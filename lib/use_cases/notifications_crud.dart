import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoapp/models/notification_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/utils/helpers.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

class NotificationsCrud {
  // como instanciar al plugin
  //final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

  //// CREATE - UPDATE ////
  static Future<void> createUpdateNotification({
    required DateTime datetime,
    required Rx<TaskModel> task,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    //
    // si ya tiene una notificacion borrarla (modo update)
    if (task.value.notificationData != null) {
      await deleteNotification(task: task, fln: fln);
    }

    final notificationTmp = NotificationModel(
      id: createNotificationId(),
      body: 'task reminder'.tr,
      title: task.value.description,
      time: datetime,
      payload: task.value.key.toString(),
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
      notificationTmp.id!, // id
      notificationTmp.title, // titulo
      notificationTmp.body!, // body
      tz.TZDateTime.from(notificationTmp.time, tz.local), // time
      notificationDetails,
      payload: notificationTmp.payload, // payload
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );

    // agregar notificacion a la tarea
    task.value.notificationData = notificationTmp;
    task.value.save();
    task.refresh();
  }

  //// DELETE ////
  static Future<void> deleteNotification({
    required Rx<TaskModel> task,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    await fln.cancel(task.value.notificationData!.id!);
    task.value.notificationData = null;
    task.value.save();
    task.refresh();
  }

  static Future<void> deleteNotificationWithTask({
    required TaskModel task,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    await fln.cancel(task.notificationData!.id!);
  }

  static Future<void> deleteAllNotifications() async {
    // implementar delete all
  }
}
