import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/notification_model.dart';
import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/models/app_config_model.dart';
import 'package:todoapp/services/local_notifications_service.dart';
// needed for notifications, get the local timezone of the os
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class InitMain {
  ///// HIVE /////
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(SubTaskModelAdapter());
    Hive.registerAdapter(NotificationModelAdapter());
    await Hive.openBox<TaskModel>('tasksBox');
    Hive.registerAdapter(AppConfigModelAdapter());
    await Hive.openBox<AppConfigModel>('myAppConfigBox');
  }

  ///// GOOGLE ADS /////
  static Future<void> initAdMob() async {
    // initializa
    await MobileAds.instance.initialize();

    // antes de publicar: cometar las siguientes lineas (dispositivos de prueba):
    var devices = ["4C456C78BB5CAFE90286C23C5EA6A3CC"];
    RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }

  ///// USER CONFIG /////
  static Future<void> initAppConfig() async {
    // if config file doenst exists, creat it
    if (userPrefs.get('appConfig') == null) {
      var value = AppConfigModel();
      userPrefs.put('appConfig', value);
    }
    // set language whether it is stored or not

    Get.locale = config.language == null ? Get.deviceLocale : Locale(config.language!, '');
    Intl.defaultLocale = Get.locale!.languageCode;
  }

  ///// NOTIFICATIONS /////
  static Future<void> initNotifications() async {
    // inicializar las notificaciones
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation(
        await FlutterNativeTimezone.getLocalTimezone(),
      ),
    );
    InitializeLocalNotificationsService.initializePlatformNotifications();

    // navegar cuando esta cerrada la app
    final notificationLaunchDetails = await localNotifications.getNotificationAppLaunchDetails();

    // si la app esta CERRADA y fue lanzada via la notificacion, entra acá:
    if (notificationLaunchDetails?.didNotificationLaunchApp ?? false) {
      final details = notificationLaunchDetails!.notificationResponse!;
      // llega payload
      if (details.payload != null) {
        notificationPayload = details.payload!;
      }
      // si tocaron el action de la notificacion
      if (details.notificationResponseType == NotificationResponseType.selectedNotificationAction) {
        // si tocaron el action de posponer
        if (details.actionId.toString() == 'notificationPostponeACTION' && notificationPayload != null) {
          initialRoute = Routes.POSTPOSE_PAGE;
        }
      }
      // si tocaron el body de la notificacion
      if (details.notificationResponseType == NotificationResponseType.selectedNotification) {
        if (notificationPayload != null) {
          initialRoute = Routes.FORMS_PAGE;
        }
        if (notificationPayload == null) {
          initialRoute = Routes.INITIAL_PAGE;
        }
      }
      // borrar la notificacion de la barra de notificaciones
      localNotifications.cancel(details.id!);
    }
  }
}
