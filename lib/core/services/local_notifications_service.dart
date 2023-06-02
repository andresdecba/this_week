import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/shared_components/my_modal_bottom_sheet.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';

// instanciar
final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

// cuando la app esta cerrada, no sé bien como se usa...
@pragma('vm:entry-point')
void onSelectNotificationBackground(NotificationResponse notificationResponse) {
  // HACER ALGO...
}

// si la notificacion entra estando en primer plano o segundo plano
void onSelectNotification(NotificationResponse details) async {
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
      // abrir el  bottom sheet //
      Box<TaskModel> tasksBox = Boxes.getTasksBox();
      var task = tasksBox.get(int.parse(details.payload!));
      Rx<TaskModel> e = task!.obs;
      Get.put(ViewTaskController(task: e));
      myModalBottomSheet(
        context: Get.context!,
        child: const ViewTask(),
      );
      Get.toNamed(Routes.INITIAL_PAGE);
      // abrir el  bottom sheet //
    }
    if (arguments == null) {
      Get.toNamed(Routes.INITIAL_PAGE);
    }
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