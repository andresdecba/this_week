import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/core/bindings/initial_page_week_binding.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/services/local_notifications_service.dart';

import 'package:flutter_native_timezone/flutter_native_timezone.dart'; //get the local timezone of the os
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/ui/commons/styles.dart';

import 'package:todoapp/ui/initial_page/initial_page_a.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

void main() async {
  // flitter
  WidgetsFlutterBinding.ensureInitialized();
  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(SubTaskAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  // local notifications
  await LocalNotificationService.initializePlatformNotifications(localNotifications);

  //set timezone
  tz.initializeTimeZones();
  tz.setLocalLocation(
    tz.getLocation(
      await FlutterNativeTimezone.getLocalTimezone(),
    ),
  );
  // run app
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialBinding: InitialPageBinding(),
      getPages: AppPages.getPages,
      home: const InitialPageA(), //InitialPage(),
      theme: ThemeData(
        //iconTheme: IconThemeData(color: black_bg),
        primaryTextTheme: Typography().white,
        scaffoldBackgroundColor: grey_bg,
        appBarTheme: const AppBarTheme(
          backgroundColor: yellow_primary,
          iconTheme: IconThemeData(color: enabled_grey),
          toolbarTextStyle: TextStyle(color: black_bg),
          titleTextStyle: TextStyle(color: black_bg, fontSize: 16),
        ),
      ),
    );
  }
}
