import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/core/routes/routes.dart';

// instanciar
final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

// cuando la app esta cerrada, no sé bien como se usa...
@pragma('vm:entry-point')
void onSelectNotificationBackground(NotificationResponse notificationResponse) {
  // HACER ALGO...
}

// si la notificacion entra estando en primer plano o segundo plano
void onSelectNotification(NotificationResponse details) {
  //set args
  Map<String, String>? arguments;
  if (details.payload != null) {
    arguments = {'notificationPAYLOAD': details.payload!}; //en el payload llega el task id de hive
  }
  // si tocaron del action
  if (details.notificationResponseType == NotificationResponseType.selectedNotificationAction) {
    if (details.actionId.toString() == 'notificationPostponeACTION') {
      Get.offAllNamed(Routes.POSTPOSE_PAGE, arguments: arguments);
    }
  }
  // si tocaron el body
  if (details.notificationResponseType == NotificationResponseType.selectedNotification) {
    if (arguments != null) {
      Get.offAllNamed(Routes.FORMS_PAGE, arguments: arguments);
    }
    if (arguments == null) {
      Get.offAllNamed(Routes.INITIAL_PAGE);
    }
  }
}

class LocalNotificationService {
  // inicializar el servicio
  static Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        // onDidReceiveLocalNotification: (id, title, body, payload) {
        // setear aqui el payload
        // },
        );
    // settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    // inicializar el plugin
    await localNotifications.initialize(
      // settings
      initializationSettings,
      // abre la app estando en primer o segundo plano
      onDidReceiveNotificationResponse: onSelectNotification,

      // NO SÉ COMO SE USA: ejecuta algo algo sin abrir la app (background isolate)
      onDidReceiveBackgroundNotificationResponse: onSelectNotificationBackground,
      /* FROM DOCS: The [onDidReceiveNotificationResponse] callback is fired when the user selects a notification or notification action that should show the application/user interface. application was running. To handle when a notification launched an application, use [getNotificationAppLaunchDetails]. For notification actions that don't show the application/user interface, the [onDidReceiveBackgroundNotificationResponse] callback is invoked on a background isolate. Functions passed to the [onDidReceiveBackgroundNotificationResponse] callback need to be annotated with the @pragma('vm:entry-point') annotation to ensure they are not stripped out by the Dart compiler.*/
    );
    
  }

  // borrar una notificacion
  static Future deleteNotification(int id) async {
    await localNotifications.cancel(id);
  }

  // borrar una notificacion
  static Future deleteAllNotifications() async {
    await localNotifications.cancelAll();
  }

  // crear notificacion programada
  static Future createNotificationScheduled({
    required String payload,
    required int id,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
    required DateTime time,
  }) async {
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
            titleColor: Colors.blue,
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ],
      ),
    );

    // programar lanzamiento
    await fln.zonedSchedule(
      id,
      body, // titulo
      'task reminder'.tr, // body
      tz.TZDateTime.from(time, tz.local),
      notificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }
}

/*
Tutorial: https://www.youtube.com/watch?v=g2V7y0eTTSE

****** IMPORTANTE ******
in android\app\src\main\AndroidManifest.xml add this:
************************

<meta-data 
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="my_channel_id"
/>

<intent-filter>
    <action android:name="FLUTTER_NOTIFICATION_CLICK"/>
    <category android:name="android.internet.category.DEFAULT"/>
</intent-filter>

*/