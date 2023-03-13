//********************************************************
//******* CONFIGURACION BASICA PARA NOTIFICACIONES *******
//********************************************************

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/core/routes/routes.dart';

// instanciar el plugin de notificaciones
final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.payload != null) {
    Map<String, String> data = {
      "taskId": notificationResponse.payload!,
    };
    Get.offAndToNamed(Routes.FORMS_PAGE, arguments: data);
  }
}

class LocalNotificationService {
  //
  ////// INICIALIZAR //////
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
      // accion al hacer click en la notificacion en segundo plano?
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,

      // accion en primer y segundo plano
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        if (notificationResponse.payload != null) {
          Map<String, String> data = {
            "taskId": notificationResponse.payload!,
          };
          Get.offAndToNamed(Routes.FORMS_PAGE, arguments: data);
        }
      },      
    );
  }

  ////// DISPARAR NOTIFICACIONES //////
  static Future showtNotificationNow({
    required String payload,
    required int id, // identificado unico, si hay dos con el mismo id, se sobreecriben
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'my_channel_id',
        'my_channel_name',
        playSound: true,
        //sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await fln.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future showtNotificationScheduled({
    required String payload,
    required int id, // identificado unico, si hay dos con el mismo id, se sobreecriben
    //required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
    required DateTime time,
  }) async {
    const notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        'my_channel_id',
        'my_channel_name',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        // sound: RawResourceAndroidNotificationSound('notification'),
        // actions: <AndroidNotificationAction>[
        //   AndroidNotificationAction(
        //     'id_1',
        //     'Action 1',
        //     //titleColor: Color.fromARGB(255, 255, 0, 0),
        //     //icon: DrawableResourceAndroidBitmap('first_icon'),
        //     // By default, Android plugin will dismiss the notification when the
        //     // user tapped on a action (this mimics the behavior on iOS).
        //     //cancelNotification: false,
        //     //contextual: true,
        //   ),
        // ],
      ),
    );
    await fln.zonedSchedule(
      id,
      'Tienes una nueva tarea',
      body,
      tz.TZDateTime.from(time, tz.local), //now(tz.local).add(const Duration(seconds: 10)),
      notificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
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