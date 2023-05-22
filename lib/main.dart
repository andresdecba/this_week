import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/core/bindings/initial_page_binding.dart';
import 'package:todoapp/core/init_main.dart';
import 'package:todoapp/core/localizations/translations.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/app_config_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
// ignore: depend_on_referenced_packages, NOOO BORRAR aunuqe salga que no se usa x sí se usa
import 'package:flutter_localizations/flutter_localizations.dart';

String? notificationPayload; //en el payload llega el task id de hive
String initialRoute = Routes.INITIAL_PAGE;
Box<AppConfigModel> userPrefs = Boxes.getMyAppConfigBox();
AppConfigModel config = userPrefs.get('appConfig')!;

void main() async {
  // flutter
  WidgetsFlutterBinding.ensureInitialized();
  // Hive
  await InitMain.initHive();
  // google ads
  await InitMain.initAdMob();
  // language must be init AFTER hive!
  await InitMain.initAppConfig();
  // needed for local notifications
  await InitMain.initNotifications();
  // prevent portrait orientation and then run app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(const MyApp()),
  );
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
          backgroundColor: yellowPrimary,
          iconTheme: IconThemeData(color: blackBg),
          toolbarTextStyle: TextStyle(color: blackBg),
          titleTextStyle: TextStyle(color: blackBg, fontSize: 16),
          elevation: 0,
        ),
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
      initialRoute: !config.isOnboardingDone ? Routes.ONBOARDING_PAGE : initialRoute,
    );
  }
}
