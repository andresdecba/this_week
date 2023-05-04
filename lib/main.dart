import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/core/bindings/initial_page_binding.dart';
import 'package:todoapp/core/localizations/translations.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/models/my_app_config.dart';
import 'package:todoapp/services/local_notifications_service.dart';
import 'package:todoapp/ui/commons/styles.dart';
// needed for notifications, get the local timezone of the os
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// ignore: depend_on_referenced_packages, NOOO BORRAR aunuqe salga que no se usa x sí se usa
import 'package:flutter_localizations/flutter_localizations.dart';

String? notificationPayload; //en el payload llega el task id de hive
String? initialRoute;
Box<MyAppConfig> userPrefs = Boxes.getMyAppConfigBox();
MyAppConfig config = userPrefs.get('appConfig')!;

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SubTaskAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  Hive.registerAdapter(MyAppConfigAdapter());
  await Hive.openBox<MyAppConfig>('myAppConfigBox');
}

Future<void> initAdMob() async {
  // initializa
  await MobileAds.instance.initialize();

  /// TODO antes de publicar: cometar las siguientes lineas (dispositivos de prueba):
  var devices = ["4C456C78BB5CAFE90286C23C5EA6A3CC"];
  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  /// TODO antes de publicar: cambiar los ids de ad de prueba por los reales en
  /// [InitialPageController] y [FormsPageController] => [BannerAd]
}

Future<void> initAppConfig() async {
  // if config file doenst exists, creat it
  if (userPrefs.get('appConfig') == null) {
    var value = MyAppConfig();
    userPrefs.put('appConfig', value);
  }
  // set language whether it is stored or not

  Get.locale = config.language == null ? Get.deviceLocale : Locale(config.language!, '');
  Intl.defaultLocale = Get.locale!.languageCode;
}

//ini tnotifications
Future<void> initNotifications() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(
    tz.getLocation(
      await FlutterNativeTimezone.getLocalTimezone(),
    ),
  );

  // navegar cuando esta cerrada la app
  LocalNotificationService.initializePlatformNotifications();
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

// en cuerpo de notif: NotificationResponseType.selectedNotification
// en action         : NotificationResponseType.selectedNotificationAction

void main() async {
  // flutter
  WidgetsFlutterBinding.ensureInitialized();
  // Hive
  await initHive();
  // google ads
  await initAdMob();
  // language must be init AFTER hive!
  await initAppConfig();
  // needed for local notifications
  await initNotifications();
  // prevent portrait orientation and then run app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'This Week Calendar',
      initialBinding: InitialPageBinding(),
      getPages: AppPages.getPages,
      translations: TranslationService(),
      locale: Get.locale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
        Locale('pt', ''), // Portoguese, no country code
      ],
      localizationsDelegates: const [
        //AppLocalizations.delegate,
        //DefaultWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        dividerColor: Colors.transparent,
        primaryTextTheme: Typography().white,
        scaffoldBackgroundColor: grey_bg,
        appBarTheme: const AppBarTheme(
          backgroundColor: yellow_primary,
          iconTheme: IconThemeData(color: black_bg),
          toolbarTextStyle: TextStyle(color: black_bg),
          titleTextStyle: TextStyle(color: black_bg, fontSize: 16),
          elevation: 0,
        ),
      ),
      //initialRoute: initialRoute ?? (config.isOnboardingDone ? Routes.INITIAL_PAGE : Routes.ONBOARDING_PAGE),
      initialRoute: setInitialRoute(),
    );
  }
}

String setInitialRoute() {
  if (!config.isOnboardingDone) {
    return Routes.ONBOARDING_PAGE;
  }
  if (initialRoute != null) {
    return initialRoute!;
  }
  return Routes.INITIAL_PAGE;
}
