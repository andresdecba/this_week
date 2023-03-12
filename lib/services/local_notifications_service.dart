
//********************************************************
//******* CONFIGURACION BASICA PARA NOTIFICACIONES *******
//********************************************************

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/main.dart';

// instanciar el plugin de notificaciones
final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  //
  // llamar a esta funcion desde el main()
  static Future<void> initializePlatformNotifications(FlutterLocalNotificationsPlugin localNotifications) async {
    // android init
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
    // ios init
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        // onDidReceiveLocalNotification: (id, title, body, payload) {
        // setear aqui el payload
        // },
        );
    // settings init
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    // inicializar el plugin de notificaciones
    await localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // accion al hacer click en la notificacion
        navigatorKey.currentState!.pushNamed(details.payload!);
      },
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   // accion al hacer click en la notificacion
      //   navigatorKey.currentState!.pushNamed(details.payload!);
      // },
    );
  }

  // funcion para disparar la notificacion al instante
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

  // funcion para disparar la notificacion programada
  static Future showtNotificationScheduled({
    required String payload,
    required int id, // identificado unico, si hay dos con el mismo id, se sobreecriben
    //required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
    required DateTime time,
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
  static Future deleteNotification( int id )async {
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