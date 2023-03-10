import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/core/bindings/initial_page_week_binding.dart';
import 'package:todoapp/core/localizations/translations.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/models/my_app_config.dart';
import 'package:todoapp/services/local_notifications_service.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_a.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart'; //get the local timezone of the os
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart'; // <-- NOOO BORRAR aunuqe salga que no se usa x sí se usa

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

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
  // remove before upload app ?
  var devices = ["4C456C78BB5CAFE90286C23C5EA6A3CC"];
  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
}

Future<void> initAppConfig() async {
  // get box
  Box<MyAppConfig> userPrefs = Boxes.getMyAppConfigBox();
  // if config file doenst exists, creat it
  if (!userPrefs.get('appConfig')!.isInBox) {
    var value = MyAppConfig();
    userPrefs.put('appConfig', value);
  }
  // set language
  MyAppConfig config = userPrefs.get('appConfig')!;
  print('Language setted: ${config.language}');
  Get.locale = config.language == "" ? Get.deviceLocale : Locale(config.language!, '');
}

// //set timezone
// setalgo() async {
//   tz.initializeTimeZones();
//   tz.setLocalLocation(
//     tz.getLocation(
//       await FlutterNativeTimezone.getLocalTimezone(),
//   ));
// }

void main() async {
  // flutter
  WidgetsFlutterBinding.ensureInitialized();
  // Hive
  await initHive();
  // local notifications
  await LocalNotificationService.initializePlatformNotifications(localNotifications);
  // google ads
  await initAdMob();
  // language muust be init AFTER hive!
  await initAppConfig();
  // run app
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weekly tasks',
      initialBinding: InitialPageBinding(),
      getPages: AppPages.getPages,
      translations: TranslationService(),
      locale: Get.locale,
      fallbackLocale: const Locale('en', ''),
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
        Locale('pt', ''), // Portoguese, no country code
      ],
      localizationsDelegates: const [
        //AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        //iconTheme: IconThemeData(color: black_bg),
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
      home: const InitialPageA(),
    );
  }
}
