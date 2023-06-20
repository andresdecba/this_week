import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/utils/helpers.dart';

// instanciar
final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

// cuando la app esta cerrada, no sé bien como se usa...
@pragma('vm:entry-point')
void onSelectNotificationBackground(NotificationResponse notificationResponse) {
  // HACER ALGO...
}

// si la notificacion entra estando en primer plano o segundo plano
void onSelectNotification(NotificationResponse details) async {
  if (details.payload != null) {
    // get payload
    Globals.closedAppPayload = details.payload!;

    // si tocaron el action: navegar a postpose page
    if (details.notificationResponseType == NotificationResponseType.selectedNotificationAction) {
      if (details.actionId.toString() == 'notificationPostponeACTION') {
        Get.offAllNamed(Routes.POSTPOSE_PAGE);
      }
    }

    // si tocaron el body: navegar a initial page
    if (details.notificationResponseType == NotificationResponseType.selectedNotification) {
      openAnyTask(details.payload!);
    }
  } else {
    return;
  }
}

class InitializeLocalNotificationsService {
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